import 'dart:developer';

import 'package:dunno/models/app_user_profile.dart';
import 'package:dunno/stores/firebase/app_user_profile_firebase_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sp_user_repository/sp_user_repository.dart';

part 'app_user_profile_state.dart';

class AppUserProfileCubit extends Cubit<AppUserProfileState> {
  final AppUserProfileFirebaseRepository _appUserProfileRepository = GetIt.instance<AppUserProfileFirebaseRepository>();
  final FirebaseAnalytics _firebaseAnalytics = GetIt.instance<FirebaseAnalytics>();
  final AuthenticationCubit _authenticationCubit = GetIt.instance<AuthenticationCubit>();

  AppUserProfileCubit() : super(const ProfileInitial());

  loadProfile() async {
    try {
      emit(ProfileInitialLoading(state.mainAppUserProfileState.copyWith(message: 'Loading profile')));
      AppUserProfile? userProfile = await _appUserProfileRepository.getUserProfile();

      emit(ProfileInitialLoaded(state.mainAppUserProfileState.copyWith(appUserProfile: userProfile, message: 'Profile Initial Loaded', errorMessage: '')));

      _firebaseAnalytics.setUserId(id: userProfile.uid);
      if (state.mainAppUserProfileState.registerDetails != null) {
        emit(ProfileLoadingFirstTime(state.mainAppUserProfileState.copyWith(message: 'Loading profile')));
        await Future.delayed(const Duration(seconds: 3));
        await updateProfile(state.mainAppUserProfileState.appUserProfile!.copyWith(
          name: state.mainAppUserProfileState.registerDetails!.name,
          surname: state.mainAppUserProfileState.registerDetails!.surname,
          phoneNumber: state.mainAppUserProfileState.registerDetails!.phoneNumber,
        ));

        await _unSaveDetailsFromState();
        emit(ProfileLoadedFirstTime(state.mainAppUserProfileState.copyWith(message: 'Profile Loaded')));
      }
    } on FirebaseException catch (error, stackTrace) {
      if (error.code == 'permission-denied') {
        emit(ProfilePermissionsError(state.mainAppUserProfileState.copyWith(message: '', errorMessage: error.message), stackTrace: stackTrace.toString()));
      }
    } catch (error, stackTrace) {
      emit(ProfileError(state.mainAppUserProfileState.copyWith(message: '', errorMessage: error.toString()), stackTrace: stackTrace.toString()));
    }
  }

  saveAppUserProfileDetailsToState({AppUserProfile? appUserProfile}) {
    emit(SavingDetailsToState(state.mainAppUserProfileState.copyWith(message: 'Saving user profile')));
    try {
      emit(SavedDetailsToState(state.mainAppUserProfileState.copyWith(registerDetails: appUserProfile, message: 'Updated user profile', errorMessage: '')));
    } catch (error, stackTrace) {
      emit(ProfileError(state.mainAppUserProfileState.copyWith(message: '', errorMessage: error.toString()), stackTrace: stackTrace.toString()));
    }
  }

  clearState() async {
    emit(const ProfileInitial());
  }

  _unSaveDetailsFromState() {
    emit(UnsavedDetailsFromState(state.mainAppUserProfileState.copyWithNullRegisterDetails(registerDetails: null, message: '', errorMessage: '')));
  }

  updateProfile(AppUserProfile appUserProfile, {bool myProfile = true}) async {
    emit(ProfileUpdating(state.mainAppUserProfileState.copyWith(message: 'Updating user profile: UserProfile( ${appUserProfile.uid})', errorMessage: '')));
    try {
      List<AppUserProfile>? profiles = state.mainAppUserProfileState.allProfiles ?? [];
      int index = profiles.indexWhere((element) => element.uid == appUserProfile.uid);
      if (index != -1) {
        profiles[index] = appUserProfile;
      }
      await _appUserProfileRepository.updateUserProfile(userProfile: appUserProfile);

      if (myProfile) {
        emit(ProfileUpdated(state.mainAppUserProfileState.copyWith(appUserProfile: appUserProfile, message: 'Updated user profile', errorMessage: '')));
      } else {
        emit(ProfileUpdated(state.mainAppUserProfileState.copyWith(message: 'Updated user profile', errorMessage: '')));
      }
    } catch (error, stackTrace) {
      emit(ProfileError(state.mainAppUserProfileState.copyWith(errorMessage: error.toString(), message: ''), stackTrace: stackTrace.toString()));
    }
  }

  updateUserPushToken({required String? pushToken}) {
    if (state.mainAppUserProfileState.appUserProfile != null) {
      _appUserProfileRepository.updateUserProfile(userProfile: state.mainAppUserProfileState.appUserProfile!.copyWith(pushToken: pushToken));
    }
  }

  deleteUserProfile(AppUserProfile user, String password) async {
    emit(DeletingUserProfile(state.mainAppUserProfileState.copyWith(message: 'Deleting user profile', errorMessage: '')));
    try {
      await _appUserProfileRepository.deleteUserProfile(user);
      await _authenticationCubit.reauthenticateWithEmailForDeletion(password: password, email: state.mainAppUserProfileState.appUserProfile?.email ?? '');
      emit(UserProfileDeleted(state.mainAppUserProfileState.copyWith(message: 'Profile deleted', errorMessage: '')));
    } catch (error, stackTrace) {
      emit(ProfileError(state.mainAppUserProfileState.copyWith(message: '', errorMessage: error.toString()), stackTrace: stackTrace.toString()));
    }
  }

  quickDeleteProfile() async {
    await _appUserProfileRepository.deleteUserProfile(state.mainAppUserProfileState.appUserProfile!);
    await _authenticationCubit.deleteUserAccount();
    _authenticationCubit.loggedOut(clearPreferences: true);
  }

  loadAllProfiles() async {
    emit(LoadingAllProfiles(state.mainAppUserProfileState.copyWith(message: 'Loading all profile', errorMessage: '')));
    try {
      List<AppUserProfile> allProfiles = await _appUserProfileRepository.loadAllProfiles();
      emit(LoadedAllProfiles(state.mainAppUserProfileState.copyWith(allProfiles: allProfiles, message: 'Loaded all profiles', errorMessage: '')));
    } catch (error, stackTrace) {
      emit(ProfileError(state.mainAppUserProfileState.copyWith(message: '', errorMessage: error.toString()), stackTrace: stackTrace.toString()));
    }
  }

  selectProfile(AppUserProfile profile) {
    emit(SelectedProfile(state.mainAppUserProfileState.copyWith(selectedProfile: profile, message: 'Loading all profile', errorMessage: '')));
  }

  clearSelectedProfile() {
    emit(ClearedSelectedProfile(state.mainAppUserProfileState.copyWithNull(selectedProfile: null, message: 'Loading all profile', errorMessage: '')));
  }

  Future<void> setHasSeenOnboarding() async {
    final profile = state.mainAppUserProfileState.appUserProfile;
    if (profile == null) return;
    final updatedProfile = profile.copyWith(hasSeenOnboarding: true);
    await updateProfile(updatedProfile);
  }
}

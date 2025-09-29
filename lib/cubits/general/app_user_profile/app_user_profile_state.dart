part of 'app_user_profile_cubit.dart';

class MainAppUserProfileState extends Equatable {
  final String? message;
  final String? errorMessage;
  final AppUserProfile? appUserProfile;
  final AppUserProfile? registerDetails;
  final List<AppUserProfile>? allProfiles;
  final AppUserProfile? selectedProfile;

  const MainAppUserProfileState({this.message, this.errorMessage, this.appUserProfile, this.registerDetails, this.allProfiles, this.selectedProfile});

  @override
  List<Object?> get props => [message, errorMessage, appUserProfile, registerDetails, allProfiles, selectedProfile];

  MainAppUserProfileState copyWith({
    String? message,
    String? errorMessage,
    AppUserProfile? appUserProfile,
    AppUserProfile? registerDetails,
    List<AppUserProfile>? allProfiles,
    AppUserProfile? selectedProfile,
  }) {
    return MainAppUserProfileState(
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
      appUserProfile: appUserProfile ?? this.appUserProfile,
      registerDetails: registerDetails ?? this.registerDetails,
      allProfiles: allProfiles ?? this.allProfiles,
      selectedProfile: selectedProfile ?? this.selectedProfile,
    );
  }

  MainAppUserProfileState copyWithNullRegisterDetails({
    String? message,
    String? errorMessage,
    AppUserProfile? appUserProfile,
    AppUserProfile? registerDetails,
    List<AppUserProfile>? allProfiles,
    AppUserProfile? selectedProfile,
  }) {
    return MainAppUserProfileState(
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
      appUserProfile: appUserProfile ?? this.appUserProfile,
      registerDetails: registerDetails,
      allProfiles: allProfiles,
      selectedProfile: selectedProfile,
    );
  }

  MainAppUserProfileState copyWithNull({
    String? message,
    String? errorMessage,
    AppUserProfile? appUserProfile,
    AppUserProfile? registerDetails,
    List<AppUserProfile>? allProfiles,
    AppUserProfile? selectedProfile,
    List<AppUserProfile>? searchedUsers,
  }) {
    return MainAppUserProfileState(
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
      appUserProfile: appUserProfile ?? this.appUserProfile,
      registerDetails: registerDetails ?? this.registerDetails,
      allProfiles: allProfiles ?? this.allProfiles,
      selectedProfile: selectedProfile,
    );
  }
}

abstract class AppUserProfileState extends Equatable {
  final MainAppUserProfileState mainAppUserProfileState;

  const AppUserProfileState(this.mainAppUserProfileState);

  @override
  List<Object> get props => [mainAppUserProfileState];
}

class ProfileInitial extends AppUserProfileState {
  const ProfileInitial() : super(const MainAppUserProfileState());
}

class ProfileInitialLoading extends AppUserProfileState {
  const ProfileInitialLoading(super.mainProfileState);
}

class ProfileInitialLoaded extends AppUserProfileState {
  const ProfileInitialLoaded(super.mainProfileState);
}

class ProfileLoading extends AppUserProfileState {
  const ProfileLoading(super.mainProfileState);
}

class ProfileLoaded extends AppUserProfileState {
  const ProfileLoaded(super.mainProfileState);
}

class ProfileUpdating extends AppUserProfileState {
  const ProfileUpdating(super.mainProfileState);
}

class ProfileUpdated extends AppUserProfileState {
  const ProfileUpdated(super.mainProfileState);
}

class ProfileLoadingFirstTime extends AppUserProfileState {
  const ProfileLoadingFirstTime(super.mainProfileState);
}

class ProfileLoadedFirstTime extends AppUserProfileState {
  const ProfileLoadedFirstTime(super.mainProfileState);
}

class SavingDetailsToState extends AppUserProfileState {
  const SavingDetailsToState(super.mainProfileState);
}

class SavedDetailsToState extends AppUserProfileState {
  const SavedDetailsToState(super.mainProfileState);
}

class UnsavedDetailsFromState extends AppUserProfileState {
  const UnsavedDetailsFromState(super.mainProfileState);
}

class DeletingUserProfile extends AppUserProfileState {
  const DeletingUserProfile(super.mainAppUserProfileState);
}

class UserProfileDeleted extends AppUserProfileState {
  const UserProfileDeleted(super.mainAppUserProfileState);
}

class SavingBookMarkedItem extends AppUserProfileState {
  const SavingBookMarkedItem(super.mainAppUserProfileState);
}

class SavedBookMarkedItem extends AppUserProfileState {
  const SavedBookMarkedItem(super.mainAppUserProfileState);
}

class SelectedRoleFilter extends AppUserProfileState {
  const SelectedRoleFilter(super.mainAppUserProfileState);
}

class LoadingAllProfiles extends AppUserProfileState {
  const LoadingAllProfiles(super.mainAppUserProfileState);
}

class LoadedAllProfiles extends AppUserProfileState {
  const LoadedAllProfiles(super.mainAppUserProfileState);
}

class SelectedProfile extends AppUserProfileState {
  const SelectedProfile(super.mainAppUserProfileState);
}

class ClearedSelectedProfile extends AppUserProfileState {
  const ClearedSelectedProfile(super.mainAppUserProfileState);
}

class SearchingForUsers extends AppUserProfileState {
  const SearchingForUsers(super.mainAppUserProfileState);
}

class SearchingForUsersComplete extends AppUserProfileState {
  const SearchingForUsersComplete(super.mainAppUserProfileState);
}

class ClearUserSearch extends AppUserProfileState {
  const ClearUserSearch(super.mainAppUserProfileState);
}

class GettingProfileCount extends AppUserProfileState {
  const GettingProfileCount(super.mainAppUserProfileState);
}

class GotProfileCount extends AppUserProfileState {
  const GotProfileCount(super.mainAppUserProfileState);
}

class SavingFavouriteSocialRide extends AppUserProfileState {
  const SavingFavouriteSocialRide(super.mainAppUserProfileState);
}

class SavedFavouriteSocialRide extends AppUserProfileState {
  const SavedFavouriteSocialRide(super.mainAppUserProfileState);
}

class ProfileError extends AppUserProfileState {
  final String? stackTrace;

  ProfileError(MainAppUserProfileState mainProfileState, {this.stackTrace}) : super(mainProfileState) {
    if (kDebugMode) {
      log('ERROR: ${mainProfileState.errorMessage!}');
      log('ERROR: $stackTrace');
    }
  }
}

class ProfilePermissionsError extends AppUserProfileState {
  final String? stackTrace;

  ProfilePermissionsError(MainAppUserProfileState mainProfileState, {this.stackTrace}) : super(mainProfileState) {
    if (kDebugMode) {
      log('ERROR: ${mainProfileState.errorMessage!}');
      log('ERROR: $stackTrace');
    }
  }
}

import 'package:dunno/constants/constants.dart';
import 'package:dunno/constants/routes.dart';
import 'package:dunno/constants/themes.dart';
import 'package:dunno/cubits/app_user_profile/app_user_profile_cubit.dart';
import 'package:dunno/cubits/collections/collection_cubit.dart';
import 'package:dunno/models/app_user_profile.dart';
import 'package:dunno/ui/widgets/collection_card.dart';
import 'package:dunno/ui/widgets/dunno_alert_dialog.dart';
import 'package:dunno/ui/widgets/dunno_button.dart';
import 'package:dunno/ui/widgets/dunno_extended_image.dart';
import 'package:dunno/ui/widgets/dunno_image_uploading_tile.dart';
import 'package:dunno/ui/widgets/loading_indicator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sp_user_repository/sp_user_repository.dart';
import 'package:sp_utilities/utilities.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AppUserProfileCubit _appUserProfileCubit = sl<AppUserProfileCubit>();
  final SPFileUploaderCubit _imageUploaderCubit = sl<SPFileUploaderCubit>();
  final AuthenticationCubit _authenticationCubit = sl<AuthenticationCubit>();
  final CollectionCubit _collectionCubit = sl<CollectionCubit>();

  String? _downloadUrl;

  _updateProfilePicture({required bool cameraFlag}) async {
    Navigator.of(context).pop();
    Reference storageReference = sl<FirebaseStorage>().ref().child('user').child(_appUserProfileCubit.state.mainAppUserProfileState.appUserProfile!.uid!);
    if (cameraFlag == true) {
      _imageUploaderCubit.singleSelectImageFromCameraToUploadToReference(storageRef: storageReference);
    } else {
      _imageUploaderCubit.singleSelectImageFromGalleryToUploadToReference(storageRef: storageReference);
    }
  }

  _deleteImage() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return DunnoAlertDialog(
          title: 'Delete Profile Image',
          actionTitle: 'Yes',
          content: 'Are you sure you want to delete profile image?',
          action: () {
            AppUserProfile appUserProfile = _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile!;
            _downloadUrl = null;
            _appUserProfileCubit.updateProfile(appUserProfile.copyWith(profilePicture: ''));
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  _addProfilePhoto() {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24.0))),
      backgroundColor: AppColors.offWhite,
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.photo_camera_outlined, color: Colors.black),
                    title: Text('Take Photo', style: Theme.of(context).textTheme.bodyLarge),
                    onTap: () => _updateProfilePicture(cameraFlag: true),
                  ),
                  ListTile(
                    leading: const Icon(Icons.image_outlined, color: Colors.black),
                    title: Text('Choose Photo', style: Theme.of(context).textTheme.bodyLarge),
                    onTap: () => _updateProfilePicture(cameraFlag: false),
                  ),
                  Offstage(
                    offstage: !(_appUserProfileCubit.state.mainAppUserProfileState.appUserProfile != null && _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile!.profilePicture != null && _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile!.profilePicture != ''),
                    child: Column(
                      children: [
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.delete_outline, color: Colors.black),
                          title: Text('Remove Photo', style: Theme.of(context).textTheme.bodyLarge),
                          onTap: () {
                            Navigator.pop(context);
                            _deleteImage();
                          },
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.close, color: Colors.black),
                    title: Text('Cancel', style: Theme.of(context).textTheme.bodyLarge),
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  _profilePicture() {
    return BlocConsumer<SPFileUploaderCubit, SPFileUploaderState>(
      bloc: _imageUploaderCubit,
      listener: (context, state) {
        if (state is SPFileUploaderAllUploadTaskCompleted) {
          _downloadUrl = state.mainSPFileUploadState.downloadUrls?.first;
          if (_appUserProfileCubit.state.mainAppUserProfileState.appUserProfile != null) {
            final AppUserProfile appUserProfile = _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile!.copyWith(profilePicture: _downloadUrl);
            _appUserProfileCubit.updateProfile(appUserProfile);
          }
          setState(() {});
        }

        if (state is SPFileUploaderErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.mainSPFileUploadState.errorMessage ?? state.mainSPFileUploadState.message ?? '')));
        }
      },
      builder: (context, state) {
        if (state.mainSPFileUploadState.uploadTasks != null && state.mainSPFileUploadState.uploadTasks!.isNotEmpty) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: state.mainSPFileUploadState.uploadTasks?.length ?? 0,
            itemBuilder: (context, index) {
              return DunnoImageUploadingTile(task: state.mainSPFileUploadState.uploadTasks != null ? state.mainSPFileUploadState.uploadTasks![index] : {'task': null, 'uploadTaskSnapshot': null});
            },
          );
        }

        if (_appUserProfileCubit.state.mainAppUserProfileState.appUserProfile?.profilePicture != null && _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile!.profilePicture!.isNotEmpty && _downloadUrl == null) {
          final String? profilePicture = _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile?.profilePicture != null ? _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile!.profilePicture : null;

          return Column(
            children: <Widget>[
              Column(
                children: [
                  GestureDetector(
                    onTap: () => _addProfilePhoto(),
                    child: Stack(
                      children: <Widget>[
                        profilePicture != null
                            ? SizedBox(
                                width: 200,
                                height: 200,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: DunnoExtendedImage(url: profilePicture),
                                ),
                              )
                            : Container(),
                        Positioned(
                          right: 10,
                          top: 10,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.offWhite,
                              shape: BoxShape.circle,
                              border: Border.fromBorderSide(BorderSide(color: AppColors.offWhite, width: 4)),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.edit, color: AppColors.cinnabar, size: 25),
                              onPressed: () => _addProfilePhoto(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        } else if (_downloadUrl != null) {
          return Column(
            children: <Widget>[
              Column(
                children: [
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () => _addProfilePhoto(),
                        child: SizedBox(
                          width: 200,
                          height: 200,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(75.0),
                            child: DunnoExtendedImage(url: _downloadUrl!),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 10,
                        top: 10,
                        child: Container(
                          decoration: BoxDecoration(color: AppColors.offWhite, shape: BoxShape.circle),
                          child: IconButton(
                            icon: Icon(Icons.edit, color: AppColors.cinnabar, size: 25),
                            onPressed: () => _addProfilePhoto(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        } else {
          return GestureDetector(
            onTap: () => _addProfilePhoto(),
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.fromBorderSide(BorderSide(color: AppColors.offWhite, width: 4)),
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 75,
                        backgroundColor: Colors.grey.shade400,
                        child: Icon(Icons.person, color: Colors.white70, size: 100),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Container(
                        decoration: BoxDecoration(color: AppColors.offWhite, shape: BoxShape.circle),
                        child: IconButton(
                          icon: Icon(Icons.edit, color: AppColors.cinnabar, size: 25),
                          onPressed: () => _addProfilePhoto(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      },
    );
  }

  _deleteProfilePopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DunnoAlertDialog(
          title: 'Delete Profile',
          actionTitle: 'Yes',
          content: 'Are you sure you want to delete this profile?',
          action: () {
            _appUserProfileCubit.quickDeleteProfile();
            Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
          },
        );
      },
    );
  }

  _logOutPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DunnoAlertDialog(
          title: 'Log Out!',
          actionTitle: 'Yes',
          content: 'Are you sure you want to log out of this profile?',
          action: () {
            _authenticationCubit.loggedOut(clearPreferences: true);
            Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
          },
        );
      },
    );
  }

  Widget _profileCollections() {
    return BlocBuilder<CollectionCubit, CollectionState>(
      bloc: _collectionCubit,
      builder: (context, state) {
        final collections = state.mainCollectionState.allUserCollections ?? [];
        final hasCollections = collections.isNotEmpty;
        final displayCount = hasCollections
            ? (collections.length > 3 ? 3 : collections.length)
            : 0;

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Your Collections',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColors.black),
                  ),
                  InkWell(
                    onTap: () => context.pushNamed(COLLECTIONS_SCREEN),
                    child: Text(
                      'View All',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.black,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              if (!hasCollections)
                Text(
                  'No collections found.',
                  style: Theme.of(context).textTheme.bodyMedium,
                )
              else
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    clipBehavior: Clip.none,
                    scrollDirection: Axis.horizontal,
                    itemCount: displayCount,
                    itemBuilder: (context, index) {
                      final collection = collections[index];
                      return Container(
                        margin: EdgeInsets.only(right: index == displayCount - 1 ? 0 : 15),
                        child: CollectionCard(collection: collection));
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  _buildBody(AppUserProfileState state) {
    AppUserProfile profile = state.mainAppUserProfileState.appUserProfile ?? const AppUserProfile();
    return LayoutBuilder(
      builder: (context, constraints) {
        return ListView(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  children: [
                    Container(height: 130, decoration: BoxDecoration(color: AppColors.tangerine)),
                    SizedBox(height: 15),
                    Divider(height: 0, color: AppColors.tangerine),
                  ],
                ),
                Positioned(top: 30, left: 0, right: 0, child: _profilePicture()),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 105),
                  child: Text(
                    '${profile.name ?? ''} ${profile.surname ?? ''}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColors.black),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.people),
                    SizedBox(width: 8),
                    Text(
                      '${profile.connectionCount ?? '0'}',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColors.black),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                DunnoButton(
                  onPressed: () {
                    context.pushNamed(EDIT_PROFILE_SCREEN);
                  },
                  type: ButtonType.secondary,
                  label: 'Edit Profile',
                  icon: Icon(Icons.edit),
                ),
              ],
            ),
            SizedBox(height: 30),
            _profileCollections(),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _collectionCubit.loadAllCollectionsForUser(userUid: _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile?.uid ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          decoration: BoxDecoration(color: AppColors.cinnabar, shape: BoxShape.circle),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        backgroundColor: AppColors.tangerine,
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.logout),
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: () {
                  _logOutPopup();
                },
                child: ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.logout, color: AppColors.cinnabar, size: 20),
                      SizedBox(width: 10),
                      Text('Log Out'),
                    ],
                  ),
                ),
              ),
              PopupMenuItem(
                onTap: () {
                  _deleteProfilePopup();
                },
                child: ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red, size: 20),
                      SizedBox(width: 10),
                      Text('Delete Profile'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: BlocConsumer<AppUserProfileCubit, AppUserProfileState>(
        bloc: _appUserProfileCubit,
        listener: (context, state) {
          if (state is ProfileUpdated) {
            _appUserProfileCubit.loadProfile();
            Navigator.of(context).pop();
            UtilitiesHelper.showSnackBar(context, message: 'Profile Updated', backgroundColor: Colors.green);
          }
        },
        builder: (context, state) {
          if (state is ProfileUpdating) {
            return const LoadingIndicator(message: 'Updating Profile');
          }
          return _buildBody(state);
        },
      ),
    );
  }
}

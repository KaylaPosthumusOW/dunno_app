import 'package:dunno/constants/constants.dart';
import 'package:dunno/constants/routes.dart';
import 'package:dunno/constants/themes.dart';
import 'package:dunno/cubits/app_user_profile/app_user_profile_cubit.dart';
import 'package:dunno/cubits/collections/collection_cubit.dart';
import 'package:dunno/cubits/connections/connection_cubit.dart';
import 'package:dunno/models/app_user_profile.dart';
import 'package:dunno/ui/widgets/collection_card.dart';
import 'package:dunno/ui/widgets/dunno_alert_dialog.dart';
import 'package:dunno/ui/widgets/dunno_button.dart';
import 'package:dunno/ui/widgets/dunno_extended_image.dart';
import 'package:dunno/ui/widgets/dunno_image_uploading_tile.dart';
import 'package:dunno/ui/widgets/loading_indicator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart' hide ConnectionState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sp_user_repository/sp_user_repository.dart';
import 'package:sp_utilities/utilities.dart';

enum _PhotoSource { camera, gallery, remove }

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
  final ConnectionCubit _connectionCubit = sl<ConnectionCubit>();

  String? _downloadUrl;

  Future<void> _chooseAndUploadProfilePhoto() async {
    // 1) Ask user how to add photo
    final source = await showModalBottomSheet<_PhotoSource>(
      context: context,
      backgroundColor: AppColors.offWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (sheetCtx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: Text('Take Photo', style: Theme.of(context).textTheme.bodyLarge),
                onTap: () => Navigator.of(sheetCtx).pop(_PhotoSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.image_outlined),
                title: Text('Choose Photo', style: Theme.of(context).textTheme.bodyLarge),
                onTap: () => Navigator.of(sheetCtx).pop(_PhotoSource.gallery),
              ),
              if (_appUserProfileCubit.state.mainAppUserProfileState.appUserProfile?.profilePicture?.isNotEmpty == true) ...[
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.delete_outline),
                  title: Text('Remove Photo', style: Theme.of(context).textTheme.bodyLarge),
                  onTap: () => Navigator.of(sheetCtx).pop(_PhotoSource.remove),
                ),
              ],
              ListTile(
                leading: const Icon(Icons.close),
                title: Text('Cancel', style: Theme.of(context).textTheme.bodyLarge),
                onTap: () => Navigator.of(sheetCtx).pop(null),
              ),
            ],
          ),
        );
      },
    );

    if (source == null) return; // cancelled
    if (!mounted) return;

    // 2) Handle choice AFTER the sheet has fully closed
    if (source == _PhotoSource.remove) {
      await _deleteImage();
      return;
    }

    final storageReference = sl<FirebaseStorage>()
        .ref()
        .child('user')
        .child(_appUserProfileCubit.state.mainAppUserProfileState.appUserProfile!.uid!);

    try {
      if (source == _PhotoSource.camera) {
        _imageUploaderCubit.singleSelectImageFromCameraToUploadToReference(storageRef: storageReference);
      } else {
        _imageUploaderCubit.singleSelectImageFromGalleryToUploadToReference(storageRef: storageReference);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
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



  _profilePicture() {
    return BlocConsumer<SPFileUploaderCubit, SPFileUploaderState>(
      bloc: _imageUploaderCubit,
      listener: (context, state) async {
        if (state is SPFileUploaderAllUploadTaskCompleted) {
          _downloadUrl = state.mainSPFileUploadState.downloadUrls?.first;
          final profile = _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile;
          if (profile != null) {
            await _appUserProfileCubit.updateProfile(profile.copyWith(profilePicture: _downloadUrl));
          }
          if (!mounted) return;
          setState(() {});
        }

        if (state is SPFileUploaderErrorState) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.mainSPFileUploadState.errorMessage ?? state.mainSPFileUploadState.message ?? 'Upload error')),
            );
          }
        }
      },
      builder: (context, state) {
        if (state.mainSPFileUploadState.uploadTasks != null && state.mainSPFileUploadState.uploadTasks!.isNotEmpty) {
          // Show circular upload progress over the profile picture area
          return DunnoImageUploadingTile(
            task: state.mainSPFileUploadState.uploadTasks!.first,
            size: 200.0,
            isCircular: true,
          );
        }

        if (_appUserProfileCubit.state.mainAppUserProfileState.appUserProfile?.profilePicture != null && _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile!.profilePicture!.isNotEmpty && _downloadUrl == null) {
          final String? profilePicture = _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile?.profilePicture != null ? _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile!.profilePicture : null;

          return Column(
            children: <Widget>[
              Column(
                children: [
                  GestureDetector(
                    onTap: () => _chooseAndUploadProfilePhoto(),
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
                              onPressed: () => _chooseAndUploadProfilePhoto(),
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
                        onTap: () => _chooseAndUploadProfilePhoto(),
                        child: SizedBox(
                          width: 200,
                          height: 200,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
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
                            onPressed: () => _chooseAndUploadProfilePhoto(),
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
            onTap: () => _chooseAndUploadProfilePhoto(),
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
                          onPressed: () => _chooseAndUploadProfilePhoto(),
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
            Navigator.pop(context);
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
                    onTap: () {
                      _appUserProfileCubit.selectProfile(_appUserProfileCubit.state.mainAppUserProfileState.appUserProfile ?? AppUserProfile());
                      context.pushNamed(COLLECTIONS_SCREEN);
                    },
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
                        child: CollectionCard(
                          collection: collection,
                          colorType: CollectionColorType.yellow,
                        ),
                      );
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
                    Container(height: 130, decoration: BoxDecoration(color: AppColors.yellow)),
                    SizedBox(height: 15),
                    Divider(height: 0, color: AppColors.yellow),
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
                BlocBuilder<ConnectionCubit, ConnectionState>(
                  bloc: _connectionCubit,
                  builder: (context, state) {
                    return InkWell(
                      onTap: () {
                        context.pushNamed(USER_FRIENDS_SCREEN);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.people),
                          SizedBox(width: 8),
                          Text(
                            '${state.mainConnectionState.numberOfUserConnections ?? '0'}',
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColors.black),
                          ),
                        ],
                      ),
                    );
                  }
                ),
                SizedBox(height: 20),
                DunnoButton(
                  onPressed: () {
                    context.pushNamed(EDIT_PROFILE_SCREEN);
                  },
                  type: ButtonType.secondary,
                  label: 'Edit Profile',
                  icon: Icon(Icons.edit),
                  buttonColor: AppColors.yellow,
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
    _connectionCubit.countAllUserConnections(userUid: _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile?.uid ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.yellow,
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.logout, color: AppColors.offWhite),
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: () {
                  // schedule after the menu has closed
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _logOutPopup();
                  });
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
                  // schedule after the menu has closed
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _deleteProfilePopup();
                  });
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
            if (mounted) Navigator.of(context).maybePop(); // optional: only if you opened a modal
            if (mounted) UtilitiesHelper.showSnackBar(context, message: 'Profile Updated', backgroundColor: Colors.green);
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

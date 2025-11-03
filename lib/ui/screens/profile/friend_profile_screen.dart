import 'package:dunno/constants/constants.dart';
import 'package:dunno/constants/routes.dart';
import 'package:dunno/constants/themes.dart';
import 'package:dunno/cubits/app_user_profile/app_user_profile_cubit.dart';
import 'package:dunno/cubits/connections/connection_cubit.dart';
import 'package:dunno/models/app_user_profile.dart';
import 'package:dunno/models/connections.dart';
import 'package:dunno/ui/widgets/collection_card.dart';
import 'package:dunno/ui/widgets/custom_header_bar.dart';
import 'package:dunno/ui/widgets/dunno_button.dart';
import 'package:dunno/ui/widgets/dunno_extended_image.dart';
import 'package:flutter/material.dart' hide ConnectionState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dunno/cubits/collections/collection_cubit.dart';
import 'package:go_router/go_router.dart';

class FriendProfileScreen extends StatefulWidget {
  const FriendProfileScreen({super.key});

  @override
  State<FriendProfileScreen> createState() => _FriendProfileScreenState();
}

class _FriendProfileScreenState extends State<FriendProfileScreen> {
  final AppUserProfileCubit _appUserProfileCubit = sl<AppUserProfileCubit>();
  final CollectionCubit _collectionCubit = sl<CollectionCubit>();
  final ConnectionCubit _connectionCubit = sl<ConnectionCubit>();

  @override
  void initState() {
    super.initState();
    
    final selectedProfile = _appUserProfileCubit.state.mainAppUserProfileState.selectedProfile;
    final currentUser = _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile;

    if (selectedProfile?.uid != null && selectedProfile!.uid!.isNotEmpty) {
      _collectionCubit.loadAllCollectionsForUser(userUid: selectedProfile.uid!);
      _connectionCubit.countAllUserConnections(userUid: selectedProfile.uid!);
    }

    if (currentUser?.uid != null && currentUser!.uid!.isNotEmpty) {
      _connectionCubit.loadAllUserConnections(userUid: currentUser.uid!);
    }
  }

  bool _isAlreadyConnected(ConnectionState connectionState, String? friendUid) {
    if (friendUid == null) return false;
    
    final connections = connectionState.mainConnectionState.allUserConnections ?? [];
    return connections.any((connection) =>
      (connection.connectedUser?.uid == friendUid || connection.user?.uid == friendUid)
    );
  }

  Widget _profilePicture(AppUserProfileState profileState) {
    final profilePicture = profileState.mainAppUserProfileState.selectedProfile?.profilePicture;

    return Center(
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.offWhite, width: 4),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: profilePicture != null && profilePicture.isNotEmpty
              ? DunnoExtendedImage(url: profilePicture)
              : CircleAvatar(
            radius: 75,
            backgroundColor: Colors.grey.shade400,
            child: const Icon(Icons.person, color: Colors.white70, size: 100),
          ),
        ),
      ),
    );
  }

  Widget _profileCollections(AppUserProfileState profileState) {
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
                    "${profileState.mainAppUserProfileState.selectedProfile?.name?.split(' ').first ?? 'Their'}'s Collections",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold, color: AppColors.black),
                  ),
                  if (hasCollections)
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
                        child: CollectionCard(
                          collection: collection,
                          colorType: CollectionColorType.pink,
                          onPressed: () {
                            final selectedProfile = _appUserProfileCubit.state.mainAppUserProfileState.selectedProfile;
                            context.pushNamed(
                              FRIEND_GIFT_SUGGESTION_MANAGEMENT,
                              extra: {
                                'friend': selectedProfile?.toMap(),
                                'collection': collection.toMap(),
                              },
                            );
                          },
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

  Widget _buildBody(AppUserProfileState state) {
    final profile = state.mainAppUserProfileState.selectedProfile;

    if (profile == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No profile selected',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Please go back and select a user profile.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              children: [
                CustomHeaderBar(
                  backgroundColor: AppColors.pinkLavender,
                  onBack: () => Navigator.pop(context),
                  backButtonColor: AppColors.cerise,
                  iconColor: AppColors.offWhite,
                ),
                Container(
                  height: 130,
                  decoration: BoxDecoration(color: AppColors.pinkLavender),
                ),
                const SizedBox(height: 15),
                Divider(height: 0, color: AppColors.pinkLavender),
              ],
            ),
            Positioned(top: 120, left: 0, right: 0, child: _profilePicture(state)),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 105),
              child: Text(
                '${profile.name ?? ''} ${profile.surname ?? ''}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
            ),
            const SizedBox(height: 20),
            BlocBuilder<ConnectionCubit, ConnectionState>(
              bloc: _connectionCubit,
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.people),
                    const SizedBox(width: 8),
                    if (state.mainConnectionState.numberOfUserConnections != null && state.mainConnectionState.numberOfUserConnections! > 1)
                      Text(
                        '${state.mainConnectionState.numberOfUserConnections ?? '0'} connections',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        ),
                      )
                    else if (state.mainConnectionState.numberOfUserConnections == 1)
                      Text(
                        '1 connection',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        ),
                      )
                    else
                      Text(
                        '0 connections',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        ),
                      ),
                  ],
                );
              }
            ),
            const SizedBox(height: 20),
            BlocBuilder<ConnectionCubit, ConnectionState>(
              bloc: _connectionCubit,
              builder: (context, connectionState) {
                final currentUser = state.mainAppUserProfileState.appUserProfile;
                final selectedProfile = state.mainAppUserProfileState.selectedProfile;

                if (currentUser?.uid == selectedProfile?.uid) {
                  return const SizedBox.shrink();
                }

                bool isConnected = _isAlreadyConnected(connectionState, selectedProfile?.uid);
                bool isConnecting = connectionState is CreatingConnection;

                String buttonText;
                Color buttonColor;
                Icon buttonIcon;
                bool isButtonDisabled;
                Color textColor;

                if (isConnecting) {
                  buttonText = 'Connecting...';
                  buttonColor = AppColors.tangerine;
                  buttonIcon = Icon(Icons.person_add_alt_1, color: AppColors.offWhite);
                  textColor = AppColors.offWhite;
                  isButtonDisabled = true;
                } else if (isConnected) {
                  buttonText = 'Connected';
                  buttonColor = AppColors.cerise;
                  buttonIcon = Icon(Icons.check_circle, color: AppColors.offWhite);
                  textColor = AppColors.offWhite;
                  isButtonDisabled = true;
                } else {
                  buttonText = 'Connect';
                  buttonColor = AppColors.tangerine;
                  buttonIcon = Icon(Icons.person_add_alt_1, color: AppColors.offWhite);
                  textColor = AppColors.offWhite;
                  isButtonDisabled = false;
                }

                return DunnoButton(
                  onPressed: isButtonDisabled
                      ? () {}
                      : () {
                    _connectionCubit.createNewConnection(
                      Connection(
                        connectedUser: selectedProfile ?? AppUserProfile(),
                        user: currentUser ?? AppUserProfile(),
                      ),
                    );
                  },
                  type: ButtonType.secondary,
                  isLoading: isConnecting,
                  label: buttonText,
                  icon: buttonIcon,
                  buttonColor: buttonColor,
                  textColor: textColor,
                  loadingIndicator: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.offWhite,
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 30),
        _profileCollections(state),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppUserProfileCubit, AppUserProfileState>(
      bloc: _appUserProfileCubit,
      builder: (context, state) {
        return Scaffold(
          body: _buildBody(state),
        );
      }
    );
  }
}

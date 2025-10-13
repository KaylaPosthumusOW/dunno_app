import 'package:dunno/constants/constants.dart';
import 'package:dunno/constants/routes.dart';
import 'package:dunno/constants/themes.dart';
import 'package:dunno/cubits/app_user_profile/app_user_profile_cubit.dart';
import 'package:dunno/cubits/connections/connection_cubit.dart';
import 'package:dunno/models/app_user_profile.dart';
import 'package:dunno/models/connections.dart';
import 'package:dunno/ui/widgets/collection_card.dart';
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
    _collectionCubit.loadAllCollectionsForUser(userUid: _appUserProfileCubit.state.mainAppUserProfileState.selectedProfile?.uid ?? '');
    _connectionCubit.countAllUserConnections(userUid: _appUserProfileCubit.state.mainAppUserProfileState.selectedProfile?.uid ?? '');
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
                          isPink: true,
                          onPressed: () {
                            context.pushNamed(FRIEND_GIFT_SUGGESTION_MANAGEMENT);
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

    return ListView(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              children: [
                Container(
                  height: 130,
                  decoration: BoxDecoration(color: AppColors.pinkLavender),
                ),
                const SizedBox(height: 15),
                Divider(height: 0, color: AppColors.pinkLavender),
              ],
            ),
            Positioned(top: 30, left: 0, right: 0, child: _profilePicture(state)),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 105),
              child: Text(
                '${profile?.name ?? ''} ${profile?.surname ?? ''}',
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
            DunnoButton(
              onPressed: () {
                _connectionCubit.createNewConnection(
                  Connection(
                    connectedUser: state.mainAppUserProfileState.selectedProfile ?? AppUserProfile(),
                    connectionType: ConnectionType.pending,
                    user: state.mainAppUserProfileState.appUserProfile ?? AppUserProfile(),
                  )
                );
              },
              type: ButtonType.secondary,
              label: 'Connect',
              icon: const Icon(Icons.person_add_alt_1),
              buttonColor: AppColors.tangerine,
              textColor: AppColors.offWhite,
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
          appBar: AppBar(
            leading: Container(
              decoration: BoxDecoration(
                color: AppColors.cerise,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: AppColors.offWhite),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            backgroundColor: AppColors.pinkLavender,
            centerTitle: true,
          ),
          body: _buildBody(state),
        );
      }
    );
  }
}

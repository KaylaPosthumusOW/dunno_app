import 'package:dunno/constants/constants.dart';
import 'package:dunno/constants/routes.dart';
import 'package:dunno/constants/themes.dart';
import 'package:dunno/cubits/app_user_profile/app_user_profile_cubit.dart';
import 'package:dunno/cubits/connections/connection_cubit.dart';
import 'package:dunno/models/app_user_profile.dart';
import 'package:flutter/material.dart' hide ConnectionState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class UserProfileCard extends StatefulWidget {
  final AppUserProfile userProfile;
  const UserProfileCard({super.key, required this.userProfile});

  @override
  State<UserProfileCard> createState() => _UserProfileCardState();
}

class _UserProfileCardState extends State<UserProfileCard> {
  final ConnectionCubit _connectionCubit = sl<ConnectionCubit>();

  @override
  Widget build(BuildContext context) {
    final appUserProfileCubit = sl<AppUserProfileCubit>();
    final currentUserUid = appUserProfileCubit.state.mainAppUserProfileState.appUserProfile?.uid ?? '';

    return BlocBuilder<ConnectionCubit, ConnectionState>(
      bloc: _connectionCubit,
      builder: (context, connectionState) {
        final allConnections = connectionState.mainConnectionState.allUserConnections ?? [];
        final isConnected = allConnections.any((connection) {
          final userUid = connection.user?.uid;
          final connectedUserUid = connection.connectedUser?.uid;
          final profileUid = widget.userProfile.uid;

          return (userUid == currentUserUid && connectedUserUid == profileUid) ||
                 (userUid == profileUid && connectedUserUid == currentUserUid);
        });

        return InkWell(
          onTap: () {
            appUserProfileCubit.selectProfile(widget.userProfile);
            context.pushNamed(FRIEND_PROFILE_SCREEN);
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.offWhite,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.cerise, width: 1.5),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.pinkLavender.withValues(alpha: 0.5),
                  backgroundImage: widget.userProfile.profilePicture != null
                      ? NetworkImage(widget.userProfile.profilePicture!)
                      : null,
                  child: widget.userProfile.profilePicture == null
                      ? Icon(Icons.person, size: 30, color: AppColors.cerise)
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${widget.userProfile.name ?? ''} ${widget.userProfile.surname ?? ''}',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 10),
                          if (isConnected)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.tangerine,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.check, color: AppColors.antiqueWhite, size: 16),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.userProfile.email ?? 'No Email',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded,
                    color: AppColors.cerise, size: 25),
              ],
            ),
          ),
        );
      },
    );
  }
}

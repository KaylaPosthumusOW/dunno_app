import 'package:dunno/constants/themes.dart';
import 'package:dunno/models/app_user_profile.dart';
import 'package:flutter/material.dart';

class UserProfileCard extends StatefulWidget {
  final AppUserProfile? userProfile;
  const UserProfileCard({super.key, this.userProfile});

  @override
  State<UserProfileCard> createState() => _UserProfileCardState();
}

class _UserProfileCardState extends State<UserProfileCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
            backgroundImage: widget.userProfile?.profilePicture != null
                ? NetworkImage(widget.userProfile!.profilePicture!)
                : null,
            child: widget.userProfile?.profilePicture == null
                ? Icon(Icons.person, size: 30, color: AppColors.cerise)
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${widget.userProfile?.name ?? 'No Name'} ${widget.userProfile?.surname ?? ''}',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.userProfile?.email ?? 'No Email',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios_rounded, color: AppColors.cerise, size: 25),
        ],
      ),
    );
  }
}

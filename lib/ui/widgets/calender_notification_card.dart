import 'package:dunno/constants/constants.dart';
import 'package:dunno/constants/routes.dart';
import 'package:dunno/constants/themes.dart';
import 'package:dunno/cubits/app_user_profile/app_user_profile_cubit.dart';
import 'package:dunno/models/app_user_profile.dart';
import 'package:dunno/models/calender_events.dart';
import 'package:dunno/ui/widgets/dunno_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sp_utilities/utilities.dart';

class CalenderNotificationCard extends StatefulWidget {
  final CalenderEvent upcomingEvent;

  const CalenderNotificationCard({super.key, required this.upcomingEvent});

  @override
  State<CalenderNotificationCard> createState() => _CalenderNotificationCardState();
}

class _CalenderNotificationCardState extends State<CalenderNotificationCard> {
  final AppUserProfileCubit _appUserProfileCubit = sl<AppUserProfileCubit>();

  String _initials(String? name, String? surname) {
    final n = (name ?? '').trim();
    final s = (surname ?? '').trim();
    if (n.isEmpty && s.isEmpty) return '🙂';
    final first = n.isNotEmpty ? n[0] : '';
    final last = s.isNotEmpty ? s[0] : '';
    return (first + last).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final friend = widget.upcomingEvent.friend;
    final photoUrl = friend?.profilePicture ?? '';
    final title = widget.upcomingEvent.collection?.title?.trim().isNotEmpty == true ? widget.upcomingEvent.collection!.title! : 'Upcoming Event';
    final fullName = [(friend?.name ?? '').trim(), (friend?.surname ?? '').trim()].where((p) => p.isNotEmpty).join(' ').trim();
    final dateText = StringHelpers.printFirebaseTimeStamp(widget.upcomingEvent.collection?.eventCollectionDate, format: 'EEE, dd MMM yyyy');

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.yellow, width: 1.4),
        boxShadow: [BoxShadow(color: AppColors.yellow, offset: const Offset(3, 4))],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 360;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.offWhite, width: 2),
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.yellow,
                  backgroundImage: (photoUrl.isNotEmpty) ? NetworkImage(photoUrl) : null,
                  child: (photoUrl.isEmpty)
                      ? Text(
                          _initials(friend?.name, friend?.surname),
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.black, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 2),

                    if (fullName.isNotEmpty)
                      Text(
                        fullName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.black, fontWeight: FontWeight.w600),
                      ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.event, size: 16, color: Colors.grey),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            dateText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),
              SizedBox(
                height: 40,
                child: DunnoButton(
                  type: ButtonType.saffron,
                  label: compact ? 'Suggest' : 'Get Gift Suggestion',
                  onPressed: () {
                    _appUserProfileCubit.selectProfile(friend ?? AppUserProfile());
                    context.pushNamed(FRIEND_PROFILE_SCREEN);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

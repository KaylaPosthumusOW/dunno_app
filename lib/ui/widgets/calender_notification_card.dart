import 'package:dunno/constants/themes.dart';
import 'package:dunno/models/calender_events.dart';
import 'package:dunno/ui/widgets/dunno_button.dart';
import 'package:flutter/material.dart';
import 'package:sp_utilities/utilities.dart';

class CalenderNotificationCard extends StatelessWidget {
  final CalenderEvent upcomingEvent;

  const CalenderNotificationCard({super.key, required this.upcomingEvent});

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
    final friend = upcomingEvent.friend;
    final photoUrl = friend?.profilePicture ?? '';
    final title = upcomingEvent.collection?.title?.trim().isNotEmpty == true ? upcomingEvent.collection!.title! : 'Upcoming Event';
    final fullName = [(friend?.name ?? '').trim(), (friend?.surname ?? '').trim()].where((p) => p.isNotEmpty).join(' ').trim();
    final dateText = StringHelpers.printFirebaseTimeStamp(upcomingEvent.collection?.eventCollectionDate, format: 'EEE, dd MMM yyyy');

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
              CircleAvatar(
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
                child: DunnoButton(type: ButtonType.saffron, label: compact ? 'Suggest' : 'Get Gift Suggestion', onPressed: () {}),
              ),
            ],
          );
        },
      ),
    );
  }
}

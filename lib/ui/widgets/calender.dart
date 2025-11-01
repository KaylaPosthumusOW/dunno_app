import 'package:dunno/constants/constants.dart';
import 'package:dunno/constants/themes.dart';
import 'package:dunno/cubits/app_user_profile/app_user_profile_cubit.dart';
import 'package:dunno/cubits/calender_event_cubit/calender_event_cubit.dart';
import 'package:dunno/models/calender_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

class ModernCalendar extends StatefulWidget {
  const ModernCalendar({super.key});

  @override
  State<ModernCalendar> createState() => _ModernCalendarState();
}

class _ModernCalendarState extends State<ModernCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final CalenderEventCubit _calenderEventCubit = sl<CalenderEventCubit>();
  final AppUserProfileCubit _appUserProfileCubit = sl<AppUserProfileCubit>();

  @override
  void initState() {
    super.initState();
    _loadCalendarEvents();
  }

  void _loadCalendarEvents() {
    final userUid = _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile?.uid;
    if (userUid != null) {
      _calenderEventCubit.loadAllUserCalenderEvents(userUid: userUid);
    }
  }

  List<CalenderEvent> _getEventsForDay(DateTime day) {
    final events = _calenderEventCubit.state.mainCalenderEventState.allUserCalenderEvents ?? [];
    return events.where((event) {
      if (event.collection?.eventCollectionDate == null) return false;
      final eventDate = event.collection!.eventCollectionDate!.toDate();
      return isSameDay(eventDate, day);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalenderEventCubit, CalenderEventState>(
      bloc: _calenderEventCubit,
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.cerise,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TableCalendar<CalenderEvent>(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                eventLoader: _getEventsForDay,
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                headerStyle: const HeaderStyle(
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  formatButtonVisible: false,
                  leftChevronIcon: Icon(Icons.chevron_left_rounded, color: Colors.white),
                  rightChevronIcon: Icon(Icons.chevron_right_rounded, color: Colors.white),
                ),
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
                  weekendStyle: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
                ),
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: AppColors.tangerine,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: AppColors.tangerine,
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: BoxDecoration(
                    color: AppColors.yellow,
                    shape: BoxShape.circle,
                  ),
                  markersMaxCount: 3,
                  markerMargin: const EdgeInsets.symmetric(horizontal: 1),
                  defaultTextStyle: const TextStyle(color: Colors.white),
                  weekendTextStyle: const TextStyle(color: Colors.white),
                  outsideTextStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
                ),
              ),
              if (_selectedDay != null) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Events for ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ..._buildEventsList(_getEventsForDay(_selectedDay!)),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildEventsList(List<CalenderEvent> events) {
    if (events.isEmpty) {
      return [
        const Text(
          'No events for this day',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ];
    }

    return events.map((event) {
      return Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.yellow.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 12,
              backgroundImage: event.friend?.profilePicture != null
                  ? NetworkImage(event.friend!.profilePicture!)
                  : null,
              child: event.friend?.profilePicture == null
                  ? Text(
                      event.friend?.name?.isNotEmpty == true
                          ? event.friend!.name![0].toUpperCase()
                          : '?',
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    )
                  : null,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.collection?.title ?? 'Untitled Event',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (event.friend?.name != null)
                    Text(
                      event.friend!.name!,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}

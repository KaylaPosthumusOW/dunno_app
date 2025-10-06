import 'package:dunno/constants/themes.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ModernCalendar extends StatefulWidget {
  const ModernCalendar({super.key});

  @override
  State<ModernCalendar> createState() => _ModernCalendarState();
}

class _ModernCalendarState extends State<ModernCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cerise,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(16),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
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
          defaultTextStyle: const TextStyle(color: Colors.white),
          weekendTextStyle: const TextStyle(color: Colors.white),
          outsideTextStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
        ),
      ),
    );
  }
}

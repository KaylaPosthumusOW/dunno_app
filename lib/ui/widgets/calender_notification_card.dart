import 'package:dunno/models/calender_events.dart';
import 'package:flutter/material.dart';

class CalenderNotificationCard extends StatefulWidget {
  final CalenderEvent upcomingEvent;

  const CalenderNotificationCard({super.key, required this.upcomingEvent});

  @override
  State<CalenderNotificationCard> createState() => _CalenderNotificationCardState();
}

class _CalenderNotificationCardState extends State<CalenderNotificationCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: widget.upcomingEvent.friend?.profilePicture != null
              ? NetworkImage(widget.upcomingEvent.friend!.profilePicture!)
              : null,
          child: widget.upcomingEvent.friend?.profilePicture == null
              ? Text(widget.upcomingEvent.friend?.name != null && widget.upcomingEvent.friend!.name!.isNotEmpty
                  ? widget.upcomingEvent.friend!.name![0].toUpperCase()
                  : '?')
              : null,
        ),
        title: Text(widget.upcomingEvent.collection?.title ?? 'No Collection'),
        subtitle: Text('With ${widget.upcomingEvent.friend?.name ?? 'Unknown'}'),
        trailing: Icon(Icons.notifications_active, color: Colors.red),
      ),
    );
  }
}

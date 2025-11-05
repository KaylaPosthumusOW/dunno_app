import 'package:dunno/models/calender_events.dart';
import 'package:dunno/models/collections.dart';

abstract class CalenderEventStore {
  Future<CalenderEvent> createEvent({required CalenderEvent event});
  Future<List<CalenderEvent>> loadAllEventsForUser({required String userId});
  Future<void> updateEvent({required CalenderEvent event});
  Future<void> deleteEvent({required String eventId});
  Future<List<CalenderEvent>> getUpcomingEvents({required String userId});
  Future<void> updateEventsWithCollection({required String collectionUid, required Collections updatedCollection});

}

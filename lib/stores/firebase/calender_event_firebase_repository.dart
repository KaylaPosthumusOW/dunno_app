import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dunno/models/calender_events.dart';
import 'package:dunno/stores/calender_event_store.dart';
import 'package:get_it/get_it.dart';

class CalenderEventFirebaseRepository implements CalenderEventStore {
  static final FirebaseFirestore _firebaseFirestore = GetIt.instance<FirebaseFirestore>();

  final CollectionReference<CalenderEvent> _calenderCollection = _firebaseFirestore.collection('calenderEvent').withConverter<CalenderEvent>(
    fromFirestore: (snapshot, _) => CalenderEvent.fromMap(snapshot.data() ?? {}),
    toFirestore: (map, _) => map.toMap(),
  );

  @override
  Future<CalenderEvent> createEvent({required CalenderEvent event}) async {
    DocumentReference<CalenderEvent> reference = _calenderCollection.doc(event.uid);
    await reference.set(event.copyWith(uid: reference.id), SetOptions(merge: true));
    return event.copyWith(uid: reference.id);
  }

  @override
  Future<List<CalenderEvent>> loadAllEventsForUser({required String userId}) async {
    List<CalenderEvent> events = [];
    QuerySnapshot<CalenderEvent> query = await _calenderCollection.where('user.uid', isEqualTo: userId).orderBy('collection.eventCollectionDate', descending: true).get();
    for (var doc in query.docs) {
      events.add(doc.data());
    }
    return events;
  }

  @override
  Future<void> updateEvent({required CalenderEvent event}) async {
    try {
      await _calenderCollection.doc(event.uid).set(event, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to update event: $e');
    }
  }

  @override
  Future<void> deleteEvent({required String eventId}) async {
    try {
      await _calenderCollection.doc(eventId).delete();
    } catch (e) {
      throw Exception('Failed to delete event: $e');
    }
  }

  @override
  Future<List<CalenderEvent>> getUpcomingEvents({required String userId}) async {
    try {
      final dateNow = Timestamp.now().toDate();
      final dateOneWeekAgo = dateNow.add(const Duration(days: 7));

      final snapshot = await _calenderCollection
          .where('user.uid', isEqualTo: userId)
          .where('collection.eventCollectionDate', isGreaterThanOrEqualTo: dateOneWeekAgo)
          .where('collection.eventCollectionDate', isLessThanOrEqualTo: dateNow)
          .get();

      return snapshot.docs.map((doc) {
        return CalenderEvent.fromMap(doc.data().toMap()..['uid'] = doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching upcoming events: $e');
      rethrow;
    }
  }


}
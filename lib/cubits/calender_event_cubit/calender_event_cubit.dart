import 'package:dunno/constants/constants.dart';
import 'package:dunno/models/calender_events.dart';
import 'package:dunno/stores/firebase/calender_event_firebase_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'calender_event_state.dart';

class CalenderEventCubit extends Cubit<CalenderEventState> {
  final CalenderEventFirebaseRepository _calenderEventFirebaseRepository = sl<CalenderEventFirebaseRepository>();

  CalenderEventCubit() : super(const CalenderEventInitial());

  Future<void> loadAllUserCalenderEvents({required String userUid}) async {
    emit(LoadingCalenderEvent(state.mainCalenderEventState.copyWith(message: 'Loading calender events')));
    try {
      List<CalenderEvent> events = await _calenderEventFirebaseRepository.loadAllEventsForUser(userId: userUid);
      emit(LoadedCalenderEvent(state.mainCalenderEventState.copyWith(allUserCalenderEvents: events, numberOfUserCalenderEvents: events.length, message: 'Loaded ${events.length} calender events')));
    } catch (error, stackTrace) {
      emit(CalenderError(state.mainCalenderEventState.copyWith(message: '', errorMessage: error.toString()), stackTrace: stackTrace.toString()));
    }
  }

  Future<void> createNewCalenderEvent(CalenderEvent newEvent) async {
    emit(CreatingCalenderEvent(state.mainCalenderEventState.copyWith(message: 'Creating new calender event')));
    try {
      List<CalenderEvent> events = List.from(state.mainCalenderEventState.allUserCalenderEvents ?? []);
      CalenderEvent event = await _calenderEventFirebaseRepository.createEvent(event: newEvent);
      events.add(event);
      emit(CreatedCalenderEvent(state.mainCalenderEventState.copyWith(allUserCalenderEvents: events, numberOfUserCalenderEvents: events.length, message: 'New calender event created')));
    } catch (error, stackTrace) {
      emit(CalenderError(state.mainCalenderEventState.copyWith(message: '', errorMessage: error.toString()), stackTrace: stackTrace.toString()));
    }
  }

  Future<void> loadUpcomingEventsNotifications({required String userUid}) async {
    emit(LoadingUpcomingEventsNotifications(state.mainCalenderEventState.copyWith(message: 'Loading upcoming events notifications')));
    try {
      List<CalenderEvent> events = await _calenderEventFirebaseRepository.getUpcomingEvents(userId: userUid);
      emit(LoadedUpcomingEventsNotifications(state.mainCalenderEventState.copyWith(upcomingEventsNotifications: events, message: 'Loaded ${events.length} upcoming events notifications')));
    } catch (error, stackTrace) {
      emit(CalenderError(state.mainCalenderEventState.copyWith(message: '', errorMessage: error.toString()), stackTrace: stackTrace.toString()));
    }
  }

  Future<void> deleteEventsForConnection({required String userUid, required String friendUid}) async {
    emit(LoadingCalenderEvent(state.mainCalenderEventState.copyWith(message: 'Deleting calendar events for connection')));
    try {
      await _calenderEventFirebaseRepository.deleteEventsForConnection(userUid: userUid, friendUid: friendUid);
      
      // Remove the deleted events from the current state
      List<CalenderEvent> events = List.from(state.mainCalenderEventState.allUserCalenderEvents ?? []);
      events.removeWhere((event) => 
        (event.user?.uid == userUid && event.friend?.uid == friendUid) ||
        (event.user?.uid == friendUid && event.friend?.uid == userUid)
      );
      
      emit(LoadedCalenderEvent(state.mainCalenderEventState.copyWith(
        allUserCalenderEvents: events, 
        numberOfUserCalenderEvents: events.length, 
        message: 'Calendar events for connection deleted'
      )));
    } catch (error, stackTrace) {
      emit(CalenderError(state.mainCalenderEventState.copyWith(message: '', errorMessage: error.toString()), stackTrace: stackTrace.toString()));
    }
  }
}
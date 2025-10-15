part of 'calender_event_cubit.dart';

class MainCalenderEventState extends Equatable {
  final String? message;
  final String? errorMessage;
  final List<CalenderEvent>? allUserCalenderEvents;
  final CalenderEvent? selectedCalenderEvent;
  final num? numberOfUserCalenderEvents;
  final List<CalenderEvent>? upcomingEventsNotifications;

  const MainCalenderEventState({this.message, this.errorMessage, this.allUserCalenderEvents, this.selectedCalenderEvent, this.numberOfUserCalenderEvents, this.upcomingEventsNotifications});

  @override
  List<Object?> get props => [message, errorMessage, allUserCalenderEvents, selectedCalenderEvent, numberOfUserCalenderEvents, upcomingEventsNotifications];

  MainCalenderEventState copyWith({
    String? message,
    String? errorMessage,
    List<CalenderEvent>? allUserCalenderEvents,
    CalenderEvent? selectedCalenderEvent,
    num? numberOfUserCalenderEvents,
    List<CalenderEvent>? upcomingEventsNotifications,
  }) {
    return MainCalenderEventState(
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
      allUserCalenderEvents: allUserCalenderEvents ?? this.allUserCalenderEvents,
      selectedCalenderEvent: selectedCalenderEvent ?? this.selectedCalenderEvent,
      numberOfUserCalenderEvents: numberOfUserCalenderEvents ?? this.numberOfUserCalenderEvents,
      upcomingEventsNotifications: upcomingEventsNotifications ?? this.upcomingEventsNotifications,
    );
  }

  MainCalenderEventState copyWithNull({
    String? message,
    String? errorMessage,
    List<CalenderEvent>? allUserCalenderEvents,
    CalenderEvent? selectedCalenderEvent,
    num? numberOfUserCalenderEvents,
    List<CalenderEvent>? upcomingEventsNotifications,
  }) {
    return MainCalenderEventState(
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
      allUserCalenderEvents: allUserCalenderEvents ?? this.allUserCalenderEvents,
      selectedCalenderEvent: selectedCalenderEvent,
      numberOfUserCalenderEvents: numberOfUserCalenderEvents ?? this.numberOfUserCalenderEvents,
      upcomingEventsNotifications: upcomingEventsNotifications ?? this.upcomingEventsNotifications,
    );
  }
}

abstract class CalenderEventState extends Equatable {
  final MainCalenderEventState mainCalenderEventState;

  const CalenderEventState(this.mainCalenderEventState);

  @override
  List<Object> get props => [mainCalenderEventState];
}

class CalenderEventInitial extends CalenderEventState {
  const CalenderEventInitial() : super(const MainCalenderEventState());
}

class LoadingCalenderEvent extends CalenderEventState {
  const LoadingCalenderEvent(super.mainCalenderEventState);
}

class LoadedCalenderEvent extends CalenderEventState {
  const LoadedCalenderEvent(super.mainCalenderEventState);
}

class CreatingCalenderEvent extends CalenderEventState {
  const CreatingCalenderEvent(super.mainCalenderEventState);
}

class CreatedCalenderEvent extends CalenderEventState {
  const CreatedCalenderEvent(super.mainCalenderEventState);
}

class SelectedCalenderEvent extends CalenderEventState {
  const SelectedCalenderEvent(super.mainCalenderEventState);
}

class LoadingUpcomingEventsNotifications extends CalenderEventState {
  const LoadingUpcomingEventsNotifications(super.mainCalenderEventState);
}

class LoadedUpcomingEventsNotifications extends CalenderEventState {
  const LoadedUpcomingEventsNotifications(super.mainCalenderEventState);
}

class CalenderError extends CalenderEventState {
  final String stackTrace;

  const CalenderError(super.mainCalenderEventState, {required this.stackTrace});

  @override
  List<Object> get props => [double.maxFinite, stackTrace];
}
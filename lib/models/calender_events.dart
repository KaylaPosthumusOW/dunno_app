import 'package:dunno/models/app_user_profile.dart';
import 'package:dunno/models/collections.dart';
import 'package:equatable/equatable.dart';

class CalenderEvent extends Equatable {
  final String? uid;
  final AppUserProfile? user;
  final AppUserProfile? friend;
  final Collections? collection;
  final bool? reminderSent;
  final bool? hasOccurred;

  const CalenderEvent({this.uid, this.user, this.friend, this.collection, this.reminderSent, this.hasOccurred});

  @override
  List<Object?> get props => [uid, user, friend, collection, reminderSent, hasOccurred];

  CalenderEvent copyWith({
    String? uid,
    AppUserProfile? user,
    AppUserProfile? friend,
    Collections? collection,
    bool? reminderSent,
    bool? hasOccurred,
  }) {
    return CalenderEvent(
      uid: uid ?? this.uid,
      user: user ?? this.user,
      friend: friend ?? this.friend,
      collection: collection ?? this.collection,
      reminderSent: reminderSent ?? this.reminderSent,
      hasOccurred: hasOccurred ?? this.hasOccurred,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'user': user?.toMap(),
      'friend': friend?.toMap(),
      'collection': collection?.toMap(),
      'reminderSent': reminderSent,
      'hasOccurred': hasOccurred,
    };
  }

  factory CalenderEvent.fromMap(Map<String, dynamic> map) {
    return CalenderEvent(
      uid: map['uid'],
      user: map['user'] != null ? AppUserProfile.fromMap(map['user']) : null,
      friend: map['friend'] != null ? AppUserProfile.fromMap(map['friend']) : null,
      collection: map['collection'] != null ? Collections.fromMap(map['collection']) : null,
      reminderSent: map['reminderSent'],
      hasOccurred: map['hasOccurred'],
    );
  }
}
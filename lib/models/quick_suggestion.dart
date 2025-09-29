import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dunno/models/collection_likes.dart';
import 'package:dunno/models/filter_suggestion.dart';
import 'package:equatable/equatable.dart';

enum GenderType { woman, man, other }

class QuickSuggestion extends Equatable {
  final String? uid;
  final String? eventType;
  final num? age;
  final GenderType? gender;
  final CollectionLikes? likes;
  final FilterSuggestion? filters;
  final String? extraNotes;
  final Timestamp? createdAt;

  const QuickSuggestion({this.uid, this.eventType, this.age, this.gender, this.likes, this.filters, this.extraNotes, this.createdAt});

  @override
  List<Object?> get props => [uid, eventType, age, gender, likes, filters, extraNotes, createdAt];

  QuickSuggestion copyWith({
    String? uid,
    String? eventType,
    num? age,
    GenderType? gender,
    CollectionLikes? likes,
    FilterSuggestion? filters,
    String? extraNotes,
    Timestamp? createdAt,
  }) {
    return QuickSuggestion(
      uid: uid ?? this.uid,
      eventType: eventType ?? this.eventType,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      likes: likes ?? this.likes,
      filters: filters ?? this.filters,
      extraNotes: extraNotes ?? this.extraNotes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap({bool timeStampSafe = false}) {
    return {
      'uid': uid,
      'eventType': eventType,
      'age': age,
      'gender': gender,
      'likes': likes?.toMap(),
      'filters': filters?.toMap(),
      'extraNotes': extraNotes,
      'createdAt': timeStampSafe ? createdAt?.toDate().toIso8601String() : createdAt,
    };
  }

  factory QuickSuggestion.fromMap(Map<String, dynamic> map, {bool timeStampSafe = false}) {
    var createdAt = map['createdAt'];
    if (createdAt != null) {
      if (createdAt is String) {
        createdAt = Timestamp.fromDate(DateTime.parse(map['createdAt']));
      }

      if (createdAt is int) {
        createdAt = Timestamp.fromDate(DateTime.fromMillisecondsSinceEpoch(map['createdAt']));
      }
    } else {
      createdAt = createdAt;
    }

    return QuickSuggestion(
      uid: map['uid'],
      eventType: map['eventType'],
      age: map['age'],
      gender: map['gender'] != null ? GenderType.values.firstWhere((e) => e.toString() == 'GenderType.${GenderType.other}') : null,
      likes: map['likes'] != null ? CollectionLikes.fromMap(Map<String, dynamic>.from(map['likes'])) : null,
      filters: map['filters'] != null ? FilterSuggestion.fromMap(Map<String, dynamic>.from(map['filters'])) : null,
      extraNotes: map['extraNotes'],
      createdAt: createdAt,
    );
  }
}
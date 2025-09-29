import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dunno/models/app_user_profile.dart';
import 'package:dunno/models/collections.dart';
import 'package:dunno/models/filter_suggestion.dart';
import 'package:equatable/equatable.dart';

class GiftSuggestion extends Equatable {
  final String? uid;
  final AppUserProfile? gifter;
  final AppUserProfile? receiver;
  final Collections? collection;
  final List<String>? giftSuggestions;
  final FilterSuggestion? filterSuggestion;
  final Timestamp? createdAt;

  const GiftSuggestion({this.uid, this.gifter, this.receiver, this.collection, this.giftSuggestions, this.filterSuggestion, this.createdAt});

  @override
  List<Object?> get props => [uid, gifter, receiver, collection, giftSuggestions, filterSuggestion, createdAt];

  GiftSuggestion copyWith({
    String? uid,
    AppUserProfile? gifter,
    AppUserProfile? receiver,
    Collections? collection,
    List<String>? giftSuggestions,
    FilterSuggestion? filterSuggestion,
    Timestamp? createdAt,
  }) {
    return GiftSuggestion(
      uid: uid ?? this.uid,
      gifter: gifter ?? this.gifter,
      receiver: receiver ?? this.receiver,
      collection: collection ?? this.collection,
      giftSuggestions: giftSuggestions ?? this.giftSuggestions,
      filterSuggestion: filterSuggestion ?? this.filterSuggestion,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap({bool timeStampSafe = false}) {
    return {
      'uid': uid,
      'gifter': gifter?.toMap(),
      'receiver': receiver?.toMap(),
      'collection': collection?.toMap(),
      'giftSuggestions': giftSuggestions,
      'filterSuggestion': filterSuggestion?.toMap(),
      'createdAt': timeStampSafe ? createdAt?.toDate().toIso8601String() : createdAt,
    };
  }

  factory GiftSuggestion.fromMap(Map<String, dynamic> map, {bool timeStampSafe = false}) {
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

    return GiftSuggestion(
      uid: map['uid'],
      gifter: map['gifter'] != null ? AppUserProfile.fromMap(map['gifter']) : null,
      receiver: map['receiver'] != null ? AppUserProfile.fromMap(map['receiver']) : null,
      collection: map['collection'] != null ? Collections.fromMap(map['collection']) : null,
      giftSuggestions: List<String>.from(map['giftSuggestions'] ?? []),
      filterSuggestion: map['filterSuggestion'] != null ? FilterSuggestion.fromMap(map['filterSuggestion']) : null,
      createdAt: createdAt,
    );
  }
}
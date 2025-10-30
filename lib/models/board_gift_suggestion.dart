import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dunno/models/ai_gift_suggestion.dart';
import 'package:dunno/models/gift_boards.dart';
import 'package:equatable/equatable.dart';

class BoardGiftSuggestion extends Equatable {
  final String? uid;
  final GiftBoard? board;
  final AiGiftSuggestion? giftSuggestion;
  final Timestamp? createdAt;

  const BoardGiftSuggestion({this.uid, this.board, this.giftSuggestion, this.createdAt,});

  @override
  List<Object?> get props => [uid, board, giftSuggestion, createdAt,];

  BoardGiftSuggestion copyWith({
    String? uid,
    GiftBoard? board,
    AiGiftSuggestion? giftSuggestion,
    Timestamp? createdAt,
  }) {
    return BoardGiftSuggestion(
      uid: uid ?? this.uid,
      board: board ?? this.board,
      giftSuggestion: giftSuggestion ?? this.giftSuggestion,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'board': board?.toMap(),
      'giftSuggestion': giftSuggestion?.toJson(),
      'createdAt': createdAt,
    };
  }

  factory BoardGiftSuggestion.fromMap(Map<String, dynamic> map) {
    return BoardGiftSuggestion(
      uid: map['uid'],
      board: map['board'] != null ? GiftBoard.fromMap(map['board']) : null,
      giftSuggestion: map['giftSuggestion'] != null
          ? AiGiftSuggestion.fromJson(Map<String, dynamic>.from(map['giftSuggestion']))
          : null,
      createdAt: map['createdAt'],
    );
  }
}
import 'package:dunno/models/app_user_profile.dart';
import 'package:equatable/equatable.dart';

class GiftBoard extends Equatable {
  final String uid;
  final String boardName;
  final AppUserProfile? owner;

  const GiftBoard({
    required this.uid,
    required this.boardName,
    this.owner,
  });

  @override
  List<Object?> get props => [uid, boardName, owner];

  GiftBoard copyWith({
    String? uid,
    String? boardName,
    AppUserProfile? owner,
  }) {
    return GiftBoard(
      uid: uid ?? this.uid,
      boardName: boardName ?? this.boardName,
      owner: owner ?? this.owner,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'boardName': boardName,
      'owner': owner?.toMap(),
    };
  }

  factory GiftBoard.fromMap(Map<String, dynamic> map) {
    return GiftBoard(
      uid: map['uid'],
      boardName: map['boardName'],
      owner: map['owner'] != null ? AppUserProfile.fromMap(map['owner']) : null,
    );
  }
}
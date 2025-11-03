import 'package:dunno/models/app_user_profile.dart';
import 'package:equatable/equatable.dart';

class GiftBoard extends Equatable {
  final String? uid;
  final String? boardName;
  final AppUserProfile? owner;
  final String? thumbnailUrl;

  const GiftBoard({this.uid, this.boardName, this.owner, this.thumbnailUrl});

  @override
  List<Object?> get props => [uid, boardName, owner, thumbnailUrl];

  GiftBoard copyWith({
    String? uid,
    String? boardName,
    AppUserProfile? owner,
    String? thumbnailUrl,
  }) {
    return GiftBoard(
      uid: uid ?? this.uid,
      boardName: boardName ?? this.boardName,
      owner: owner ?? this.owner,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'boardName': boardName,
      'owner': owner?.toMap(),
      'thumbnailUrl': thumbnailUrl,
    };
  }

  factory GiftBoard.fromMap(Map<String, dynamic> map) {
    return GiftBoard(
      uid: map['uid'],
      boardName: map['boardName'],
      owner: map['owner'] != null ? AppUserProfile.fromMap(map['owner']) : null,
      thumbnailUrl: map['thumbnailUrl'],
    );
  }
}
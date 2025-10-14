import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dunno/models/app_user_profile.dart';
import 'package:equatable/equatable.dart';


class Connection extends Equatable {
  final String? uid;
  final AppUserProfile? user;
  final AppUserProfile? connectedUser;
  final Timestamp? createdAt;

  const Connection({this.uid, this.user, this.connectedUser, this.createdAt});

  @override
  List<Object?> get props => [uid, user, connectedUser, createdAt];

  Connection copyWith({
    String? uid,
    AppUserProfile? user,
    AppUserProfile? connectedUser,
    Timestamp? createdAt,
  }) {
    return Connection(
      uid: uid ?? this.uid,
      user: user ?? this.user,
      connectedUser: connectedUser ?? this.connectedUser,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap({bool timeStampSafe = false}) {
    return {
      'uid': uid,
      'user': user?.toMap(),
      'connectedUser': connectedUser?.toMap(),
      'createdAt': timeStampSafe ? createdAt?.toDate().toIso8601String() : createdAt,
    };
  }

  factory Connection.fromMap(Map<String, dynamic> map, {bool timeStampSafe = false}) {
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

    return Connection(
      uid: map['uid'],
      user: map['user'] != null ? AppUserProfile.fromMap(map['user']) : null,
      connectedUser: map['connectedUser'] != null ? AppUserProfile.fromMap(map['connectedUser']) : null,
      createdAt: createdAt,
    );
  }

  AppUserProfile? toAppUserProfile() {
    return user;
  }

  AppUserProfile? getOtherUser(String currentUserUid) {
    if (user?.uid == currentUserUid) {
      return connectedUser;
    } else {
      return user;
    }
  }
}
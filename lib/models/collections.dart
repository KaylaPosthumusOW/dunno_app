import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dunno/models/app_user_profile.dart';
import 'package:dunno/models/collection_likes.dart';
import 'package:equatable/equatable.dart';

class Collections extends Equatable {
  final String? uid;
  final AppUserProfile? owner;
  final String? title;
  final Timestamp? eventCollectionDate;
  final bool? isDateVisible;
  final CollectionLikes? likes;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  const Collections({this.uid, this.owner, this.title, this.eventCollectionDate, this.isDateVisible, this.likes, this.createdAt, this.updatedAt});

  @override
  List<Object?> get props => [uid, owner, title, eventCollectionDate, isDateVisible, likes, createdAt, updatedAt];

  Collections copyWith({
    String? uid,
    AppUserProfile? owner,
    String? title,
    Timestamp? eventCollectionDate,
    bool? isDateVisible,
    CollectionLikes? likes,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return Collections(
      uid: uid ?? this.uid,
      owner: owner ?? this.owner,
      title: title ?? this.title,
      eventCollectionDate: eventCollectionDate ?? this.eventCollectionDate,
      isDateVisible: isDateVisible ?? this.isDateVisible,
      likes: likes ?? this.likes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'owner': owner?.toMap(),
      'title': title,
      'eventCollectionDate': eventCollectionDate,
      'isDateVisible': isDateVisible,
      'likes': likes?.toMap(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory Collections.fromMap(Map<String, dynamic> map) {
    return Collections(
      uid: map['uid'],
      owner: map['owner'] != null ? AppUserProfile.fromMap(map['owner']) : null,
      title: map['title'],
      eventCollectionDate: map['eventCollectionDate'],
      isDateVisible: map['isDateVisible'],
      likes: map['likes'] != null ? CollectionLikes.fromMap(map['likes']) : null,
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }
}
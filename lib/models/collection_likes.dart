import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class CollectionLikes extends Equatable{
  final String? uid;
  final List<String>? hobbies;
  final List<String>? interests;
  final List<String>? likes;
  final List<String>? aestheticPreferences;
  final Timestamp? createdAt;

  const CollectionLikes({this.uid, this.hobbies, this.interests, this.likes, this.aestheticPreferences, this.createdAt});

  @override
  List<Object?> get props => [uid, hobbies, interests, likes, aestheticPreferences, createdAt];

  CollectionLikes copyWith({
    String? uid,
    List<String>? hobbies,
    List<String>? interests,
    List<String>? likes,
    List<String>? aestheticPreferences,
    Timestamp? createdAt,
  }) {
    return CollectionLikes(
      uid: uid ?? this.uid,
      hobbies: hobbies ?? this.hobbies,
      interests: interests ?? this.interests,
      likes: likes ?? this.likes,
      aestheticPreferences: aestheticPreferences ?? this.aestheticPreferences,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'hobbies': hobbies,
      'interests': interests,
      'likes': likes,
      'aestheticPreferences': aestheticPreferences,
      'createdAt': createdAt,
    };
  }

  factory CollectionLikes.fromMap(Map<String, dynamic> map) {
    return CollectionLikes(
      uid: map['uid'] as String?,
      hobbies: List<String>.from(map['hobbies'] ?? []),
      interests: List<String>.from(map['interests'] ?? []),
      likes: List<String>.from(map['likes'] ?? []),
      aestheticPreferences: List<String>.from(map['aestheticPreferences'] ?? []),
      createdAt: map['createdAt'] as Timestamp?,
    );
  }

}
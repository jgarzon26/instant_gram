import 'dart:convert';

import 'package:flutter/foundation.dart';

class LikedPostsOfCurrentUser {
  String uid;
  List<String> listofPostId;
  LikedPostsOfCurrentUser({
    required this.uid,
    required this.listofPostId,
  });

  LikedPostsOfCurrentUser copyWith({
    String? uid,
    List<String>? listofPostId,
  }) {
    return LikedPostsOfCurrentUser(
      uid: uid ?? this.uid,
      listofPostId: listofPostId ?? this.listofPostId,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'uid': uid});
    result.addAll({'posts': listofPostId});

    return result;
  }

  factory LikedPostsOfCurrentUser.fromMap(Map<String, dynamic> map) {
    return LikedPostsOfCurrentUser(
      uid: map['\$uid'] ?? '',
      listofPostId: List<String>.from(map['posts']),
    );
  }

  String toJson() => json.encode(toMap());

  factory LikedPostsOfCurrentUser.fromJson(String source) =>
      LikedPostsOfCurrentUser.fromMap(json.decode(source));

  @override
  String toString() =>
      'LikedPostsOfCurrentUser(uid: $uid, listofPostId: $listofPostId)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LikedPostsOfCurrentUser &&
        other.uid == uid &&
        listEquals(other.listofPostId, listofPostId);
  }

  @override
  int get hashCode => uid.hashCode ^ listofPostId.hashCode;
}

import 'dart:convert';

import 'package:flutter/foundation.dart';

class LikedPostsOfCurrentUser {
  String uid;
  List<String> posts;
  LikedPostsOfCurrentUser({
    required this.uid,
    required this.posts,
  });

  LikedPostsOfCurrentUser copyWith({
    String? uid,
    List<String>? posts,
  }) {
    return LikedPostsOfCurrentUser(
      uid: uid ?? this.uid,
      posts: posts ?? this.posts,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'uid': uid});
    result.addAll({'posts': posts});

    return result;
  }

  factory LikedPostsOfCurrentUser.fromMap(Map<String, dynamic> map) {
    return LikedPostsOfCurrentUser(
      uid: map['uid'] ?? '',
      posts: List<String>.from(map['posts']),
    );
  }

  String toJson() => json.encode(toMap());

  factory LikedPostsOfCurrentUser.fromJson(String source) =>
      LikedPostsOfCurrentUser.fromMap(json.decode(source));

  @override
  String toString() => 'LikedPostsOfCurrentUser(uid: $uid, posts: $posts)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LikedPostsOfCurrentUser &&
        other.uid == uid &&
        listEquals(other.posts, posts);
  }

  @override
  int get hashCode => uid.hashCode ^ posts.hashCode;
}

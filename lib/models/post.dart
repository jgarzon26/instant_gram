// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:instant_gram/models/models.dart';

class Post {
  final String postId;
  final String uid;
  final String username;
  final File media;
  final String description;
  final bool allowLikes;
  final bool allowComments;
  final DateTime postDate;
  final bool isVideo;
  final String thumbnail;
  List<UserComment> comments;
  int numberOfLikes;

  Post({
    required this.postId,
    required this.uid,
    required this.username,
    required this.media,
    required this.description,
    required this.allowLikes,
    required this.allowComments,
    required this.postDate,
    required this.isVideo,
    required this.thumbnail,
    this.comments = const [],
    this.numberOfLikes = 0,
  });

  Post copyWith({
    String? postId,
    String? uid,
    String? username,
    File? media,
    String? description,
    bool? allowLikes,
    bool? allowComments,
    DateTime? postDate,
    bool? isVideo,
    String? thumbnail,
    List<UserComment>? comments,
    int? numberOfLikes,
  }) {
    return Post(
      postId: postId ?? this.postId,
      uid: uid ?? this.uid,
      username: username ?? this.username,
      media: media ?? this.media,
      description: description ?? this.description,
      allowLikes: allowLikes ?? this.allowLikes,
      allowComments: allowComments ?? this.allowComments,
      postDate: postDate ?? this.postDate,
      isVideo: isVideo ?? this.isVideo,
      thumbnail: thumbnail ?? this.thumbnail,
      comments: comments ?? this.comments,
      numberOfLikes: numberOfLikes ?? this.numberOfLikes,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'postId': postId});
    result.addAll({'uid': uid});
    result.addAll({'username': username});
    result.addAll({'path': media.path});
    result.addAll({'description': description});
    result.addAll({'allowLikes': allowLikes});
    result.addAll({'allowComments': allowComments});
    result.addAll({'postDate': postDate.millisecondsSinceEpoch});
    result.addAll({'isVideo': isVideo});
    result.addAll({'thumbnail': thumbnail});
    result.addAll({'comments': comments.map((x) => x.toMap()).toList()});
    result.addAll({'numberOfLikes': numberOfLikes});

    return result;
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      postId: map['postId'] ?? '',
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      media: File(map['path']),
      description: map['description'] ?? '',
      allowLikes: map['allowLikes'] ?? false,
      allowComments: map['allowComments'] ?? false,
      postDate: DateTime.fromMillisecondsSinceEpoch(map['postDate']),
      isVideo: map['isVideo'] ?? false,
      thumbnail: map['thumbnail'] ?? '',
      comments: List<UserComment>.from(
          map['comments']?.map((x) => UserComment.fromMap(x))),
      numberOfLikes: map['numberOfLikes']?.toInt() ?? 0,
    );
  }

  @override
  String toString() {
    return 'Post(uid: $uid, username: $username, media: $media, description: $description, allowLikes: $allowLikes, allowComments: $allowComments, postDate: $postDate, isVideo: $isVideo, thumbnail: $thumbnail, comments: $comments, numberOfLikes: $numberOfLikes)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Post &&
        other.uid == uid &&
        other.username == username &&
        other.media == media &&
        other.description == description &&
        other.allowLikes == allowLikes &&
        other.allowComments == allowComments &&
        other.postDate == postDate &&
        other.isVideo == isVideo &&
        other.thumbnail == thumbnail &&
        listEquals(other.comments, comments) &&
        other.numberOfLikes == numberOfLikes;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        username.hashCode ^
        media.hashCode ^
        description.hashCode ^
        allowLikes.hashCode ^
        allowComments.hashCode ^
        postDate.hashCode ^
        isVideo.hashCode ^
        thumbnail.hashCode ^
        comments.hashCode ^
        numberOfLikes.hashCode;
  }

  String toJson() => json.encode(toMap());

  factory Post.fromJson(String source) => Post.fromMap(json.decode(source));
}

extension DateTimeExtensions on DateTime {
  Map<String, dynamic> toMap() {
    return {
      'year': year,
      'month': month,
      'day': day,
      'hour': hour,
      'minute': minute,
      'second': second,
    };
  }
}

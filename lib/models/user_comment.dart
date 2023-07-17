// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:uuid/uuid.dart';

class UserComment {
  String commentId = const Uuid().v4();
  String comment;
  String userName;

  UserComment({
    required this.comment,
    required this.userName,
  });

  UserComment copyWith({
    String? comment,
    String? userName,
  }) {
    return UserComment(
      comment: comment ?? this.comment,
      userName: userName ?? this.userName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'comment': comment,
      'userName': userName,
    };
  }

  factory UserComment.fromMap(Map<String, dynamic> map) {
    return UserComment(
      comment: map['comment'] as String,
      userName: map['userName'] as String,
    );
  }

  @override
  String toString() => 'UserComment(comment: $comment, userName: $userName)';

  @override
  bool operator ==(covariant UserComment other) {
    if (identical(this, other)) return true;

    return other.comment == comment && other.userName == userName;
  }

  @override
  int get hashCode => comment.hashCode ^ userName.hashCode;
}

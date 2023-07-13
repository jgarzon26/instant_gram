import 'package:uuid/uuid.dart';

class UserComment {
  String commentId = const Uuid().v4();
  String comment, userName;

  UserComment({
    required this.comment,
    required this.userName,
  });
}

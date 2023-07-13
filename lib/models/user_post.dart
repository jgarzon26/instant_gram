import 'package:appwrite/models.dart';
import 'package:uuid/uuid.dart';

class UserPost {
  final String postId = const Uuid().v4();
  final User user;
  final String path, description;
  final bool allowLikes, allowComments;
  final DateTime postDate;
  final bool isVideo;
  final String thumbnail;

  UserPost({
    required this.user,
    required this.path,
    required this.description,
    required this.allowLikes,
    required this.allowComments,
    required this.postDate,
    required this.isVideo,
    required this.thumbnail,
  });
}

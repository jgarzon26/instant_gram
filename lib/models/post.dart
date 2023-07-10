import 'package:instant_gram/models/user_post.dart';

class Post {
  List<String> comments;
  int numberOfLikes = 0;
  UserPost userPost;

  Post({
    required this.comments,
    required this.numberOfLikes,
    required this.userPost,
  });
}

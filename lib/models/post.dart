import 'package:instant_gram/models/models.dart';

class Post {
  List<UserComment> comments = [];
  int numberOfLikes = 0;
  UserPost userPost;

  Post({
    required this.userPost,
  });
}

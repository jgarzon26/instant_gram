import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instant_gram/models/models.dart';

final userPostProvider = StateNotifierProvider<UserPostProvider, List<Post>>(
    (ref) => UserPostProvider());

class UserPostProvider extends StateNotifier<List<Post>> {
  UserPostProvider() : super([]);

  void addPost(UserPost post) {
    state = [
      ...state,
      Post(
        userPost: post,
      ),
    ];
  }

  void removePost(Post post) {
    state = state
        .where((element) => element.userPost.postId != post.userPost.postId)
        .toList();
  }
}

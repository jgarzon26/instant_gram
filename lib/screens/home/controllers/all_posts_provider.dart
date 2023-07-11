import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instant_gram/models/models.dart';
import 'package:instant_gram/screens/home/controllers/user_post_provider.dart';

final allPostsProvider = StateNotifierProvider<AllPostsProvider, List<Post>>(
    (ref) => AllPostsProvider(ref.watch(userPostProvider)));

class AllPostsProvider extends StateNotifier<List<Post>> {
  AllPostsProvider(List<Post> userPosts) : super([...userPosts]);

  void addPost(Post post) {
    state = [...state, post];
  }

  void removePost(Post post) {
    state = state
        .where((element) => element.userPost.id != post.userPost.id)
        .toList();
  }
}

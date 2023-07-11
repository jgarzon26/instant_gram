import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instant_gram/models/models.dart';
import 'package:instant_gram/sample_data.dart';

final userPostProvider = StateNotifierProvider<UserPostProvider, List<Post>>(
    (ref) => UserPostProvider());

class UserPostProvider extends StateNotifier<List<Post>> {
  UserPostProvider()
      : super([
          samplePost,
        ]);

  void addPost(Post post) {
    state = [...state, post];
  }

  void removePost(Post post) {
    state = state
        .where((element) => element.userPost.id != post.userPost.id)
        .toList();
  }
}

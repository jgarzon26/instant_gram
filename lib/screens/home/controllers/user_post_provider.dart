import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instant_gram/apis/post_api.dart';
import 'package:instant_gram/models/models.dart';

final userPostProvider = StateNotifierProvider<UserPostProvider, bool>(
    (ref) => UserPostProvider(ref.watch(postApiProvider)));

final getPostsOfCurrentUserProvider = FutureProvider.family((ref, String uid) {
  final provider = ref.watch(userPostProvider.notifier);
  return provider.getPostsOfCurrentUser(uid);
});

final getLatestOfCurrentUserProvider = StreamProvider((ref) {
  final postApi = ref.watch(postApiProvider);
  return postApi.updateAllPosts();
});

class UserPostProvider extends StateNotifier<bool> {
  final PostApi _postApi;

  UserPostProvider(this._postApi) : super(false);

  Future<List<Post>> getPostsOfCurrentUser(String uid) async {
    final posts = await _postApi.getPostsOfCurrentUser(uid);
    return posts.map((post) => Post.fromMap(post.data)).toList();
  }
}

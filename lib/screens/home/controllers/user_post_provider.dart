import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instant_gram/apis/auth_api.dart';
import 'package:instant_gram/models/models.dart';
import 'package:instant_gram/screens/home/controllers/all_posts_provider.dart';

final userPostProvider = StateNotifierProvider<UserPostProvider, List<Post>>(
    (ref) => UserPostProvider(
        ref.watch(allPostsProvider), ref.watch(authApiProvider)));

class UserPostProvider extends StateNotifier<List<Post>> {
  final AuthApi _authApi;

  UserPostProvider(List<Post> posts, this._authApi) : super(posts);

  Future<List<Post>> getPostsOfOwner() async {
    final user = await _authApi.getUserDetails();
    return state.where((post) {
      return post.uid == user.$id;
    }).toList();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instant_gram/apis/post_api.dart';
import 'package:instant_gram/core/core.dart';
import 'package:instant_gram/models/models.dart';

final allPostsProvider = StateNotifierProvider<AllPostsProvider, bool>(
    (ref) => AllPostsProvider(ref.watch(postApiProvider)));

final getLatestPostsProvider = StreamProvider((ref) {
  final allPostApi = ref.watch(postApiProvider);
  return allPostApi.updateAllPosts();
});

final getPostsProvider = FutureProvider((ref) {
  final provider = ref.watch(allPostsProvider.notifier);
  return provider.getPosts();
});

class AllPostsProvider extends StateNotifier<bool> {
  final PostApi _postApi;

  AllPostsProvider(this._postApi) : super(false);

  void addPost(BuildContext context, WidgetRef ref, Post post) async {
    state = true;
    final response = await ref.watch(postApiProvider).createPost(post);
    return response.fold((failure) {
      showSnackbar(context, failure.message);
      state = false;
    }, (document) {
      showSnackbar(context, "Post added successfully");
      Navigator.pop(context);
      state = false;
    });
  }

  Future<List<Post>> getPosts() async {
    state = true;
    final posts = await _postApi.getPosts();
    state = false;
    return posts.map((e) => Post.fromMap(e.data)).toList();
  }

  void incrementLike(Post post) {}

  void decrementLike(Post post) {}

  void addCommentToUser(Post post, UserComment comment) {}

  void deleteCommentFromUser(Post post, UserComment comment) {}

  void removePost(Post post) {}
}

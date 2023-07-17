import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instant_gram/apis/post_api.dart';
import 'package:instant_gram/core/core.dart';
import 'package:instant_gram/core/typedefs.dart';
import 'package:instant_gram/models/models.dart';

final allPostsProvider = StateNotifierProvider<AllPostsProvider, List<Post>>(
    (ref) => AllPostsProvider());

final allPostsFutureProvider = FutureProvider((ref) async {
  return ref.watch(postApiProvider).getAllPosts();
});

class AllPostsProvider extends StateNotifier<List<Post>> {
  AllPostsProvider() : super([]);

  final List<Post> _likes = [];

  List<Post> get likes => _likes;

  void initState(BuildContext context, WidgetRef ref) async {
    final response = await ref.watch(postApiProvider).getAllPosts();
    response.fold((failure) {
      showSnackbar(context, failure.message);
    }, (posts) {
      state = posts.documents
          .map((document) => Post.fromMap(document.data))
          .toList();
    });
  }

  FutureEither<void> addPost(Post post, WidgetRef ref) async {
    state = [
      ...state,
      post,
    ];
    final response = await ref.watch(postApiProvider).createPost(post);
    return response;
  }

  void incrementLike(Post post) {
    state = state.map((element) {
      if (element.postId == post.postId) {
        element.numberOfLikes++;
        _likes.add(element);
        return element;
      } else {
        return element;
      }
    }).toList();
  }

  void decrementLike(Post post) {
    state = state.map((element) {
      if (element.postId == post.postId) {
        element.numberOfLikes--;
        _likes.remove(element);
        return element;
      } else {
        return element;
      }
    }).toList();
  }

  void addCommentToUser(Post post, UserComment comment) {
    state = state.map((element) {
      if (element.postId == post.postId) {
        element.comments = [...element.comments, comment];
        return element;
      } else {
        return element;
      }
    }).toList();
  }

  void deleteCommentFromUser(Post post, UserComment comment) {
    state = state.map((element) {
      if (element.postId == post.postId) {
        element.comments = element.comments
            .where((c) => c.commentId != comment.commentId)
            .toList();
        return element;
      } else {
        return element;
      }
    }).toList();
  }

  void removePost(Post post) {
    state = state.where((element) => element.postId != post.postId).toList();
  }
}

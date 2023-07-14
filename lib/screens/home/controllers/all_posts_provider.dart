import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instant_gram/models/models.dart';

final allPostsProvider = StateNotifierProvider<AllPostsProvider, List<Post>>(
    (ref) => AllPostsProvider());

class AllPostsProvider extends StateNotifier<List<Post>> {
  AllPostsProvider() : super([]);

  final List<Post> _likes = [];

  List<Post> get likes => _likes;

  void addPost(UserPost post) {
    state = [
      ...state,
      Post(
        userPost: post,
      )
    ];
  }

  void incrementLike(Post post) {
    state = state.map((element) {
      if (element.userPost.postId == post.userPost.postId) {
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
      if (element.userPost.postId == post.userPost.postId) {
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
      if (element.userPost.postId == post.userPost.postId) {
        element.comments = [...element.comments, comment];
        return element;
      } else {
        return element;
      }
    }).toList();
  }

  void deleteCommentFromUser(Post post, UserComment comment) {
    state = state.map((element) {
      if (element.userPost.postId == post.userPost.postId) {
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
    state = state
        .where((element) => element.userPost.postId != post.userPost.postId)
        .toList();
  }
}

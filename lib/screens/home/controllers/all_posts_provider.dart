import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instant_gram/models/models.dart';
import 'package:instant_gram/screens/home/controllers/user_post_provider.dart';

final allPostsProvider = StateNotifierProvider<AllPostsProvider, List<Post>>(
    (ref) => AllPostsProvider(ref.watch(userPostProvider)));

class AllPostsProvider extends StateNotifier<List<Post>> {
  AllPostsProvider(List<Post> userPosts) : super([...userPosts]);

  final List<Post> _likes = [];

  List<Post> get likes => _likes;

  void addPost(Post post) {
    state = [...state, post];
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

  List<UserComment> getCommentsOfUser(Post post) {
    return state
        .firstWhere(
            (element) => element.userPost.postId == post.userPost.postId)
        .comments;
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

  void removePost(Post post) {
    state = state
        .where((element) => element.userPost.postId != post.userPost.postId)
        .toList();
  }
}

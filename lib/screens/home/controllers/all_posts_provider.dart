import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instant_gram/apis/post_api.dart';
import 'package:instant_gram/core/core.dart';
import 'package:instant_gram/models/liked_posts.dart';
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

final getCommentsProvider = FutureProvider.family((ref, Post post) {
  final provider = ref.watch(allPostsProvider.notifier);
  return provider.getCommentOfPost(post);
});

class AllPostsProvider extends StateNotifier<bool> {
  final PostApi _postApi;

  AllPostsProvider(this._postApi) : super(false);

  //Posts

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

  void removePost(Post post) {}

  //Likes

  void updateLikes(BuildContext context, Post post, int scale,
      LikedPostsOfCurrentUser likedPosts) async {
    post = post.copyWith(
      numberOfLikes: post.numberOfLikes + scale,
    );

    final response = await _postApi.updateLikesOfPost(post);
    response.fold(
      (failure) {
        showSnackbar(context, failure.message);
      },
      (document) async {
        //temp
        if (scale > 0) {
          likedPosts = likedPosts.copyWith(
            listofPostId: [
              ...likedPosts.listofPostId,
              post.postId,
            ],
          );
          final res =
              await _postApi.updateListOfLikedPostsOfCurrentUser(likedPosts);
          res.fold((l) {
            showSnackbar(context, l.message);
          }, (r) {
            showSnackbar(context, "You liked this post");
          });
        } else {
          final newLikedPosts = likedPosts.listofPostId;
          newLikedPosts.removeWhere((e) => e == post.postId);
          likedPosts = likedPosts.copyWith(
            listofPostId: newLikedPosts,
          );
          final res =
              await _postApi.updateListOfLikedPostsOfCurrentUser(likedPosts);
          res.fold((l) {
            showSnackbar(context, l.message);
          }, (r) {
            showSnackbar(context, "You removed your like");
          });
        }
      },
    );
  }

  void addLikedPostToListOfCurrentUser(BuildContext context, String uid) async {
    final response =
        await _postApi.addLikedPostToListOfCurrentUser(LikedPostsOfCurrentUser(
      uid: uid,
      listofPostId: [],
    ));

    response.fold(
      (failure) {
        showSnackbar(context, 'Something went wrong');
        Navigator.pop(context);
      },
      (document) {
        showSnackbar(context, "Logged in successfully");
      },
    );
  }

  Future<LikedPostsOfCurrentUser> getListOfLikedPostsOfCurrentUser(
    String uid,
  ) async {
    final document = await _postApi.getListOfLikedPostsOfCurrentUser(uid);
    return LikedPostsOfCurrentUser.fromMap(document.data);
  }

  //Comments

  Future<Post> getCommentOfPost(Post post) async {
    state = true;
    final response = await _postApi.getCommentsOfPost(post);
    state = false;
    return Post.fromMap(response.data);
  }

  void addCommentsOfPost(BuildContext context, WidgetRef ref,
      UserComment userComment, Post post) async {
    post = post.copyWith(
      comments: [
        ...post.comments,
        userComment,
      ],
    );
    final response =
        await ref.watch(postApiProvider).updateCommentsOfPost(post);
    response.fold(
      (failure) {
        showSnackbar(context, 'Cannot add comment');
        dismissKeyboardOnLoseFocus(context);
      },
      (document) {
        showSnackbar(context, "Comment added successfully");
        dismissKeyboardOnLoseFocus(context);
      },
    );
  }

  void removeCommentsOfPost(BuildContext context, WidgetRef ref,
      UserComment comment, Post post) async {
    final newPostComment = post.comments;
    newPostComment.removeWhere((e) => e.commentId == comment.commentId);
    post = post.copyWith(
      comments: newPostComment,
    );

    final response =
        await ref.watch(postApiProvider).updateCommentsOfPost(post);

    response.fold(
      (failure) {
        showSnackbar(context, 'Cannot delete comment');
      },
      (document) {
        showSnackbar(context, 'Comment deleted');
      },
    );
  }
}

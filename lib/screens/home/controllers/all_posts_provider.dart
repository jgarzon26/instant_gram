import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instant_gram/apis/post_api.dart';
import 'package:instant_gram/apis/storage_api.dart';
import 'package:instant_gram/core/core.dart';
import 'package:instant_gram/models/liked_posts.dart';
import 'package:instant_gram/models/models.dart';

final allPostsProvider = StateNotifierProvider<AllPostsProvider, bool>(
    (ref) => AllPostsProvider(ref.watch(postApiProvider)));

final getPostsProvider = FutureProvider((ref) {
  final provider = ref.watch(allPostsProvider.notifier);
  return provider.getPosts();
});

final getLatestPostsProvider = StreamProvider((ref) {
  final allPostApi = ref.watch(allPostsProvider.notifier);
  return allPostApi.getLatestPosts();
});

final getCommentsProvider = FutureProvider.family((ref, Post post) {
  final provider = ref.watch(allPostsProvider.notifier);
  return provider.getCommentOfPost(post);
});

final getListOfLikedPostsOfCurrentUserProvider =
    FutureProvider.family((ref, String uid) {
  final provider = ref.watch(allPostsProvider.notifier);
  return provider.getListOfLikedPostsOfCurrentUser(uid);
});

class AllPostsProvider extends StateNotifier<bool> {
  final PostApi _postApi;

  AllPostsProvider(this._postApi) : super(false);

  //Posts

  void addPost(
    BuildContext context,
    WidgetRef ref,
    Post post,
  ) async {
    state = true;
    final response = await ref.watch(postApiProvider).createPost(post);
    return response.fold((failure) {
      showSnackbar(context, failure.message);
      state = false;
    }, (document) async {
      showSnackbar(context, "Post added successfully");
      Navigator.pop(context);
      state = false;
      await ref.watch(storageApiProvider).uploadMedia(post.media, post.postId);
      await ref
          .watch(storageApiProvider)
          .uploadThumbnail(post.thumbnail, post.postId);
    });
  }

  Future<List<Post>> getPosts() async {
    state = true;
    final posts = await _postApi.getPosts();
    state = false;
    return posts.map((post) => Post.fromMap(post.data)).toList();
  }

  Stream<RealtimeMessage> getLatestPosts() async* {
    yield* _postApi.getLatestPosts();
  }

  void removePost(BuildContext context, WidgetRef ref, Post post) async {
    state = true;
    final response = await _postApi.deletePost(post);
    response.fold(
      (failure) {
        showSnackbar(context, failure.message);
        state = false;
      },
      (document) async {
        Navigator.of(context).pop();
        showSnackbar(context, "Post deleted");
        state = false;
        await ref.watch(storageApiProvider).deleteMedia(post.postId);
        await ref.watch(storageApiProvider).deleteThumbnail(post.postId);
      },
    );
  }

  //Likes

  void updateLikes(BuildContext context, Post post, int scale,
      LikedPostsOfCurrentUser likedPosts) async {
    final newPost = post.copyWith(
      numberOfLikes: post.numberOfLikes + scale,
    );

    final response = await _postApi.updateLikesOfPost(newPost);
    response.fold(
      (failure) {
        showSnackbar(context, failure.message);
      },
      (document) async {
        //temp
        if (scale > 0) {
          final newLikedPosts = likedPosts.copyWith(
            posts: [
              ...likedPosts.posts,
              post.postId,
            ],
          );
          final res =
              await _postApi.updateListOfLikedPostsOfCurrentUser(newLikedPosts);
          res.fold((l) {
            showSnackbar(context, l.message);
          }, (r) {
            showSnackbar(context, "You liked this post");
          });
        } else {
          final newLikedPosts = likedPosts.posts;
          newLikedPosts.removeWhere((e) => e == post.postId);
          likedPosts = likedPosts.copyWith(
            posts: newLikedPosts,
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

  void addLikedPostToListOfCurrentUser(
    BuildContext context,
    WidgetRef ref,
    String uid,
  ) async {
    final response =
        await _postApi.addLikedPostToListOfCurrentUser(LikedPostsOfCurrentUser(
      uid: uid,
      posts: [],
    ));

    response.fold(
      (failure) {
        if (failure.message.toLowerCase().contains("exist")) {
          showSnackbar(context, "Logged in successfully");
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          showSnackbar(context, failure.message);
        }
      },
      (document) {
        showSnackbar(context, "Logged in successfully");
        Navigator.pushReplacementNamed(context, '/home');
      },
    );
  }

  /* Future<List<LikedPostsOfCurrentUser>> _getListOfLikedPostsOfAllUsers() async {
    final documents = await _postApi.getListOfLikedPostsOfAllUsers();
    return documents
        .map((e) => LikedPostsOfCurrentUser.fromMap(e.data))
        .toList();
  } */

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

  void addCommentsOfPost(
    BuildContext context,
    WidgetRef ref,
    UserComment userComment,
    Post post,
  ) async {
    final newPost = post.copyWith(
      commentId: [
        ...post.commentId,
        userComment.commentId,
      ],
      comments: [
        ...post.comments,
        userComment.comment,
      ],
      commentsUserName: [
        ...post.commentsUserName,
        userComment.userName,
      ],
    );
    final response =
        await ref.watch(postApiProvider).updateCommentsOfPost(newPost);
    response.fold(
      (failure) {
        showSnackbar(context, failure.message);
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
    final newPost = post;
    int indexOfComment = newPost.commentId.indexOf(comment.commentId);
    newPost.commentId.removeAt(indexOfComment);
    newPost.comments.removeAt(indexOfComment);
    newPost.commentsUserName.removeAt(indexOfComment);

    final response =
        await ref.watch(postApiProvider).updateCommentsOfPost(newPost);

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

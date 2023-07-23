import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instant_gram/models/liked_posts.dart';
import 'package:instant_gram/models/models.dart';
import 'package:instant_gram/screens/home/controllers/all_posts_provider.dart';
import 'package:instant_gram/screens/post_detail/view/comment_modal.dart';

class PostActionButtons extends ConsumerWidget {
  const PostActionButtons({
    required this.onPressed,
    required this.postId,
    super.key,
  });

  final String postId;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: Future(
          () => ref.watch(allPostsProvider.notifier).getPostById(postId)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        } else if (snapshot.hasError) {
          return const Text("Error");
        } else {
          final post = snapshot.data as Post;
          return FutureBuilder(
            future: ref
                .watch(allPostsProvider.notifier)
                .getListOfLikedPostsOfCurrentUser(post.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox.shrink();
              } else if (snapshot.hasError) {
                return const SizedBox.shrink();
              } else {
                final likedPosts = snapshot.data as LikedPostsOfCurrentUser;
                final hasLiked = likedPosts.posts.contains(post.postId);
                return ref.watch(getLatestListOfLikedPostsProvider).when(
                  data: (data) {
                    return buildActionButtons(
                        post, context, hasLiked, ref, likedPosts);
                  },
                  error: (e, st) {
                    return const SizedBox.shrink();
                  },
                  loading: () {
                    return buildActionButtons(
                        post, context, hasLiked, ref, likedPosts);
                  },
                );
              }
            },
          );
        }
      },
    );
  }

  Widget buildActionButtons(Post post, BuildContext context, bool hasLiked,
      WidgetRef ref, LikedPostsOfCurrentUser likedPosts) {
    return SizedBox(
      height: (post.allowLikes == false && post.allowComments == false)
          ? MediaQuery.of(context).size.height * 0.05
          : null,
      child: Row(
        children: [
          Visibility(
            visible: post.allowLikes,
            child: IconButton(
              onPressed: () {
                hasLiked
                    ? ref.read(allPostsProvider.notifier).updateLikes(
                          context,
                          post,
                          false,
                          likedPosts,
                          onPressed,
                        )
                    : ref.read(allPostsProvider.notifier).updateLikes(
                          context,
                          post,
                          true,
                          likedPosts,
                          onPressed,
                        );
              },
              icon: !hasLiked
                  ? const Icon(Icons.favorite_border)
                  : const Icon(Icons.favorite),
            ),
          ),
          Visibility(
            visible: post.allowComments,
            child: IconButton(
              onPressed: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  useSafeArea: true,
                  context: context,
                  builder: (_) {
                    return CommentModal(
                      post: post,
                    );
                  },
                );
              },
              icon: const Icon(Icons.mode_comment_outlined),
            ),
          ),
        ],
      ),
    );
  }
}

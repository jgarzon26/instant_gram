import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instant_gram/models/models.dart';
import 'package:instant_gram/screens/home/controllers/all_posts_provider.dart';

class MiniCommentsSection extends ConsumerWidget {
  const MiniCommentsSection({
    super.key,
    required this.post,
  });
  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: Future(
          () => ref.watch(allPostsProvider.notifier).getPostById(post.postId)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        } else {
          final post = snapshot.data as Post;
          final userComments = UserComment.toUserComment(
              comments: post.comments, commentsUserName: post.commentsUserName);
          return ref.watch(getLatestPostsProvider).when(
                data: (data) {
                  return buildMiniCommentsBody(context, userComments);
                },
                error: (e, st) => Center(
                  child: Text(e.toString()),
                ),
                loading: () => buildMiniCommentsBody(context, userComments),
              );
        }
      },
    );
  }

  ListView buildMiniCommentsBody(
      BuildContext context, List<UserComment> comments) {
    List<UserComment> limitedComments;

    if (comments.length <= 3) {
      limitedComments = comments;
    } else {
      limitedComments = comments.sublist(0, 3);
    }
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: limitedComments.map((comment) {
        return Column(
          children: [
            Row(
              children: [
                Text(
                  comment.userName,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 18,
                      ),
                ),
                const SizedBox(width: 8),
                Text(
                  comment.comment,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        );
      }).toList(),
    );
  }
}

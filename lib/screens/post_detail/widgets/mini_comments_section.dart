import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instant_gram/models/models.dart';
import 'package:instant_gram/screens/home/controllers/all_posts_provider.dart';

class MiniCommentsSection extends ConsumerWidget {
  const MiniCommentsSection({
    super.key,
    required this.context,
    required this.post,
  });

  final BuildContext context;
  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(allPostsProvider);
    final index = posts.indexWhere(
        (element) => element.userPost.postId == post.userPost.postId);
    List<UserComment> comments = ref.watch(allPostsProvider)[index].comments;
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: comments.map((comment) {
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

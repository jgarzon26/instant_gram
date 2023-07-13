import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instant_gram/common/common.dart';
import 'package:instant_gram/models/models.dart';

import '../../home/controllers/all_posts_provider.dart';

class CommentListTile extends ConsumerWidget {
  const CommentListTile({
    super.key,
    required this.userComment,
    required this.post,
    required this.resetState,
  });

  final UserComment userComment;
  final Post post;
  final VoidCallback resetState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(userComment.userName,
          style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(userComment.comment),
      trailing: DeleteIcon(
          post: post,
          onPressed: () {
            ref
                .read(allPostsProvider.notifier)
                .deleteCommentFromUser(post, userComment);
            resetState;
          }),
    );
  }
}

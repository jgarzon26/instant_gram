import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instant_gram/core/utils.dart';
import 'package:instant_gram/models/models.dart';
import 'package:instant_gram/screens/home/controllers/all_posts_provider.dart';
import 'package:instant_gram/screens/post_detail/view/comment_modal.dart';

class PostActionButtons extends ConsumerStatefulWidget {
  const PostActionButtons({
    super.key,
    required this.allowLikes,
    required this.allowComments,
    required this.post,
    this.onLiked,
  });

  final bool allowLikes, allowComments;
  final Post post;
  final VoidCallback? onLiked;

  @override
  ConsumerState<PostActionButtons> createState() => _PostActionButtonsState();
}

class _PostActionButtonsState extends ConsumerState<PostActionButtons> {
  bool hasLiked = false;

  @override
  void initState() {
    super.initState();
    hasLiked = ref.read(allPostsProvider.notifier).likes.contains(widget.post);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (widget.allowLikes == false && widget.allowComments == false)
          ? MediaQuery.of(context).size.height * 0.05
          : null,
      child: Row(
        children: [
          Visibility(
            visible: widget.allowLikes,
            child: IconButton(
              onPressed: () {
                setState(() {
                  hasLiked = !hasLiked;
                });
                widget.onLiked?.call();
                hasLiked
                    ? ref
                        .read(allPostsProvider.notifier)
                        .incrementLike(widget.post)
                    : ref
                        .read(allPostsProvider.notifier)
                        .decrementLike(widget.post);
                showSnackbar(context,
                    hasLiked ? "You liked this post" : "You removed your like");
              },
              icon: !hasLiked
                  ? const Icon(Icons.favorite_border)
                  : const Icon(Icons.favorite),
            ),
          ),
          Visibility(
            visible: widget.allowComments,
            child: IconButton(
              onPressed: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  useSafeArea: true,
                  context: context,
                  builder: (_) {
                    return CommentModal(
                      post: widget.post,
                      onCommentAdded: widget.onLiked,
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

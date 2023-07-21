import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instant_gram/models/models.dart';
import 'package:instant_gram/screens/home/controllers/all_posts_provider.dart';
import 'package:instant_gram/screens/post_detail/view/comment_modal.dart';

class PostActionButtons extends ConsumerStatefulWidget {
  const PostActionButtons({
    super.key,
    required this.allowLikes,
    required this.allowComments,
    required this.post,
  });

  final bool allowLikes, allowComments;
  final Post post;

  @override
  ConsumerState<PostActionButtons> createState() => _PostActionButtonsState();
}

class _PostActionButtonsState extends ConsumerState<PostActionButtons> {
  bool hasLiked = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ref
        .watch(getListOfLikedPostsOfCurrentUserProvider(widget.post.uid))
        .when(
      data: (posts) {
        if (posts.posts.contains(widget.post.postId)) {
          hasLiked = true;
        }
        return buildActionButtons(context);
      },
      error: (e, st) {
        return const SizedBox.shrink();
      },
      loading: () {
        return const SizedBox.shrink();
      },
    );
  }

  SizedBox buildActionButtons(BuildContext context) {
    return SizedBox(
      height: (widget.allowLikes == false && widget.allowComments == false)
          ? MediaQuery.of(context).size.height * 0.05
          : null,
      child: Row(
        children: [
          Visibility(
            visible: widget.allowLikes,
            child: IconButton(
              onPressed: () async {
                await ref
                    .read(allPostsProvider.notifier)
                    .getListOfLikedPostsOfCurrentUser(widget.post.uid)
                    .then((value) {
                  hasLiked
                      ? ref.read(allPostsProvider.notifier).updateLikes(
                            context,
                            widget.post,
                            1,
                            value,
                          )
                      : ref.read(allPostsProvider.notifier).updateLikes(
                            context,
                            widget.post,
                            -1,
                            value,
                          );
                });
                setState(() {
                  hasLiked = !hasLiked;
                });
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instant_gram/core/utils.dart';
import 'package:instant_gram/models/models.dart';
import 'package:instant_gram/screens/auth/controller/auth_controller.dart';
import 'package:instant_gram/screens/home/controllers/all_posts_provider.dart';
import 'package:instant_gram/screens/post_detail/widgets/comment_listtile.dart';

class CommentModal extends ConsumerStatefulWidget {
  const CommentModal({
    super.key,
    required this.post,
    this.onCommentAdded,
  });

  final Post post;
  final VoidCallback? onCommentAdded;

  @override
  ConsumerState<CommentModal> createState() => _CommentModalState();
}

class _CommentModalState extends ConsumerState<CommentModal> {
  final TextEditingController inputCommentController = TextEditingController();
  late final List<UserComment> comments;
  late final int index;

  @override
  void initState() {
    super.initState();
    final posts = ref.read(allPostsProvider);
    index = posts.indexWhere((element) => element.postId == widget.post.postId);
  }

  @override
  void dispose() {
    inputCommentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<UserComment> comments = ref.watch(allPostsProvider)[index].comments;
    return GestureDetector(
      onTap: () => dismissKeyboardOnLoseFocus(context),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text("Comments"),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () async {
                String userName = await ref
                    .read(authControllerProvider.notifier)
                    .getUserDetails(context)
                    .then((user) {
                  showSnackbar(context, "Comment added successfully");
                  dismissKeyboardOnLoseFocus(context);
                  return user.name;
                });
                final userComment = UserComment(
                  comment: inputCommentController.text,
                  userName: userName,
                );
                if (inputCommentController.text.isNotEmpty) {
                  ref.read(allPostsProvider.notifier).addCommentToUser(
                        widget.post,
                        userComment,
                      );
                  setState(() {
                    comments.add(userComment);
                  });
                  widget.onCommentAdded?.call();
                  inputCommentController.clear();
                }
              },
              icon: const Icon(Icons.send),
            ),
          ],
        ),
        body: Stack(
          children: [
            comments.isEmpty
                ? displayEmptySection(context)
                : buildCommentsSection(comments, widget.post),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: inputCommentController,
                  decoration: const InputDecoration(
                    hintText: "Write your comment here...",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget displayEmptySection(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: 40,
        vertical: 20,
      ),
      children: [
        Text(
          "Nobody has commented on this post yet. You can change that though, and be the first person who comments!",
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: Colors.white38,
                fontSize: 20,
              ),
        ),
        Expanded(
          child: Image.asset(
            "assets/images/empty_search.png",
            height: MediaQuery.of(context).size.height * 0.3,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }

  Widget buildCommentsSection(List<UserComment> comments, Post post) {
    return ListView.builder(
      itemCount: comments.length,
      itemBuilder: (context, index) {
        return CommentListTile(
          userComment: comments[index],
          post: post,
          onDelete: () {
            setState(() {
              comments.removeAt(index);
            });
          },
        );
      },
    );
  }
}

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
  });

  final Post post;

  @override
  ConsumerState<CommentModal> createState() => _CommentModalState();
}

class _CommentModalState extends ConsumerState<CommentModal> {
  final TextEditingController inputCommentController = TextEditingController();
  List<UserComment> userComments = [];

  @override
  void initState() {
    super.initState();
    userComments = UserComment.toUserComment(
      comments: widget.post.comments,
      commentsUserName: widget.post.commentsUserName,
    );
  }

  @override
  void dispose() {
    inputCommentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                await ref
                    .read(authControllerProvider.notifier)
                    .getUserDetails()
                    .then((user) {
                  final userComment = UserComment(
                    comment: inputCommentController.text,
                    userName: user.name,
                  );
                  ref.read(allPostsProvider.notifier).addCommentsOfPost(
                      context, ref, userComment, widget.post);
                });
              },
              icon: const Icon(Icons.send),
            ),
          ],
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            widget.post.comments.isEmpty
                ? displayEmptySection(context)
                : buildCommentsSection(),
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
        Image.asset(
          "assets/images/empty_search.png",
          height: MediaQuery.of(context).size.height * 0.3,
          fit: BoxFit.cover,
        ),
      ],
    );
  }

  Widget buildCommentsSection() {
    return ListView.builder(
      itemCount: widget.post.comments.length,
      itemBuilder: (context, index) {
        return CommentListTile(
          userComment: userComments[index],
          post: widget.post,
        );
      },
    );
  }
}

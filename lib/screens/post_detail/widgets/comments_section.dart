import 'package:flutter/material.dart';
import 'package:instant_gram/screens/post_detail/widgets/comment_listtile.dart';

import '../../../models/models.dart';

class CommentsSection extends StatefulWidget {
  const CommentsSection({
    super.key,
    required this.comments,
    required this.post,
    required this.onDelete,
  });

  final List<UserComment> comments;
  final Post post;
  final VoidCallback onDelete;

  @override
  State<CommentsSection> createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.comments.length,
      itemBuilder: (context, index) {
        return CommentListTile(
          userComment: widget.comments[index],
          post: widget.post,
          onDelete: () {
            setState(() {
              widget.comments.removeAt(index);
              widget.onDelete();
            });
          },
        );
      },
    );
  }
}

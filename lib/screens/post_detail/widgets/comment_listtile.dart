import 'package:flutter/material.dart';

class CommentListTile extends StatelessWidget {
  const CommentListTile({
    super.key,
    required this.userName,
    required this.comment,
  });

  final String userName, comment;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title:
            Text(userName, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(comment),
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.delete),
        ));
  }
}

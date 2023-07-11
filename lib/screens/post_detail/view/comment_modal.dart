import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instant_gram/models/models.dart';
import 'package:instant_gram/screens/home/controllers/all_posts_provider.dart';

class CommentModal extends ConsumerWidget {
  const CommentModal({
    super.key,
    required this.post,
  });

  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref
        .watch(allPostsProvider)
        .where((post) => post.userPost.id == this.post.userPost.id)
        .toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("Comments"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.send),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return Column(
                  children: getAllCommentsFromUser(
                    "Anonymous User",
                    posts[index],
                  ),
                );
              },
            ),
          ),
          const TextField(),
        ],
      ),
    );
  }

  List<Widget> getAllCommentsFromUser(String userName, Post post) {
    final List<Widget> comments = [];
    for (final comment in post.comments) {
      comments.add(
        ListTile(
          title: Text(userName),
          subtitle: Text(comment),
        ),
      );
    }
    return comments;
  }
}

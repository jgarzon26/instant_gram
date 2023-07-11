import 'package:flutter/material.dart';
import 'package:instant_gram/models/models.dart';

import '../widgets/posts_grid_view.dart';

class UserPostsPage extends StatelessWidget {
  final List<Post> userPosts;

  const UserPostsPage({
    super.key,
    required this.userPosts,
  });

  @override
  Widget build(BuildContext context) {
    return userPosts.isNotEmpty
        ? PostsGridView(userPosts: userPosts)
        : displayEmptyList();
  }

  Widget displayEmptyList() {
    return const Center(
      child: Text("No Posts Yet"),
    );
  }
}

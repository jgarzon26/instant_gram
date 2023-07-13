import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/posts_grid_view.dart';

class UserPostsPage extends ConsumerWidget {
  final ProviderListenable provider;

  const UserPostsPage({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPosts = ref.watch(provider);
    return userPosts.isNotEmpty
        ? PostsGridView(provider: provider)
        : displayEmptyList();
  }

  Widget displayEmptyList() {
    return const Center(
      child: Text("No Posts Yet"),
    );
  }
}

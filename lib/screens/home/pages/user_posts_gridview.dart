import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instant_gram/screens/home/controllers/user_post_provider.dart';
import 'package:instant_gram/screens/home/widgets/posts_grid_view.dart';

class UserPostsGridView extends ConsumerWidget {
  final User user;

  const UserPostsGridView({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getLatestOfCurrentUserProvider).when(
          data: (data) {
            return ref.watch(getPostsOfCurrentUserProvider(user.$id)).when(
                data: (userPosts) {
              return userPosts.isNotEmpty
                  ? PostsGridView(
                      userPosts: userPosts,
                    )
                  : displayEmptyList();
            }, error: (e, stackTrace) {
              return Center(
                child: Text(e.toString()),
              );
            }, loading: () {
              return const Center(child: CircularProgressIndicator.adaptive());
            });
          },
          error: (error, stackTrace) => Center(child: Text(error.toString())),
          loading: () =>
              const Center(child: CircularProgressIndicator.adaptive()),
        );
  }

  Widget displayEmptyList() {
    return const Center(
      child: Text("No Posts Yet"),
    );
  }
}

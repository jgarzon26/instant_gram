import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instant_gram/screens/auth/controller/auth_controller.dart';
import 'package:instant_gram/screens/home/controllers/user_post_provider.dart';
import 'package:instant_gram/screens/home/widgets/posts_grid_view.dart';

class UserPostsGridView extends ConsumerWidget {
  const UserPostsGridView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getLatestOfCurrentUserProvider).when(
          data: (data) {
            return ref.watch(getUserDetailsProvider).when(
                  data: (user) {
                    return ref
                        .watch(getPostsOfCurrentUserProvider(user.$id))
                        .when(
                            data: (userPosts) {
                              return userPosts.isNotEmpty
                                  ? PostsGridView(
                                      userPosts: userPosts,
                                    )
                                  : displayEmptyList();
                            },
                            error: (e, stackTrace) =>
                                Center(child: Text(e.toString())),
                            loading: () => const Center(
                                child: /*CircularProgressIndicator.adaptive()*/
                                    Text("Post loading")));
                  },
                  error: (e, st) => Center(child: Text(e.toString())),
                  loading: () => const Center(
                      child: /*CircularProgressIndicator.adaptive()*/
                          Text("User loading")),
                );
          },
          error: (error, stackTrace) => Center(child: Text(error.toString())),
          loading: () => const Center(
              child: /*CircularProgressIndicator.adaptive()*/
                  Text("Stream loading")),
        );
  }

  Widget displayEmptyList() {
    return const Center(
      child: Text("No Posts Yet"),
    );
  }
}

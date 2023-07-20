import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instant_gram/constants/ui_constant.dart';
import 'package:instant_gram/models/post.dart';
import 'package:instant_gram/screens/auth/controller/auth_controller.dart';
import 'package:instant_gram/screens/home/controllers/user_post_provider.dart';
import 'package:instant_gram/screens/home/widgets/posts_grid_view.dart';

class UserPostsGridView extends ConsumerWidget {
  const UserPostsGridView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getUserDetailsProvider).when(
          data: (user) {
            return FutureBuilder(
              future: ref
                  .watch(userPostProvider.notifier)
                  .getPostsOfCurrentUser(user.$id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  final userPosts = snapshot.data as List<Post>;
                  return ref.watch(getLatestOfCurrentUserProvider).when(
                      data: (data) {
                        return userPosts.isNotEmpty
                            ? PostsGridView(
                                userPosts: userPosts,
                              )
                            : displayEmptyList();
                      },
                      error: (e, stackTrace) =>
                          Center(child: Text(e.toString())),
                      loading: () => userPosts.isNotEmpty
                          ? PostsGridView(
                              userPosts: userPosts,
                            )
                          : displayEmptyList());
                }
              },
            );
          },
          error: (error, stackTrace) => Center(child: Text(error.toString())),
          loading: () => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        );
  }
}

/*
return ref.watch(getPostsOfCurrentUserProvider(user.$id)).when(
                  data: (userPosts) {
                    return ref.watch(getLatestOfCurrentUserProvider).when(
                        data: (data) {
                          return userPosts.isNotEmpty
                              ? PostsGridView(
                                  userPosts: userPosts,
                                )
                              : displayEmptyList();
                        },
                        error: (e, stackTrace) =>
                            Center(child: Text(e.toString())),
                        loading: () => userPosts.isNotEmpty
                            ? PostsGridView(
                                userPosts: userPosts,
                              )
                            : displayEmptyList());
                  },
                  error: (e, st) => Center(child: Text(e.toString())),
                  loading: () =>
                      const Center(child: CircularProgressIndicator.adaptive()),
                );
 */

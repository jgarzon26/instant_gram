import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instant_gram/constants/ui_constant.dart';
import 'package:instant_gram/models/models.dart';
import 'package:instant_gram/screens/home/controllers/all_posts_provider.dart';
import 'package:instant_gram/screens/home/widgets/posts_grid_view.dart';

class CommonPostsGridView extends ConsumerWidget {
  final List<Post> posts;

  const CommonPostsGridView({
    super.key,
    required this.posts,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getLatestPostsProvider).when(
          data: (data) => posts.isNotEmpty
              ? PostsGridView(
                  userPosts: posts,
                )
              : displayEmptyList(),
          error: (error, stackTrace) => Center(child: Text(error.toString())),
          loading: () => posts.isNotEmpty
              ? PostsGridView(
                  userPosts: posts,
                )
              : displayEmptyList(),
        );
  }
}

/*return ref.watch(getPostsProvider).when(
          data: (posts) {
            return ref.watch(getLatestPostsProvider).when(
                  data: (data) => posts.isNotEmpty
                      ? PostsGridView(
                          userPosts: posts,
                        )
                      : displayEmptyList(),
                  error: (error, stackTrace) =>
                      Center(child: Text(error.toString())),
                  loading: () => posts.isNotEmpty
                      ? PostsGridView(
                          userPosts: posts,
                        )
                      : displayEmptyList(),
                );
          },
          error: (error, stackTrace) => Center(child: Text(error.toString())),
          loading: () => const Center(
              child: /*CircularProgressIndicator.adaptive()*/
                  Text("Stream loading")),
        ); */
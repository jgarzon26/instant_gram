import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instant_gram/constants/ui_constant.dart';
import 'package:instant_gram/models/models.dart';
import 'package:instant_gram/screens/home/controllers/all_posts_provider.dart';
import 'package:instant_gram/screens/home/widgets/posts_grid_view.dart';

class CommonPostsGridView extends ConsumerWidget {
  const CommonPostsGridView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: ref.watch(allPostsProvider.notifier).getPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        } else {
          final posts = snapshot.data as List;
          return ref.watch(getLatestPostsProvider).when(
                data: (data) => posts.isNotEmpty
                    ? PostsGridView(
                        userPosts: snapshot.data as List<Post>,
                      )
                    : displayEmptyList(),
                error: (error, stackTrace) =>
                    Center(child: Text(error.toString())),
                loading: () => posts.isNotEmpty
                    ? PostsGridView(
                        userPosts: snapshot.data as List<Post>,
                      )
                    : displayEmptyList(),
              );
        }
      },
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
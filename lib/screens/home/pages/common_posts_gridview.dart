import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instant_gram/constants/appwrite.dart';
import 'package:instant_gram/models/models.dart';
import 'package:instant_gram/screens/home/controllers/all_posts_provider.dart';
import 'package:instant_gram/screens/home/widgets/posts_grid_view.dart';

class CommonPostsGridView extends ConsumerWidget {
  const CommonPostsGridView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getLatestPostsProvider).when(
          data: (data) {
            return ref.watch(getPostsProvider).when(
                  data: (posts) {
                    if (data.events.contains(
                      'databases.*.collections.${Appwrite.postDetailscollectionId}.documents.*.create',
                    )) {
                      posts.insert(0, Post.fromMap(data.payload));
                    } else if (data.events.contains(
                      'databases.*.collections.${Appwrite.postDetailscollectionId}.documents.*.update',
                    )) {
                      final startPoint =
                          data.events[0].lastIndexOf('documents.');
                      final endPoint = data.events[0].lastIndexOf('.update');
                      final postId =
                          data.events[0].substring(startPoint + 10, endPoint);

                      var post = posts
                          .where((element) => element.postId == postId)
                          .first;

                      final postIndex = posts.indexOf(post);
                      posts.removeWhere((element) => element.postId == postId);

                      post = Post.fromMap(data.payload);
                      posts.insert(postIndex, post);
                    }

                    return PostsGridView(userPosts: posts);
                  },
                  error: (error, stackTrace) =>
                      Center(child: Text(error.toString())),
                  loading: () => const Center(
                      child: /*CircularProgressIndicator.adaptive()*/
                          Text("Post loading")),
                );
          },
          error: (error, stackTrace) => Center(child: Text(error.toString())),
          loading: () => const Center(
              child: /*CircularProgressIndicator.adaptive()*/
                  Text("Stream loading")),
        );
  }
}

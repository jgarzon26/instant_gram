import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instant_gram/models/models.dart';
import 'package:instant_gram/screens/home/controllers/all_posts_provider.dart';
import 'package:instant_gram/screens/home/controllers/user_post_provider.dart';

import '../../post_detail/view/post_detail.dart';

class PostsGridView extends ConsumerWidget {
  const PostsGridView({
    super.key,
    required this.provider,
    this.shrinkWrap = false,
  });

  final ProviderListenable provider;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (provider is UserPostProvider) {
      return buildPostsGridView(
          ref.watch(userPostProvider.notifier).getPostsOfOwner());
    } else if (provider is AllPostsProvider) {
      ref.watch(allPostsProvider.notifier).initState(context, ref);
      return buildPostsGridView(ref.watch(
          allPostsFutureProvider as ProviderListenable<Future<List<Post>>>));
    } else {
      throw Exception("Invalid Provider or Not Implemented");
    }
  }

  Widget buildPostsGridView(Future<List<Post>> userPosts) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
          future: userPosts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text("Can't load posts"));
            } else {
              return GridView.builder(
                shrinkWrap: shrinkWrap,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 20,
                  crossAxisCount: 3,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => PostDetail(
                                  post: snapshot.data![index],
                                  tag: snapshot.data![index].postId,
                                )),
                      );
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      fit: StackFit.expand,
                      children: [
                        Hero(
                          tag: snapshot.data![index].postId,
                          child: Image.file(
                            File(snapshot.data![index].thumbnail),
                            fit: BoxFit.cover,
                          ),
                        ),
                        if (snapshot.data![index].isVideo)
                          const Icon(
                            Icons.play_circle_outline,
                            size: 50,
                            color: Colors.white54,
                          ),
                      ],
                    ),
                  );
                },
              );
            }
          }),
    );
  }
}

class CustomPostsGridView extends ConsumerWidget {
  const CustomPostsGridView({
    super.key,
    required this.userPosts,
    this.shrinkWrap = false,
  });

  final List<Post> userPosts;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        shrinkWrap: shrinkWrap,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 10,
          mainAxisSpacing: 20,
          crossAxisCount: 3,
        ),
        itemCount: userPosts.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => PostDetail(
                          post: userPosts[index],
                          tag: userPosts[index].postId,
                        )),
              );
            },
            child: Stack(
              alignment: Alignment.center,
              fit: StackFit.expand,
              children: [
                Hero(
                  tag: userPosts[index].postId,
                  child: Image.file(
                    File(userPosts[index].thumbnail),
                    fit: BoxFit.cover,
                  ),
                ),
                if (userPosts[index].isVideo)
                  const Icon(
                    Icons.play_circle_outline,
                    size: 50,
                    color: Colors.white54,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

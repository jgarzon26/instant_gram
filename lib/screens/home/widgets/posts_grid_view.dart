import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instant_gram/models/models.dart';
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
    final userPosts = ref.watch(provider);
    return (provider is UserPostProvider)
        ? buildGridViewForUserPosts(ref)
        : buildGridViewForAllPosts(userPosts);
  }

  Widget buildGridViewForUserPosts(WidgetRef ref) {
    return StreamBuilder(
        stream: ref.watch(userPostProvider.notifier).getPostsOfOwner(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userPosts = snapshot.data as List<Post>;
            return buildGridViewForAllPosts(userPosts);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget buildGridViewForAllPosts(userPosts) {
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
                          tag: userPosts[index].userPost.postId,
                        )),
              );
            },
            child: Stack(
              alignment: Alignment.center,
              fit: StackFit.expand,
              children: [
                Hero(
                  tag: userPosts[index].userPost.postId,
                  child: Image.file(
                    File(userPosts[index].userPost.thumbnail),
                    fit: BoxFit.cover,
                  ),
                ),
                if (userPosts[index].userPost.isVideo)
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
                          tag: userPosts[index].userPost.postId,
                        )),
              );
            },
            child: Stack(
              alignment: Alignment.center,
              fit: StackFit.expand,
              children: [
                Hero(
                  tag: userPosts[index].userPost.postId,
                  child: Image.file(
                    File(userPosts[index].userPost.thumbnail),
                    fit: BoxFit.cover,
                  ),
                ),
                if (userPosts[index].userPost.isVideo)
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

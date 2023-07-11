import 'dart:io';

import 'package:flutter/material.dart';

import '../../../models/models.dart';
import '../../post_detail/view/post_detail.dart';

class PostsGridView extends StatelessWidget {
  const PostsGridView({
    super.key,
    required this.userPosts,
    this.shrinkWrap = false,
  });

  final List<Post> userPosts;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
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
                          tag: userPosts[index].userPost.id,
                        )),
              );
            },
            child: Stack(
              alignment: Alignment.center,
              fit: StackFit.expand,
              children: [
                Hero(
                  tag: userPosts[index].userPost.id,
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

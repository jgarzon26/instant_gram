import 'dart:io';

import 'package:flutter/material.dart';
import 'package:instant_gram/models/models.dart';
import 'package:instant_gram/screens/post_detail/view/post_detail.dart';

class PostsGridView extends StatelessWidget {
  final List<Post> userPosts;
  final bool shrinkWrap;
  final VoidCallback? onPostSelected;

  const PostsGridView({
    super.key,
    required this.userPosts,
    this.shrinkWrap = false,
    this.onPostSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
            if (onPostSelected != null) {
              onPostSelected!();
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
    );
  }
}

import 'package:flutter/material.dart';
import 'package:instant_gram/models/models.dart';
import 'package:instant_gram/screens/post_detail/view/post_detail.dart';

class UserPostsPage extends StatelessWidget {
  final List<Post> userPosts;

  const UserPostsPage({
    super.key,
    required this.userPosts,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 10,
          mainAxisSpacing: 20,
          crossAxisCount: 3,
        ),
        itemCount: userPosts.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => PostDetail(
                          post: userPosts[index],
                          tag: userPosts[index].userPost.id,
                        )),
              );
            },
            child: Hero(
              tag: userPosts[index].userPost.id,
              child: Image.network(
                userPosts[index].userPost.path,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}

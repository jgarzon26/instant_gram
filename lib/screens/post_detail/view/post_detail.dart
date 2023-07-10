import 'package:flutter/material.dart';
import 'package:instant_gram/models/models.dart';
import 'package:intl/intl.dart';

class PostDetail extends StatelessWidget {
  final Post post;
  final String tag;

  const PostDetail({
    super.key,
    required this.post,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post Details"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share),
          ),
          //exists if the user is the owner of the post
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Column(
        children: [
          Hero(
            tag: tag,
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: Image.network(post.userPost.path, fit: BoxFit.cover),
            ),
          ),
          SizedBox(
            height: (post.userPost.allowLikes == false &&
                    post.userPost.allowComments == false)
                ? MediaQuery.of(context).size.height * 0.05
                : null,
            child: Row(
              children: [
                Visibility(
                  visible: post.userPost.allowLikes,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.favorite_border),
                  ),
                ),
                Visibility(
                  visible: post.userPost.allowComments,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.mode_comment_outlined),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Owner User",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: 18,
                          ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      post.userPost.description,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${DateFormat.d().format(post.userPost.postDate)} ${DateFormat.MMM().format(post.userPost.postDate)}, ${DateFormat.y().format(post.userPost.postDate)}, ${DateFormat.jm().format(post.userPost.postDate)}",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.normal,
                          letterSpacing: 1.2,
                        ),
                  ),
                ),
                const Divider(
                  height: 60,
                  thickness: 3,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${post.numberOfLikes} ${changePerson()} liked this",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.normal,
                          letterSpacing: 1.2,
                        ),
                  ),
                ),
                const SizedBox(height: 15),
                post.comments.length >= 3
                    ? buildLatestComments(context)
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLatestComments(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(post.comments.length, (index) {
        return Column(
          children: [
            Row(
              children: [
                Text(
                  "Sample User $index",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 18,
                      ),
                ),
                const SizedBox(width: 8),
                Text(
                  post.comments[index],
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        );
      }),
    );
  }

  String changePerson() {
    if (post.numberOfLikes <= 1) {
      return "person";
    } else {
      return "persons";
    }
  }
}

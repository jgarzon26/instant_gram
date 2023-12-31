import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instant_gram/common/common.dart';
import 'package:instant_gram/models/models.dart';
import 'package:instant_gram/screens/home/controllers/all_posts_provider.dart';
import 'package:instant_gram/screens/post_detail/widgets/mini_comments_section.dart';
import 'package:instant_gram/screens/post_detail/widgets/post_action_buttons.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

class PostDetail extends ConsumerStatefulWidget {
  final Post post;
  final String tag;

  const PostDetail({
    super.key,
    required this.post,
    required this.tag,
  });

  @override
  ConsumerState<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends ConsumerState<PostDetail> {
  VideoPlayerController? videoPlayerController;

  @override
  void initState() {
    super.initState();
    if (widget.post.isVideo) {
      videoPlayerController = VideoPlayerController.file(
        File(widget.post.media.path),
      )..initialize().then((value) {
          setState(() {});
        });
    }
  }

  @override
  void dispose() {
    videoPlayerController?.dispose();
    super.dispose();
  }

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
          DeleteIcon(
            post: widget.post,
            onPressed: () {
              ref
                  .read(allPostsProvider.notifier)
                  .removePost(context, ref, widget.post);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Hero(
            tag: widget.tag,
            child: MediaDisplay(
              videoPlayerController: videoPlayerController,
              isVideo: widget.post.isVideo,
              path: widget.post.media.path,
            ),
          ),
          PostActionButtons(
            postId: widget.post.postId,
            onPressed: () {
              setState(() {});
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      widget.post.username,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: 18,
                          ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.post.description,
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
                    "${DateFormat.d().format(widget.post.postDate)} ${DateFormat.MMM().format(widget.post.postDate)}, ${DateFormat.y().format(widget.post.postDate)}, ${DateFormat.jm().format(widget.post.postDate)}",
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
                FutureBuilder(
                    future: Future(() => ref
                        .watch(allPostsProvider.notifier)
                        .getPostById(widget.post.postId)),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox.shrink(),
                        );
                      } else if (snapshot.hasError) {
                        return Align(
                            alignment: Alignment.centerLeft,
                            child: Text(snapshot.error.toString()));
                      } else {
                        Post post = snapshot.data as Post;
                        return ref.watch(getLatestPostsProvider).when(
                              data: (data) {
                                return Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "${post.numberOfLikes} ${changePerson(post.numberOfLikes)} liked this",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.normal,
                                          letterSpacing: 1.2,
                                        ),
                                  ),
                                );
                              },
                              error: (e, st) => Center(
                                child: Text(e.toString()),
                              ),
                              loading: () {
                                return Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "${post.numberOfLikes} ${changePerson(post.numberOfLikes)} liked this",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.normal,
                                          letterSpacing: 1.2,
                                        ),
                                  ),
                                );
                              },
                            );
                      }
                    }),
                const SizedBox(height: 15),
                widget.post.comments.isNotEmpty
                    ? MiniCommentsSection(
                        post: widget.post,
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String changePerson(int num) {
    if (num <= 1) {
      return "person";
    } else {
      return "persons";
    }
  }
}

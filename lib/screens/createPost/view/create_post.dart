import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instant_gram/common/common.dart';
import 'package:instant_gram/core/utils.dart';
import 'package:instant_gram/models/models.dart';
import 'package:instant_gram/screens/home/controllers/user_post_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class CreatePost extends ConsumerStatefulWidget {
  final XFile media;
  final bool isVideo;

  const CreatePost({
    required this.media,
    required this.isVideo,
    super.key,
  });

  @override
  ConsumerState<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends ConsumerState<CreatePost> {
  VideoPlayerController? _videoPlayerController;
  late final TextEditingController _textEditingController;

  bool allowLikes = true;
  bool allowComments = true;

  String? thumbnail;

  @override
  void initState() {
    if (widget.isVideo) {
      _videoPlayerController = VideoPlayerController.file(
        File(widget.media.path),
      )..initialize().then((value) {
          setState(() {});
        });
    }
    _textEditingController = TextEditingController();
    super.initState();
    widget.isVideo ? generateThumbnail() : thumbnail = widget.media.path;
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
        title: const Text(
          'Create New Post',
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              UserPost post = UserPost(
                path: widget.media.path,
                description: _textEditingController.text,
                allowComments: allowComments,
                allowLikes: allowLikes,
                postDate: DateTime.now(),
                isVideo: widget.isVideo,
                thumbnail: thumbnail ?? '',
              );
              ref.read(userPostProvider.notifier).addPost(post);
              showSnackbar(context, "Post added successfully");
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.send,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MediaDisplay(
              path: widget.media.path,
              isVideo: widget.isVideo,
              videoPlayerController: _videoPlayerController,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _textEditingController,
                decoration: const InputDecoration(
                    labelText: 'Please write your message here',
                    labelStyle: TextStyle(
                      color: Colors.white54,
                    )),
              ),
            ),
            buildAllowListTile(
              value: allowLikes,
              onChanged: (value) {
                setState(() {
                  allowLikes = value;
                });
              },
              title: 'Allow likes',
              subtitle:
                  'By allowing likes, users will be able to press the like button on your post.',
            ),
            buildAllowListTile(
              value: allowComments,
              onChanged: (value) {
                setState(() {
                  allowComments = value;
                });
              },
              title: 'Allow comments',
              subtitle:
                  'By allowing comments, users will be able to comment on your post.',
            ),
          ],
        ),
      ),
    );
  }

  SwitchListTile buildAllowListTile({
    required bool value,
    required void Function(bool) onChanged,
    required String title,
    required String subtitle,
  }) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: Colors.white54,
        ),
      ),
    );
  }

  Future<void> generateThumbnail() async {
    final thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: widget.media.path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 100,
      quality: 20,
    );
    thumbnail = thumbnailPath;
  }
}

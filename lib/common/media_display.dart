import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MediaDisplay extends StatelessWidget {
  const MediaDisplay({
    super.key,
    VideoPlayerController? videoPlayerController,
    required this.isVideo,
    required this.path,
  }) : _videoPlayerController = videoPlayerController;

  final VideoPlayerController? _videoPlayerController;
  final bool isVideo;
  final String path;

  @override
  Widget build(BuildContext context) {
    if (isVideo && _videoPlayerController != null) {
      if (_videoPlayerController!.value.isInitialized) {
        return InkWell(
          onTap: () {
            if (_videoPlayerController!.value.isPlaying) {
              _videoPlayerController!.pause();
            } else {
              _videoPlayerController!.play();
            }
          },
          child: AspectRatio(
            aspectRatio: _videoPlayerController!.value.aspectRatio,
            child: VideoPlayer(
              _videoPlayerController!,
            ),
          ),
        );
      } else {
        return const Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator.adaptive());
      }
    } else {
      return AspectRatio(
          aspectRatio: 4 / 3,
          child: Image.file(File(path),
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded) {
              return child;
            } else {
              return AnimatedOpacity(
                opacity: frame == null ? 0 : 1,
                duration: const Duration(seconds: 1),
                curve: Curves.easeOut,
                child: child,
              );
            }
          }));
    }
  }
}

import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/post.dart';
import '../screens/auth/controller/auth_controller.dart';

class DeleteIcon extends ConsumerWidget {
  final Post post;
  final VoidCallback? onPressed;

  Future<User>? _details;

  DeleteIcon({
    super.key,
    required this.post,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _details ??= getUserDetail(ref, context);
    return FutureBuilder(
        future: getUserDetail(ref, context),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.data!.$id == post.userPost.user.$id) {
            return IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onPressed,
            );
          } else {
            return const SizedBox.shrink();
          }
        });
  }

  Future<User> getUserDetail(WidgetRef ref, BuildContext context) async {
    return ref.read(authControllerProvider.notifier).getUserDetails(context);
  }
}

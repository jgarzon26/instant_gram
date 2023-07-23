import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/post.dart';
import '../screens/auth/controller/auth_controller.dart';

class DeleteIcon extends ConsumerWidget {
  final Post post;
  final VoidCallback onPressed;

  const DeleteIcon({
    super.key,
    required this.post,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
        future: ref.watch(authControllerProvider.notifier).getUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.$id == post.uid) {
            return IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onPressed,
            );
          } else {
            return const SizedBox.shrink();
          }
        });
  }
}

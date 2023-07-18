import 'package:flutter/material.dart';
import 'package:instant_gram/models/models.dart';

class MiniCommentsSection extends StatelessWidget {
  const MiniCommentsSection({
    super.key,
    required this.comments,
  });

  final List<UserComment> comments;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: comments.map((comment) {
        return Column(
          children: [
            Row(
              children: [
                Text(
                  comment.userName,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 18,
                      ),
                ),
                const SizedBox(width: 8),
                Text(
                  comment.comment,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        );
      }).toList(),
    );
  }
}

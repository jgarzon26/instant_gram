import 'package:flutter/material.dart';
import 'package:instant_gram/models/models.dart';

class MiniCommentsSection extends StatelessWidget {
  const MiniCommentsSection({
    super.key,
    required this.context,
    required this.comments,
  });

  final BuildContext context;
  final List<UserComment> comments;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children:
          List.generate(comments.length <= 3 ? comments.length : 3, (index) {
        return Column(
          children: [
            Row(
              children: [
                Text(
                  comments[index].userName,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 18,
                      ),
                ),
                const SizedBox(width: 8),
                Text(
                  comments[index].comment,
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
      }),
    );
  }
}

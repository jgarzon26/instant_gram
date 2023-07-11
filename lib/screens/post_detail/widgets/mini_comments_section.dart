import 'package:flutter/material.dart';

class MiniCommentsSection extends StatelessWidget {
  const MiniCommentsSection({
    super.key,
    required this.context,
    required this.comments,
  });

  final BuildContext context;
  final List<String> comments;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(comments.length, (index) {
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
                  comments[index],
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
}

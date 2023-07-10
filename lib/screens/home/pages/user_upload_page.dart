import 'package:flutter/material.dart';
import 'package:instant_gram/sample_data.dart';
import 'package:instant_gram/screens/post_detail/view/post_detail.dart';

class UserUploadPage extends StatelessWidget {
  const UserUploadPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        mainAxisSpacing: 20,
        crossAxisSpacing: 10,
        crossAxisCount: 3,
        children: List.generate(1, (index) {
          return InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => PostDetail(
                          post: samplePost,
                          tag: "flower$index",
                        )),
              );
            },
            child: Hero(
              tag: "flower$index",
              child: Image.network(
                sampleUserPost.path,
                fit: BoxFit.cover,
              ),
            ),
          );
        }),
      ),
    );
  }
}

import 'package:instant_gram/models/models.dart';

final samplePost = Post(
  userPost: sampleUserPost,
  numberOfLikes: 0,
  comments: [
    "Wow!",
    "Nice!",
    "Cool!",
  ],
);

final sampleUserPost = UserPost(
  path:
      "https://cdn.britannica.com/84/73184-050-05ED59CB/Sunflower-field-Fargo-North-Dakota.jpg",
  description: "Flower",
  allowLikes: true,
  allowComments: true,
  postDate: DateTime.now(),
);

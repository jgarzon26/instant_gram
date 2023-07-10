class UserPost {
  final String path, description;
  final bool allowLikes, allowComments;
  final DateTime postDate;

  UserPost({
    required this.path,
    required this.description,
    required this.allowLikes,
    required this.allowComments,
    required this.postDate,
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instant_gram/screens/auth/controller/auth_controller.dart';
import 'package:instant_gram/screens/createPost/view/create_post.dart';

class HomeAppBar extends ConsumerWidget {
  final TabController tabController;
  final PageController pageController;
  final List<IconData> bottomIcons;

  const HomeAppBar({
    super.key,
    required this.tabController,
    required this.pageController,
    required this.bottomIcons,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Map<String, dynamic>> actionButtons = [
      {
        "icon": Icons.movie_creation_outlined,
        "onPressed": () {
          _getMediaFromGallery(false).then((value) {
            if (value != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreatePost(
                    media: value,
                    isVideo: true,
                  ),
                ),
              );
            }
          });
        },
      },
      {
        "icon": Icons.add_photo_alternate_outlined,
        "onPressed": () {
          _getMediaFromGallery(true).then((value) {
            if (value != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreatePost(
                    isVideo: false,
                    media: value,
                  ),
                ),
              );
            }
          });
        },
      },
      {
        "icon": Icons.logout_outlined,
        "onPressed": () {
          ref.read(authControllerProvider.notifier).logout(context);
        },
      }
    ];
    return AppBar(
      title: const Text('Instant-gram!'),
      actions: actionButtons
          .map((action) => buildActionButton(
                icon: Icon(action["icon"]),
                onPressed: action["onPressed"],
              ))
          .toList(),
      bottom: TabBar(
        controller: tabController,
        labelPadding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(
            color: Colors.white12,
            width: 4,
          ),
        ),
        onTap: (page) {
          pageController.animateToPage(
            page,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
        },
        tabs: bottomIcons
            .map((icon) => Icon(
                  icon,
                ))
            .toList(),
      ),
    );
  }

  IconButton buildActionButton({
    required Icon icon,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: icon,
    );
  }

  Future<XFile?> _getMediaFromGallery(bool isImage) async {
    const source = ImageSource.gallery;
    final media = isImage
        ? await ImagePicker().pickImage(source: source)
        : await ImagePicker().pickVideo(source: source);

    return media;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instant_gram/screens/home/controllers/all_posts_provider.dart';
import 'package:instant_gram/screens/home/controllers/user_post_provider.dart';
import 'package:instant_gram/screens/home/pages/pages.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> with TickerProviderStateMixin {
  final pageController = PageController();
  late final TabController tabController;

  final List<Map<String, dynamic>> actionButtons = [
    {
      "icon": Icons.movie_creation_outlined,
      "onPressed": () {},
    },
    {
      "icon": Icons.add_photo_alternate_outlined,
      "onPressed": () {},
    },
    {
      "icon": Icons.logout_outlined,
      "onPressed": () {},
    }
  ];

  final bottomIcons = [
    Icons.person,
    Icons.search,
    Icons.home,
  ];

  @override
  void initState() {
    tabController = TabController(
      length: bottomIcons.length,
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          tabController.animateTo(
            index,
            duration: const Duration(
              milliseconds: 100,
            ),
          );
        },
        children: [
          UserPostsPage(
            userPosts: ref.watch(userPostProvider),
          ),
          const SearchPage(),
          UserPostsPage(
            userPosts: ref.watch(allPostsProvider),
          ),
        ],
      ),
    );
  }

  IconButton buildActionButton(
      {required Icon icon, required VoidCallback onPressed}) {
    return IconButton(
      onPressed: onPressed,
      icon: icon,
    );
  }
}

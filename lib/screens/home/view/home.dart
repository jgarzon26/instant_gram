import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:instant_gram/core/utils.dart';
import 'package:instant_gram/screens/home/pages/pages.dart';
import 'package:instant_gram/screens/home/widgets/home_appbar.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> with TickerProviderStateMixin {
  final pageController = PageController();
  late final TabController tabController;

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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(
          kToolbarHeight * 2,
        ),
        child: HomeAppBar(
          tabController: tabController,
          pageController: pageController,
          bottomIcons: bottomIcons,
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
          dismissKeyboardOnLoseFocus(context);
        },
        children: const [
          UserPostsGridView(),
          SearchPage(),
          CommonPostsGridView(),
        ],
      ),
    );
  }
}

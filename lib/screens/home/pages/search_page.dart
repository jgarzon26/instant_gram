import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instant_gram/models/models.dart';
import 'package:instant_gram/screens/home/controllers/all_posts_provider.dart';
import 'package:instant_gram/screens/home/widgets/posts_grid_view.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({
    super.key,
  });

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final searchController = TextEditingController();

  List<Post> searchResults = [];

  @override
  void initState() {
    super.initState();
    searchController.addListener(() async {
      if (searchController.text.isEmpty) {
        setState(() {
          searchResults = [];
        });
      } else {
        List<Post> allPosts =
            await ref.read(allPostsProvider.notifier).getPosts();
        List<Post> posts = allPosts
            .where((post) => post.description
                .toLowerCase()
                .contains(searchController.text.toLowerCase()))
            .toList();
        setState(() {
          searchResults = posts;
        });
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(allPostsProvider);
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 15,
            ),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Enter your search term here",
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      searchController.clear();
                      searchResults.clear();
                    });
                  },
                  icon: const Icon(Icons.clear),
                ),
              ),
            ),
          ),
          !isLoading
              ? searchResults.isEmpty
                  ? buildEmptyResult(context)
                  : PostsGridView(
                      userPosts: searchResults,
                      shrinkWrap: true,
                    )
              : const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
        ],
      ),
    );
  }

  Widget buildEmptyResult(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 10,
      ),
      child: Column(
        children: [
          Text(
            "Enter your search term in order to go get started. You can search in the description of all posts available in the system",
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Colors.white38,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
          ),
          Image.asset(
            "assets/images/empty_search.png",
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    super.key,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final searchController = TextEditingController();

  var hasInput = false;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 15,
            ),
            child: TextField(
              onChanged: (text) {
                setState(() {
                  hasInput = text.isNotEmpty;
                });
              },
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Enter your search term here",
                suffixIcon: IconButton(
                  onPressed: () => searchController.clear(),
                  icon: const Icon(Icons.clear),
                ),
              ),
            ),
          ),
          !hasInput
              ? buildEmptyResult(context)
              : const Placeholder() //display search result,
        ],
      ),
    );
  }

  Padding buildEmptyResult(BuildContext context) {
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
          const SizedBox(height: 20),
          const Placeholder(),
        ],
      ),
    );
  }
}

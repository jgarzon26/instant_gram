import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instant-gram!'),
        actions: [
          buildActionButton(
            icon: const Icon(Icons.movie),
            onPressed: () {},
          ),
        ],
      ),
      body: const Center(
        child: Text('Home'),
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

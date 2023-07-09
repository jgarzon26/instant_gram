import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instant_gram/screens/screens.dart';
import 'package:instant_gram/theme/theme.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: kBackgroundColorLight,
      ),
    );
    return MaterialApp(
      theme: AppTheme.theme,
      home: const Login(),
      routes: {
        '/login': (context) => const Login(),
        '/home': (context) => const Home(),
      },
    );
  }
}

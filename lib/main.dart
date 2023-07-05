import 'package:flutter/material.dart';
import 'package:instant_gram/screens/screens.dart';
import 'package:instant_gram/theme/theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.theme,
      home: const Login(),
    );
  }
}

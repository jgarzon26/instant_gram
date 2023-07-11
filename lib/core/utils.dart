import 'package:flutter/material.dart';
import 'package:instant_gram/theme/theme.dart';

void showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: Theme.of(context).textTheme.bodyLarge),
      duration: const Duration(seconds: 1),
      backgroundColor: kBackgroundColorLight,
    ),
  );
}

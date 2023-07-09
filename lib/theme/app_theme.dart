import 'package:flutter/material.dart';
import 'package:instant_gram/theme/palette.dart';

class AppTheme {
  static ThemeData theme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: kBackgroundColor,
    appBarTheme: const AppBarTheme().copyWith(
      backgroundColor: kBackgroundColorLight,
      foregroundColor: kForegroundColor,
      titleTextStyle: const TextStyle().copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: kForegroundColor,
      ),
      elevation: 2,
    ),
    dividerTheme: const DividerThemeData().copyWith(
      color: Colors.white10,
      thickness: 1,
    ),
    textTheme: const TextTheme().copyWith(
      displayLarge: const TextStyle().copyWith(
        fontWeight: FontWeight.normal,
        fontSize: 45,
        color: kForegroundColor,
      ),
      titleSmall: const TextStyle().copyWith(
        fontWeight: FontWeight.normal,
        fontSize: 16,
        color: kForegroundColor,
      ),
      labelMedium: const TextStyle().copyWith(
        fontWeight: FontWeight.normal,
        fontSize: 14,
        color: kForegroundColor,
      ),
    ),
    buttonTheme: const ButtonThemeData().copyWith(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    ),
  );
}

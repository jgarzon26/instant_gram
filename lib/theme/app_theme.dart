import 'package:flutter/material.dart';
import 'package:instant_gram/theme/palette.dart';

class AppTheme {
  static ThemeData theme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: kBackgroundColor,
    appBarTheme: const AppBarTheme().copyWith(
      backgroundColor: kBackgroundColorLight,
      foregroundColor: kForegroundColor,
      titleTextStyle: const TextStyle().copyWith(
        fontWeight: FontWeight.normal,
        fontSize: 20,
        color: kForegroundColor,
      ),
      elevation: 2,
    ),
    dividerTheme: const DividerThemeData().copyWith(
      color: Colors.white24,
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
        fontSize: 22,
        color: kForegroundColor,
      ),
    ),
    buttonTheme: const ButtonThemeData().copyWith(
      buttonColor: kBackgroundColor,
      textTheme: ButtonTextTheme.normal,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    ),
  );
}

import 'package:flutter/material.dart';

import '../../resources/colors/custom_color_scheme.dart';
import '../colors/app_color_scheme.dart';
import 'app_text_theme.dart';

// ignore: avoid_classes_with_only_static_members
class AppTheme {
  static final ThemeData lightTheme = ThemeData.light().copyWith(
    appBarTheme: _appBarTheme(AppColorScheme.lightScheme),
    inputDecorationTheme: _inputDecorationTheme(AppColorScheme.lightScheme),
    scaffoldBackgroundColor: AppColorScheme.lightScheme.background,
    errorColor: AppColorScheme.lightScheme.error,
    colorScheme: AppColorScheme.lightScheme,
    textSelectionColor: AppColorScheme.lightScheme.secondaryVariant,
    textTheme: AppTextTheme.appTextTheme,
    cursorColor: AppColorScheme.lightScheme.onSecondary,
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    appBarTheme: _appBarTheme(AppColorScheme.darkScheme),
    inputDecorationTheme: _inputDecorationTheme(AppColorScheme.darkScheme),
    scaffoldBackgroundColor: AppColorScheme.darkScheme.background,
    errorColor: AppColorScheme.darkScheme.error,
    colorScheme: AppColorScheme.darkScheme,
    textSelectionColor: AppColorScheme.darkScheme.secondaryVariant,
    textTheme: AppTextTheme.appTextTheme,
    cursorColor: AppColorScheme.darkScheme.onSecondary,
  );

  static AppBarTheme _appBarTheme(ColorScheme colorScheme) => AppBarTheme(
        brightness: Brightness.light,
        centerTitle: true,
        elevation: 0,
        color: colorScheme.background,
      );

  static InputDecorationTheme _inputDecorationTheme(ColorScheme colorScheme) =>
      InputDecorationTheme(
        alignLabelWithHint: true,
        errorMaxLines: 2,
        labelStyle: TextStyle(color: colorScheme.boldShade),
        hintStyle: TextStyle(color: colorScheme.boldShade),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            width: 1.6,
            color: colorScheme.primary,
          ),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            width: 1.6,
            color: colorScheme.error,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colorScheme.lightShade)),
        disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colorScheme.lightShade)),
      );
}

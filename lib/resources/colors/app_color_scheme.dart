import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppColorScheme {
  static const Color _primary = AppColors.primary;
  static const Color _primaryVariant = Color(0xFF7493FF);
  //  backgroubd
  // static const Color _background = Color(0xFFFFFFFF);
  static const Color _background = Color(0xFFF6F4F4);
  static const Color _error = Color(0xFFFF5252);
  static const Color _black = Color(0xFF000000);
  static const Color _white = Color(0xFFFFFFFF);

  static const ColorScheme lightScheme = ColorScheme.light(
    primary: _primary,
    primaryVariant: _primaryVariant,
    background: _background,
    error: _error,
    onPrimary: _white,
    onSurface: _black,
    onBackground: _black,
    onError: _white,
  );

  static const ColorScheme darkScheme = ColorScheme.dark(
    primary: _primary,
    primaryVariant: _primaryVariant,
    background: _background,
    error: _error,
    onPrimary: _white,
    onSurface: _black,
    onBackground: _black,
    onError: _white,
  );
}

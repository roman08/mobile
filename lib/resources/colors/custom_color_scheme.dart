import 'package:flutter/material.dart';

/*
    To use these colors you need to import this class:
    import '../../../resources/colors/custom_color_scheme.dart';
*/
extension CustomColorScheme on ColorScheme {
  Color get primary => const Color(0xFF0D42FB);

  Color get primaryLight => const Color(0xFF7493FF);

  Color get primaryExtraLight => const Color(0xFFEEF2FF);

  Color get success => const Color(0xFF7CDF8B);

  Color get warning => const Color(0xFFFF8941);

  Color get primaryText => const Color(0xFF333333);

  Color get boldShade => const Color(0xFF999999);

  Color get midShade => const Color(0xFF989797);

  Color get lightShade => const Color(0xFFE0E0E0);

  Color get extraLightShade => const Color(0xFFEEEEEE);

  Color get thinShade => const Color(0xFFF6F6F6);

  Color get backgroundTwos => const Color(0xFFE7E7E7);

  Color get fontColor => const Color(0XFF000000);

  Color get backgroundAlert => const Color(0XFFA583D1);
}

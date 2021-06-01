import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../colors/app_color_scheme.dart';
import '../fonts/app_fonts.dart';

const TextStyle _baseTextStyle = TextStyle(
  fontFamily: AppFonts.HELVETICA_NEUE,
  fontStyle: FontStyle.normal,
);

TextStyle _w400 = _baseTextStyle.copyWith(
  fontWeight: FontWeight.w400,
);

TextStyle _w600 = _baseTextStyle.copyWith(
  fontWeight: FontWeight.w600,
);

/// TODO(Dmitry Kuzhelko): Visual appearance of text does not match the Figma when using letter spacing in 3%, need to investigate problem. Tmp set in 0%
const double _letterSpacing = 0;
const double _height130 = 1.3;
const double _height150 = 1.5;

// ignore: avoid_classes_with_only_static_members
class AppTextTheme {
  static TextTheme appTextTheme = TextTheme(
    /// Figma name - 30r
    headline1: _w400.copyWith(
      fontSize: 30.ssp,
      height: _height130,
      letterSpacing: _letterSpacing,
    ),

    ///  28r
    headline2: _w400.copyWith(
      fontSize: 28.ssp,
      height: _height130,
      letterSpacing: _letterSpacing,
    ),

    ///  24r
    headline3: _w400.copyWith(
      fontSize: 24.ssp,
      height: _height130,
      letterSpacing: _letterSpacing,
    ),

    ///  20r
    headline4: _w400.copyWith(
      fontSize: 20.ssp,
      height: _height150,
      letterSpacing: _letterSpacing,
    ),

    ///  16r
    headline5: _w400.copyWith(
      fontSize: 16.ssp,
      height: _height150,
      letterSpacing: _letterSpacing,
    ),

    ///  14r
    headline6: _w400.copyWith(
      fontSize: 14.ssp,
      height: _height150,
      letterSpacing: _letterSpacing,
    ),

    /// 12r
    bodyText1: _w400.copyWith(
      fontSize: 12.ssp,
      height: _height150,
      letterSpacing: _letterSpacing,
    ),

    /// Style for button widget
    button: _w400.copyWith(
      fontSize: 16.ssp,
    ),

    /// Style for TextFormField widget
    subtitle1: _w400.copyWith(
      fontSize: 16.ssp,
      color: AppColorScheme.lightScheme.onSecondary,
    ),
  );
}

/*
    To use these styles you need to import this class:
    import '../../resources/themes/app_text_theme.dart';
 */
extension CustomTextStyles on TextTheme {
  /// Figma name - 30m
  TextStyle get headline1Bold => Get.textTheme.headline1.merge(_w600);

  /// 28m
  TextStyle get headline2Bold => Get.textTheme.headline2.merge(_w600);

  /// 24m
  TextStyle get headline3Bold => Get.textTheme.headline3.merge(_w600);

  /// 20m
  TextStyle get headline4Bold => Get.textTheme.headline4.merge(_w600);

  /// 16m
  TextStyle get headline5Bold => Get.textTheme.headline5.merge(_w600);

  /// 14m
  TextStyle get headline6Bold => Get.textTheme.headline6.merge(_w600);
}

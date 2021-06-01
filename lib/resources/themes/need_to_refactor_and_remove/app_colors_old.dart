import 'package:flutter/material.dart';

class AppColorsOld {
  final Color primaryBlue;
  final Color darkShade;
  final Color boldShade;
  final Color midShade;
  final Color lightShade;
  final Color extraLightShade;
  final Color thinShade;
  final Color white;
  final Color green;
  final Color red;
  final Color brackgroundGeneral;
  final Color brackgroundIcons;
  final Color textColor;

  AppColorsOld({
    this.primaryBlue,
    this.darkShade,
    this.boldShade,
    this.midShade,
    this.lightShade,
    this.extraLightShade,
    this.thinShade,
    this.white,
    this.green,
    this.red,
    this.brackgroundGeneral,
    this.brackgroundIcons,
    this.textColor,
  });

  factory AppColorsOld.defaultColors() => _defaultColors();
}

AppColorsOld _defaultColors() {
  return AppColorsOld(
    // primaryBlue: const Color(0xFF0D42FB),
    primaryBlue: const Color(0xFF4919A8),
    green: const Color(0xFF17D970),
    darkShade: const Color(0xFF333333),
    boldShade: const Color(0xFF8098A3),
    midShade: const Color(0xFFDCE4FF),
    lightShade: const Color(0xFFD6E6EC),
    extraLightShade: const Color(0xFFEEF2FE),
    thinShade: const Color(0xFFF9FBFD),
    white: Colors.white,
    red: Colors.red,
    brackgroundGeneral: const Color(0xFFF6F4F4),
    brackgroundIcons: const Color(0xFFD1AC00),
    textColor: const Color(0xFF989797)
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../fonts/app_fonts.dart';

class AppTextStylesOld {
  final TextStyle m10; // Regular
  final TextStyle m12; // Regular
  final TextStyle sm12; // Regular
  final TextStyle m14; // Regular
  final TextStyle m16; // Regular
  final TextStyle m18; // Regular
  final TextStyle m20; // Regular
  final TextStyle m24; // Regular
  final TextStyle m28; // Regular
  final TextStyle m30; // Regular
  final TextStyle r10; // Regular
  final TextStyle sr12; // Regular
  final TextStyle r12; // Regular
  final TextStyle r14; // Regular
  final TextStyle r16; // Regular
  final TextStyle r20; // Regular
  final TextStyle r24; // Regular
  final TextStyle r32; // Regular

  AppTextStylesOld(
      {this.m10,
      this.m12,
      this.sm12,
      this.m14,
      this.m16,
      this.m18,
      this.m20,
      this.m24,
      this.m28,
      this.m30,
      this.r10,
      this.sr12,
      this.r12,
      this.r14,
      this.r16,
      this.r20,
      this.r24,
      this.r32});

  factory AppTextStylesOld.defaultTextStyles() {
    final defaultTextStyle = TextStyle(
      fontSize: 10.ssp,
      fontFamily: AppFonts.HELVETICA_NEUE,
      fontWeight: FontWeight.normal,
      letterSpacing: 0,
    );

    return AppTextStylesOld(
      // Figma styles
      m10: defaultTextStyle.copyWith(
        fontSize: 10.ssp,
        height: 1.1,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
      ),
      m12: defaultTextStyle.copyWith(
        fontSize: 12.ssp,
        //height: 1.5,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
      ),
      sm12: defaultTextStyle.copyWith(
        fontSize: 12.ssp,
        height: 1,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
      ),
      m14: defaultTextStyle.copyWith(
        fontSize: 14.ssp,
        height: 1.5,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
      ),
      m16: defaultTextStyle.copyWith(
        fontSize: 16.ssp,
        //height: 1.5,

        fontWeight: FontWeight.w500,
        letterSpacing: 0,
      ),
      m18: defaultTextStyle.copyWith(
        fontSize: 18.ssp,
        height: 1.5,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
      ),
      m20: defaultTextStyle.copyWith(
        fontSize: 20.ssp,
        height: 1.3,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
      ),
      m24: defaultTextStyle.copyWith(
        fontSize: 24.ssp,
        height: 1.3,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
      ),
      m28: defaultTextStyle.copyWith(
        fontSize: 28.ssp,
        height: 1.3,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
      ),
      m30: defaultTextStyle.copyWith(
        fontSize: 30.ssp,
        height: 1.3,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
      ),
      r10: defaultTextStyle.copyWith(
        fontSize: 10.ssp,
        height: 1.5,
        letterSpacing: 0,
      ),
      sr12: defaultTextStyle.copyWith(
        fontSize: 12.ssp,
        height: 1.1,
        letterSpacing: 0,
      ),
      r12: defaultTextStyle.copyWith(
        fontSize: 12.ssp,
        height: 1.5,
        letterSpacing: 0,
      ),
      r14: defaultTextStyle.copyWith(
        fontSize: 14.ssp,
        height: 1.5,
        letterSpacing: 0,
      ),
      r16: defaultTextStyle.copyWith(
        fontSize: 16.ssp,
        height: 1.5,
        letterSpacing: 0,
      ),
      r20: defaultTextStyle.copyWith(
        fontSize: 20.ssp,
        height: 1.3,
        letterSpacing: 0,
      ),
      r24: defaultTextStyle.copyWith(
        fontSize: 24.ssp,
        height: 1.3,
        letterSpacing: 0,
      ),
      r32: defaultTextStyle.copyWith(
        fontSize: 32.ssp,
        height: 1.3,
        letterSpacing: 0,
      ),
    );
  }
}

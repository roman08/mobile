import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../resources/colors/custom_color_scheme.dart';
import '../../resources/icons/icons_svg.dart';
import '../../resources/strings/app_strings.dart';
import '../../resources/themes/app_text_theme.dart';
import 'app_buttons/button.dart';

class SuccessScreen extends StatelessWidget {
  final String title;
  final String body;
  final Function onButtonPressed;
  final bool canBack;

  const SuccessScreen({
    @required this.title,
    @required this.body,
    @required this.onButtonPressed,
    this.canBack,
  })  : assert(title != null),
        assert(body != null),
        assert(onButtonPressed != null);

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async => canBack ?? true,
        child: Scaffold(
          body: SafeArea(
            minimum: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const SizedBox(),
                SizedBox(
                  width: Get.width * 0.65,
                  child: Column(
                    children: <Widget>[
                      _checkIcon(context),
                      SizedBox(height: 32.h),
                      if (title != null)
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: Get.textTheme.headline3Bold.copyWith(
                              color: Get.theme.colorScheme.onSecondary),
                        ),
                      if (title != null) SizedBox(height: 8.h),
                      Text(
                        body,
                        textAlign: TextAlign.center,
                        style: Get.textTheme.headline5.copyWith(
                          color: Get.theme.colorScheme.boldShade,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Button(
                  title: AppStrings.DONE.tr(),
                  onPressed: onButtonPressed,
                ),
              ],
            ),
          ),
        ),
      );

  Widget _checkIcon(BuildContext context) => Container(
        width: 100.w,
        height: 100.w,
        decoration: BoxDecoration(
          color: Get.theme.colorScheme.primaryVariant,
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(34.0.w, 31.5.w, 34.0.w, 31.5.w),
          child: SvgPicture.asset(
            IconsSVG.checkUser,
            color: Get.theme.colorScheme.onPrimary,
          ),
        ),
      );
}

import 'package:Velmie/resources/strings/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';

class PageTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        AppStrings.SIGN_IN.tr(),
        textAlign: TextAlign.start,
        style: Get.textTheme.headline2.copyWith(
          color: Get.theme.colorScheme.onBackground,
          fontWeight: FontWeight.bold,
          fontSize: 30.0,
        ),
      ),
    );
  }
}

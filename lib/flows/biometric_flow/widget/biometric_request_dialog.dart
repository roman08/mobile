import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

import '../../../common/widgets/app_buttons/button.dart';
import '../../../common/widgets/app_buttons/flat_button.dart';
import '../../../resources/colors/custom_color_scheme.dart';
import '../../../resources/strings/app_strings.dart';
import '../../../resources/themes/app_text_theme.dart';
import '../biometric_screen.dart';

class BiometricRequestDialog extends StatelessWidget {
  final List<BiometricType> biometricMethods;
  final GestureTapCallback onTap;
  final bool isSignUp;

  const BiometricRequestDialog({
    Key key,
    this.biometricMethods,
    this.onTap,
    this.isSignUp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 30.h),
        decoration: BoxDecoration(
            color: Get.theme.colorScheme.onPrimary,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0.w),
              topRight: Radius.circular(30.0.w),
            )),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
                height: 4.h,
                width: 40.w,
                decoration: BoxDecoration(
                  
                    color: Get.theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16.w))),
            SizedBox(height: 24.h),
            Text(
              BiometricStrings.ADDITIONAL_SECURITY.tr(),
              style: Get.theme.textTheme.headline4Bold.copyWith(
                color: Get.theme.colorScheme.onBackground,
                fontWeight: FontWeight.w700,
                fontSize: 30.0
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              BiometricStrings.CONNECT_DISCRIPTION.tr(),
              textAlign: TextAlign.center,
              style: Get.theme.textTheme.headline5.copyWith(
                color: Get.theme.colorScheme.boldShade,
              ),
            ),
            SizedBox(height: 21.h),
            if (biometricMethods.contains(BiometricType.face))
              Padding(
                  padding: EdgeInsets.only(
                    bottom: biometricMethods.contains(BiometricType.fingerprint)
                        ? 14.h
                        : 0,
                  ),
                  child: Button(
                    title: BiometricStrings.USE_FACE_ID.tr(),
                    color: Get.theme.colorScheme.primary,
                    onPressed: () => {
                      Get.to(
                        BiometricScreen(
                          type: BiometricType.face,
                          isSignUp: isSignUp,
                        ),
                      ),
                    },
                  )),
            if (biometricMethods.contains(BiometricType.fingerprint))
              Button(
                title: BiometricStrings.USE_TOUCH_ID.tr(),
                onPressed: () => {
                  Get.to(BiometricScreen(
                    type: BiometricType.fingerprint,
                    isSignUp: isSignUp,
                  )),
                },
              ),
            SizedBox(height: 14.h),
            AppFlatButton(
              text: AppStrings.SKIP.tr(),
              textColor: Get.theme.colorScheme.onBackground,
              onPressed: () => onTap.call(),
            )
          ],
        ),
      ),
    );
  }
}

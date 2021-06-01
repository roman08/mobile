import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

import '../../common/widgets/app_bars/app_bar_with_left_button.dart';
import '../../common/widgets/app_buttons/button.dart';
import '../../common/widgets/success_screen.dart';
import '../../resources/colors/custom_color_scheme.dart';
import '../../resources/icons/icons_svg.dart';
import '../../resources/strings/app_strings.dart';
import '../../resources/themes/app_text_theme.dart';
import '../dashboard_flow/dashboard_flow.dart';
import 'cubit/biometric_cubit.dart';

// ignore: must_be_immutable
class BiometricScreen extends StatelessWidget {
  LocalAuthentication localAuth = LocalAuthentication();
  final BiometricType type;
  final bool isSignUp;

  BiometricScreen({
    Key key,
    @required this.type,
    @required this.isSignUp,
  }) : super(key: key);

  Widget _appBar(BuildContext context) {
    return AppBarWithLeftButton(
      backgroundColor: Get.theme.colorScheme.background,
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: CupertinoButton(
          child: Text(
            AppStrings.CANCEL.tr(),
            style: Get.textTheme.headline5
                .copyWith(color: Get.theme.colorScheme.primary),
          ),
          onPressed: () => Get.back()),
      title: Text(
        (type == BiometricType.face
                ? BiometricStrings.USE_FACE_ID
                : BiometricStrings.USE_TOUCH_ID)
            .tr(),
        style: Get.textTheme.headline4Bold.copyWith(
          color: Get.theme.colorScheme.onBackground,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: _appBar(context),
        body: SafeArea(
          minimum: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: <Widget>[
              Expanded(child: _image()),
              _title(),
              SizedBox(height: 8.h),
              _subTitle(),
              SizedBox(height: 32.h),
              _button(context),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      );

  Widget _image() => Container(
        child: Center(
          child: Container(
            width: 180.w,
            height: 180.w,
            decoration: BoxDecoration(
              color: Get.theme.colorScheme.backgroundTwos,
              borderRadius: BorderRadius.circular(90.w),
            ),
            child: Center(
              child: SvgPicture.asset(
                type == BiometricType.face ? IconsSVG.faceId : IconsSVG.touchId,
                color: Get.theme.colorScheme.primary,
              ),
            ),
          ),
        ),
      );

  Widget _title() => Text(
        BiometricStrings.HOW_IT_WORKS.tr(),
        style: Get.textTheme.headline2Bold.copyWith(
          color: Colors.black,
        ),
      );

  Widget _subTitle() => Text(
        type == BiometricType.face
            ? BiometricStrings.BIOMETRIC_FACE_ID_MESSAGE.tr()
            : BiometricStrings.BIOMETRIC_TOUCH_ID_MESSAGE.tr(),
        textAlign: TextAlign.center,
        style: Get.textTheme.headline5
            .copyWith(
              color: Get.theme.colorScheme.fontColor),
      );

  Widget _button(BuildContext context) => Button(
        title: BiometricStrings.BIOMETRIC_CONNECT.tr(),
        onPressed: () async {
          final bool didAuthenticate =
              await localAuth.authenticateWithBiometrics(
            localizedReason: type == BiometricType.face
                ? BiometricStrings.BIOMETRIC_FACE__ID_ALERT.tr()
                : BiometricStrings.BIOMETRIC_TOUCH_ID_ALERT.tr(),
          );

          if (didAuthenticate) {
            context.read<BiometricCubit>().enabledEvent(type);
            if (isSignUp) {
              Get.to(SuccessScreen(
                title: AppStrings.SUCCESS.tr(),
                body: AppStrings.ACCOUNT_CREATED.tr(),
                onButtonPressed: () => Get.offAll(DashboardFlow()),
                canBack: false,
              ));
            } else {
              Get.offAll(DashboardFlow());
            }
          }
        },
      );
}

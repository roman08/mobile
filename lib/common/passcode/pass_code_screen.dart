import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../flows/biometric_flow/cubit/biometric_cubit.dart';
import '../../flows/biometric_flow/widget/biometric_request_dialog.dart';
import '../../flows/dashboard_flow/dashboard_flow.dart';
import '../../resources/icons/icons_svg.dart';
import '../../resources/strings/app_strings.dart';
import '../session/cubit/session_cubit.dart';
import '../session/session_repository.dart';
import '../widgets/app_bars/base_app_bar.dart';
import '../widgets/info_widgets.dart';
import '../widgets/success_screen.dart';
import 'cubit/pin_code_cubit.dart';
import 'passcode_widget/pass_code_widget.dart';

const _max_attempts = 3;

class PassCodeScreen extends StatelessWidget {
  const PassCodeScreen({this.status = PassCodeStatus.signInVerification});

  final PassCodeStatus status;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: _appBar(),
        body: SafeArea(
          child: BlocProvider<PinCodeCubit>(
            create: (BuildContext context) => PinCodeCubit(context.repository<SessionRepository>()),
            child: PassCodeWidget(
              status: status,
              passCodeCallback: (value, failedAttempts) {
                if (value == true) {
                  switch (status) {
                    case PassCodeStatus.signInCreate:
                      context.read<SessionCubit>().sessionVerificationSuccessEvent();
                      showBiometricChoosePopup(
                        context,
                        () {
                          context.read<BiometricCubit>().biometricSkipEvent(true);
                          Get.offAll(DashboardFlow());
                        },
                        false,
                      );
                      break;
                    case PassCodeStatus.signUpCreate:
                      showBiometricChoosePopup(
                        context,
                        () {
                          context.read<BiometricCubit>().biometricSkipEvent(false);
                          Get.to(SuccessScreen(
                            title: AppStrings.SUCCESS.tr(),
                            body: AppStrings.ACCOUNT_CREATED.tr(),
                            onButtonPressed: () => Get.offAll(DashboardFlow()),
                            canBack: false,
                          ));
                        },
                        true,
                      );
                      break;
                    case PassCodeStatus.signInVerification:
                      context.read<SessionCubit>().sessionVerificationSuccessEvent();
                      Get.offAll(DashboardFlow());
                      break;
                    case PassCodeStatus.verification:
                      context.read<SessionCubit>().sessionVerificationSuccessEvent();
                      Get.back();
                      break;
                    case PassCodeStatus.change:
                      Get.back();
                      break;
                  }
                } else {
                  if (status == PassCodeStatus.verification || status == PassCodeStatus.signInVerification) {
                    if (failedAttempts >= _max_attempts) {
                      context.read<SessionCubit>().logout();
                    } else {
                      showAlertDialog(
                        context,
                        title: AppStrings.PASS_CODE_FAIL.tr(),
                        description: "${AppStrings.NUMBER_ATTEMPTS.tr()} ${_max_attempts - failedAttempts}",
                        onPress: () => Get.back(),
                      );
                    }
                  }
                }
              },
            ),
          ),
        ),
      ),
      onWillPop: () async => status == PassCodeStatus.change,
    );
  }

  BaseAppBar _appBar() => BaseAppBar(
        backIconPath: IconsSVG.cross,
        isShowBack: status == PassCodeStatus.change,
      );

  void showBiometricChoosePopup(BuildContext context, GestureTapCallback onTap, bool isSignUp) async {
    final biometricMethods = await LocalAuthentication().getAvailableBiometrics();
    if (biometricMethods.isEmpty) {
      onTap();
    } else {
      showMaterialModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        enableDrag: false,
        isDismissible: false,
        builder: (context, scrollController) => BiometricRequestDialog(
          biometricMethods: biometricMethods,
          onTap: onTap,
          isSignUp: isSignUp,
        ),
      );
    }
  }
}

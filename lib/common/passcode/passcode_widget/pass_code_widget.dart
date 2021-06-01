import 'package:Velmie/resources/colors/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../resources/colors/custom_color_scheme.dart';
import '../../../resources/icons/icons_svg.dart';
import '../../../resources/strings/app_strings.dart';
import '../../session/cubit/session_cubit.dart';
import '../cubit/pin_code_cubit.dart';
import '../cubit/pin_code_state.dart';
import 'keyboard.dart';
import 'pass_code_circles.dart';

typedef PassCodeCallback = Function(bool status, int failedAttempts);

enum PassCodeStatus { signInCreate, signUpCreate, signInVerification, verification, change }

class PassCodeWidget extends StatelessWidget {
  const PassCodeWidget({
    @required this.status,
    @required this.passCodeCallback,
  });

  final PassCodeStatus status;
  final PassCodeCallback passCodeCallback;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PinCodeCubit, PinCodeState>(
      listener: (context, state) {
        if (state.length == 6) {
          if (state is PinCodeResultState) {
            if (state.isFinish) {
              Future.delayed(const Duration(milliseconds: 500)).then(
                (value) => passCodeCallback(state.isSuccess, state.failedAttempts),
              );
            }
            if (!state.isSuccess) {
              Future.delayed(const Duration(milliseconds: 700)).then(
                (value) => context.read<PinCodeCubit>().pinCodeResetEvent(),
              );
            }
          } else {
            if (_isCreating() && state.isRepeat != true) {
              context.read<PinCodeCubit>().pinCodeNextStepEvent();
              return;
            } else if (status == PassCodeStatus.change) {
              if (state.isRepeat == null) {
                context.read<PinCodeCubit>().compareOldPin();
                return;
              } else if (state.isRepeat == false) {
                context.read<PinCodeCubit>().pinCodeNextStepEvent();
                return;
              } else {
                context.read<PinCodeCubit>().compareAfterChangedPin();
                return;
              }
            } else {
              context.read<PinCodeCubit>().comparePin();
              return;
            }
          }
        }
      },
      buildWhen: (previous, current) {
        return current.length <= 6;
      },
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Text(
                    getTitle(state).tr(),
                    style: Get.textTheme.headline5.copyWith(
                      color: Get.theme.colorScheme.onBackground,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 32.h),
                PassCodeCircles(
                  circleUIConfig: CircleUIConfig(
                    borderWidth: 0,
                    fillColor: getCircleColor(state),
                    circleSize: 20.h,
                    circleSpacing: 22.h,
                  ),
                  filledCount: state.length,
                ),
              ],
            ),
            SizedBox(height: 120.h),
            Center(
              child: Keyboard(
                isShowsRightWidget: state.length != 0,
                isShowsLeftWidget: !(status == PassCodeStatus.signInCreate ||
                    status == PassCodeStatus.signUpCreate ||
                    status == PassCodeStatus.change),
                keyboardUIConfig: KeyboardUIConfig(
                    digitFillColor: AppColors.backgroundTwo,
                    digitTextStyle: Get.textTheme.headline1.copyWith(
                      color: Get.theme.colorScheme.onBackground,
                    ),
                    primaryColor: Get.theme.colorScheme.extraLightShade),
                leftWidget: Center(
                  child: Text(
                    AppStrings.LOGOUT.tr(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Get.textTheme.headline5.copyWith(color: AppColors.primary),
                    textAlign: TextAlign.center,
                  ),
                ),
                rightWidget: Center(
                  child: 
                  SvgPicture.asset(IconsSVG.deleteIcon, color: AppColors.backgroundTwo,),
                ),
                onLeftWidgetTap: () {
                  context.read<SessionCubit>().logout();
                },
                onRightWidgetTap: () {
                  if (state.length >= 0) {
                    context.read<PinCodeCubit>().deleteNumber();
                  }
                },
                onKeyboardTap: (String text) {
                  if (state.length < 6) {
                    context.read<PinCodeCubit>().addNumber(text);
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }

  bool _isCreating() {
    return status == PassCodeStatus.signInCreate || status == PassCodeStatus.signUpCreate;
  }

  Color getCircleColor(PinCodeState state) {
    if (state is PinCodeResultState) {
      if (state.isSuccess) {
        return Get.theme.colorScheme.success;
      } else {
        return Get.theme.colorScheme.error;
      }
    } else {
      return Get.theme.colorScheme.primary;
    }
  }

  String getTitle(PinCodeState state) {
    if (_isCreating()) {
      if (state.isRepeat ?? false) {
        return AppStrings.REPEAT_PASS_CODE;
      } else {
        return AppStrings.CREATE_PASSCODE;
      }
    } else if (status == PassCodeStatus.change) {
      if (state.isRepeat == null) {
        return AppStrings.OLD_PASSCODE;
      } else {
        if (state.isRepeat) {
          return AppStrings.REPEAT_NEW_PASSCODE;
        } else {
          return AppStrings.NEW_PASSCODE;
        }
      }
    } else {
      return AppStrings.ENTER_PASSCODE;
    }
  }
}

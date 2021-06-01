import 'package:Velmie/common/repository/user_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../common/utils/validator.dart';
import '../../../../../common/widgets/app_bars/base_app_bar.dart';
import '../../../../../common/widgets/app_buttons/button.dart';
import '../../../../../common/widgets/info_widgets.dart';
import '../../../../../common/widgets/loader/progress_loader.dart';
import '../../../../../resources/colors/custom_color_scheme.dart';
import '../../../../../resources/icons/icons_svg.dart';
import '../../../../../resources/strings/app_strings.dart';
import '../../../../../resources/themes/need_to_refactor_and_remove/app_colors_old.dart';
import '../../../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';
import 'cubit/change_password_cubit.dart';
import 'cubit/change_password_state.dart';

class _ChangePasswordScreenStyle {
  final TextStyle titleTextStyle;
  final TextStyle descriptionTextButton;
  final AppColorsOld colors;

  _ChangePasswordScreenStyle({
    this.titleTextStyle,
    this.descriptionTextButton,
    this.colors,
  });

  factory _ChangePasswordScreenStyle.fromOldTheme(AppThemeOld theme) {
    return _ChangePasswordScreenStyle(
      titleTextStyle:
          theme.textStyles.m28.copyWith(color: theme.colors.darkShade),
      descriptionTextButton:
          theme.textStyles.r16.copyWith(color: theme.colors.boldShade),
      colors: theme.colors,
    );
  }
}

class ChangePasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appBar = _appBar();
    return Scaffold(
      appBar: _appBar(),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          child: SingleChildScrollView(
            child: SizedBox(
              height: ScreenUtil.screenHeight -
                  ScreenUtil.statusBarHeight -
                  appBar.preferredSize.height,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 40.h, 16.2, 16.h),
                child: BlocProvider(
                  create: (BuildContext context) => ChangePasswordCubit(
                    context.repository<Validator>(),
                    context.repository<UserRepository>(),
                  ),
                  child: ChangePasswordWidget(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  BaseAppBar _appBar() => const BaseAppBar(
        backIconPath: IconsSVG.cross,
      );
}

class ChangePasswordWidget extends StatelessWidget {
  final _ChangePasswordScreenStyle _style =
      _ChangePasswordScreenStyle.fromOldTheme(AppThemeOld.defaultTheme());

  final _oldPassWordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
      listener: (BuildContext context, ChangePasswordState state) {
        if (state is ChangePasswordChangedState) {
          showAlertDialog(context,
              title: AppStrings.SUCCESS.tr(),
              description: AppStrings.PASSWORD_HAS_BEEN_CHANGED.tr(),
              onPress: () => Get.close(2));
        }
        if (state is ChangePasswordErrorState) {
          showAlertDialog(context,
              title: AppStrings.ERROR.tr(),
              description: state.error,
              onPress: () => Get.close(2));
        }
      },
      buildWhen: (previous, current) {
        return current is ChangePasswordLoadingState ||
            current is ChangePasswordChangedState ||
            current is ChangePasswordErrorState;
      },
      builder: (_, state) {
        if (state is ChangePasswordLoadingState) {
          return progressLoader();
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                AppStrings.CHANGE_PASSWORD.tr(),
                style: _style.titleTextStyle,
              ),
              Padding(
                padding: EdgeInsets.only(top: 16.h),
                child: Text(
                  AppStrings.CHANGE_PASSWORD_DESCRIPTION.tr(),
                  style: _style.descriptionTextButton,
                ),
              ),
              BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
                buildWhen: (previousState, state) {
                  return !(state is ChangePasswordNewErrorState) &&
                      !(state is ChangePasswordConfirmErrorState);
                },
                builder: (context, state) {
                  return Padding(
                    padding: EdgeInsets.only(top: 39.h),
                    child: _textForm(
                      context: context,
                      controller: _oldPassWordController,
                      label: AppStrings.OLD_PASSWORD.tr(),
                      errorText: (state is ChangePasswordOldErrorState)
                          ? state.error.tr()
                          : null,
                      isVisible: state.isOldVisible,
                      onTap: () => context
                          .read<ChangePasswordCubit>()
                          .changePasswordOldVisibilityEvent(
                            isVisible: !state.isOldVisible,
                          ),
                    ),
                  );
                },
              ),
              BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
                buildWhen: (previousState, state) {
                  return !(state is ChangePasswordOldErrorState) &&
                      !(state is ChangePasswordConfirmErrorState);
                },
                builder: (context, state) {
                  return Padding(
                    padding: EdgeInsets.only(top: 30.h),
                    child: _textForm(
                      context: context,
                      controller: _newPasswordController,
                      label: AppStrings.NEW_PASSWORD.tr(),
                      errorText: (state is ChangePasswordNewErrorState)
                          ? state.error.tr()
                          : null,
                      isVisible: state.isNewVisible,
                      onTap: () => context
                          .read<ChangePasswordCubit>()
                          .changePasswordNewVisibilityEvent(
                              isVisible: !state.isNewVisible),
                    ),
                  );
                },
              ),
              BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
                buildWhen: (previousState, state) {
                  return !(state is ChangePasswordConfirmErrorState);
                },
                builder: (context, state) {
                  return Padding(
                    padding: EdgeInsets.only(top: 30.h),
                    child: _textForm(
                      context: context,
                      controller: _confirmNewPasswordController,
                      label: AppStrings.CONFIRM_NEW_PASSWORD.tr(),
                      errorText: (state is ChangePasswordConfirmErrorState)
                          ? state.error.tr()
                          : null,
                      isVisible: state.isConfirmVisible,
                      onTap: () => context
                          .read<ChangePasswordCubit>()
                          .changePasswordConfirmVisibilityEvent(
                            isVisible: !state.isConfirmVisible,
                          ),
                    ),
                  );
                },
              ),
              const Spacer(),
              Button(
                onPressed: () {
                  context.read<ChangePasswordCubit>().changePasswordEvent(
                        oldPassword: _oldPassWordController.text,
                        newPassword: _newPasswordController.text,
                        confirmPassword: _confirmNewPasswordController.text,
                      );
                },
                title: AppStrings.SUBMIT.tr(),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _textForm({
    BuildContext context,
    TextEditingController controller,
    String label,
    String errorText,
    GestureTapCallback onTap,
    bool isVisible,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
          errorText: errorText,
          suffixIcon: IconButton(
            padding: const EdgeInsets.symmetric(vertical: 0),
            alignment: Alignment.bottomRight,
            icon: SvgPicture.asset(isVisible ? IconsSVG.eye : IconsSVG.eyeOff,
                color: Get.theme.colorScheme.midShade,
                height: 30.h,
                width: 30.w),
            onPressed: onTap,
          ),
          labelText: label),
    );
  }
}

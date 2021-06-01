import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../common/session/cubit/session_cubit.dart';
import '../../../../common/widgets/info_widgets.dart';
import '../../../../resources/icons/icons_svg.dart';
import '../../../../resources/strings/app_strings.dart';
import '../../../../resources/themes/need_to_refactor_and_remove/app_colors_old.dart';
import '../../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';
import '../../../forgot_password_flow/screens/forgot_password_screen.dart';
import '../../../kyc_flow/index.dart';

class _MoreScreenStyle {
  final TextStyle titleTextStyle;
  final TextStyle itemTitleStyle;
  final TextStyle itemTitleRedStyle;
  final TextStyle itemSubtitleStyle;
  final TextStyle usernameInitialsStyle;
  final AppColorsOld colors;

  _MoreScreenStyle({
    this.titleTextStyle,
    this.itemTitleStyle,
    this.itemTitleRedStyle,
    this.itemSubtitleStyle,
    this.usernameInitialsStyle,
    this.colors,
  });

  factory _MoreScreenStyle.fromOldTheme(AppThemeOld theme) {
    return _MoreScreenStyle(
      titleTextStyle: theme.textStyles.m24.copyWith(color: Get.theme.colorScheme.onBackground),
      itemTitleStyle: theme.textStyles.r16.copyWith(color: theme.colors.darkShade),
      itemTitleRedStyle: theme.textStyles.r16.copyWith(color: Get.theme.colorScheme.error),
      itemSubtitleStyle: theme.textStyles.m16.copyWith(color: theme.colors.darkShade),
      usernameInitialsStyle: theme.textStyles.m30.copyWith(color: theme.colors.white),
      colors: theme.colors,
    );
  }
}

class MoreScreen extends StatelessWidget {
  final _MoreScreenStyle _style = _MoreScreenStyle.fromOldTheme(AppThemeOld.defaultTheme());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(AppStrings.PROFILE.tr(), style: TextStyle(color:Colors.black),),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            _listItem(
              context,
              AppStrings.ACCOUNT_SETTINGS.tr(),
              onTap: () => {KYC().openAccountLevel(context)},
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Divider(indent: 16, endIndent: 16, height: 1, thickness: 1, color: _style.colors.extraLightShade),
            ),
            _listItem(
              context,
              AppStrings.PROFILE_DETAILS.tr(),
              onTap: () => {showToast(context, "Will be available soon")},
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Divider(indent: 16, endIndent: 16, height: 1, thickness: 1, color: _style.colors.extraLightShade),
            ),
            _listItem(
              context,
              AppStrings.SETTINGS.tr(),
              onTap: () => {showToast(context, "Will be available soon")},
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Divider(indent: 16, endIndent: 16, height: 1, thickness: 1, color: _style.colors.extraLightShade),
            ),
            _listItem(
              context,
              AppStrings.RESET_PASSWORD.tr(),
              onTap: () => Get.to(ForgotPasswordScreen()),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Divider(indent: 16, endIndent: 16, height: 1, thickness: 1, color: _style.colors.extraLightShade),
            ),
            _listItem(
              context,
              AppStrings.LOGOUT.tr(),
              titleStyle: _style.itemTitleRedStyle,
              onTap: () => {
                context.read<SessionCubit>().logout(),
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _listItem(BuildContext context, String title,
      {String subtitle = "", GestureTapCallback onTap, TextStyle titleStyle}) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(color: _style.colors.lightShade, shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    IconsSVG.requestMoney,
                    color: _style.colors.boldShade,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Text(
                    title,
                    style: titleStyle ?? _style.itemTitleStyle,
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: Text(
                    subtitle,
                    style: _style.itemSubtitleStyle,
                  ),
                ),
                SvgPicture.asset(IconsSVG.arrowRightIOSStyle),
              ],
            )
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}

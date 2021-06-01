import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../common/models/list/list_item_entity.dart';
import '../../../../../common/passcode/pass_code_screen.dart';
import '../../../../../common/passcode/passcode_widget/pass_code_widget.dart';
import '../../../../../common/widgets/app_bars/base_app_bar.dart';
import '../../../../../resources/icons/icons_svg.dart';
import '../../../../../resources/strings/app_strings.dart';
import '../../../../../resources/themes/need_to_refactor_and_remove/app_colors_old.dart';
import '../../../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';
import '../change_password/change_password_screen.dart';

class _AccountSettingsScreenStyle {
  final TextStyle titleTextStyle;
  final TextStyle listItemTextStyle;
  final AppColorsOld colors;

  _AccountSettingsScreenStyle({
    this.titleTextStyle,
    this.listItemTextStyle,
    this.colors,
  });

  factory _AccountSettingsScreenStyle.fromOldTheme(AppThemeOld theme) {
    return _AccountSettingsScreenStyle(
      titleTextStyle:
          theme.textStyles.m18.copyWith(color: theme.colors.darkShade),
      listItemTextStyle:
          theme.textStyles.r16.copyWith(color: theme.colors.darkShade),
      colors: theme.colors,
    );
  }
}

class AccountSettingsScreen extends StatelessWidget {
  AccountSettingsScreen({this.currencyCode});

  final _AccountSettingsScreenStyle _style =
      _AccountSettingsScreenStyle.fromOldTheme(AppThemeOld.defaultTheme());

  final String currencyCode;

  List<ListItemEntity> get _funds => [
        ListItemEntity(
          title: AppStrings.CHANGE_PASSWORD,
          icon: SvgPicture.asset(IconsSVG.sendMoney,
              color: AppColorsOld.defaultColors().boldShade),
          onClick: () => Get.to(ChangePasswordScreen()),
        ),
        ListItemEntity(
          title: AppStrings.CHANGE_PASSCODE,
          icon: SvgPicture.asset(IconsSVG.sendMoney,
              color: AppColorsOld.defaultColors().boldShade),
          onClick: () {
            Get.to(const PassCodeScreen(
              status: PassCodeStatus.change,
            ));
          },
        )
      ];

  @override
  Widget build(BuildContext context) {
    final listSettings = _funds;
    return Scaffold(
      appBar: _appBar(),
      body: SafeArea(
        child: ListView.builder(
          itemCount: listSettings.length,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          itemBuilder: (BuildContext context, int index) {
            final item = listSettings[index];
            return ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
              leading: _roundIcon(context, item.icon),
              title: Text(
                item.title.tr(),
                style: _style.listItemTextStyle,
              ),
              trailing: SvgPicture.asset(IconsSVG.arrowRightIOSStyle),
              onTap: () => item.onClick(),
            );
            ;
          },
        ),
      ),
    );
  }

  BaseAppBar _appBar() => BaseAppBar(
        titleString: AppStrings.ACCOUNT_SETTINGS.tr(),
        titleColor: Colors.black,
      );

  Widget _roundIcon(BuildContext context, Widget icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: _style.colors.lightShade,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: icon,
    );
  }
}

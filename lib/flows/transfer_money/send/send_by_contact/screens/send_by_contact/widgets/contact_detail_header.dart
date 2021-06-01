import 'package:Velmie/common/widgets/user_circle_avatar.dart';
import 'package:Velmie/resources/colors/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../../../resources/colors/custom_color_scheme.dart';
import '../../../../../../../resources/icons/icons_svg.dart';
import '../../../../../../../resources/strings/app_strings.dart';
import '../../../../../../../resources/themes/app_text_theme.dart';
import '../../../../../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';
import '../../../entities/app_contact.dart';

class ContactDetailHeaderStyle {
  final TextStyle initialsStyle;
  final TextStyle cancelButtonStyle;

  ContactDetailHeaderStyle({
    this.initialsStyle,
    this.cancelButtonStyle,
  });

  factory ContactDetailHeaderStyle.fromOldTheme(AppThemeOld theme) {
    return ContactDetailHeaderStyle(
      initialsStyle: Get.textTheme.headline6Bold.copyWith(
        color: Get.theme.colorScheme.boldShade,
      ),
      cancelButtonStyle: theme.textStyles.r16.copyWith(color: AppColors.primary),
    );
  }
}

class ContactDetailHeader extends StatelessWidget {
  final AppContact contact;
  final ContactDetailHeaderStyle style;

  const ContactDetailHeader({
    Key key,
    @required this.contact,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          child: backButton(),
        ),
        Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              UserCircleAvatar(contact),
              const SizedBox(height: 8),
              _contactName(context),
              const SizedBox(height: 4),
              _contactPhone(context)
            ],
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          child: cancelButton(context),
        ),
      ],
    );
  }

  Widget backButton() {
    return CupertinoButton(
      minSize: 0,
      padding: EdgeInsets.fromLTRB(0.w, 12.h, 32.w, 12.h),
      child: SvgPicture.asset(
        IconsSVG.arrowLeftIOSStyle,
        color: Get.theme.colorScheme.primary,
      ),
      onPressed: () => Get.back(),
    );
  }

  Widget cancelButton(BuildContext context) {
    return CupertinoButton(
      minSize: 0,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Text(
        AppStrings.CANCEL.tr(),
        style: style.cancelButtonStyle,
      ),
      onPressed: () => Get.back(),
    );
  }

  Widget _contactName(BuildContext context) {
    return Text(
      contact.name,
      style: Get.textTheme.headline5.copyWith(color: Get.theme.colorScheme.primaryText),
      textAlign: TextAlign.center,
    );
  }

  Widget _contactPhone(BuildContext context) {
    return Text(
      contact.phoneNumber,
      style: Get.textTheme.headline6.copyWith(color: Get.theme.colorScheme.boldShade),
      textAlign: TextAlign.center,
    );
  }
}

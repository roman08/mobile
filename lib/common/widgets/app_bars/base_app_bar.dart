import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../resources/icons/icons_svg.dart';
import '../../../resources/themes/app_text_theme.dart';

/// Base AppBar implementation with simplified API
class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BaseAppBar({
    Key key,
    this.titleString,
    this.titleWidget,
    this.centerTitle = true,
    this.elevation,
    this.titleColor,
    this.isShowBack = true,
    this.leading,
    this.backgroundColor,
    this.toolbarHeight,
    this.backIconPath,
    this.backIconColor,
    this.onBackPress,
    this.actions,
    this.bottom,
  })  : assert(isShowBack != null),
        assert(elevation == null || elevation >= 0.0),
        assert(titleWidget == null || titleString == null,
            '\n\nCannot provide both a titleWidget and a titleString.\nUse only one option\n'),
        super(key: key);

  @override
  Size get preferredSize => Size.fromHeight((toolbarHeight ?? kToolbarHeight) +
      (bottom?.preferredSize?.height ?? 0.0));

  final String titleString;
  final Widget titleWidget;
  final bool centerTitle;
  final double elevation;
  final Color titleColor;
  final bool isShowBack;
  final Widget leading;
  final Color backgroundColor;
  final double toolbarHeight;
  final String backIconPath;
  final Color backIconColor;
  final VoidCallback onBackPress;
  final List<Widget> actions;
  final PreferredSizeWidget bottom;

  @override
  Widget build(BuildContext context) {

    return AppBar(
      title: titleWidget ??
          Text(
            titleString ?? '',
            style: Get.textTheme.headline4.copyWith(
              color: titleColor ?? Get.theme.colorScheme.onPrimary,
              fontWeight: FontWeight.w700
            ),
          ),
      centerTitle: centerTitle,
      toolbarHeight: toolbarHeight,
      elevation: elevation,
      flexibleSpace: Container(),
      backgroundColor: backgroundColor ?? Get.theme.colorScheme.background,
      actions: actions,
      leading: leading ??
          (isShowBack
              ? CupertinoButton(
                  padding: EdgeInsets.only(left: 16.w, right: 4.w),
                  child: SvgPicture.asset(
                    backIconPath ?? IconsSVG.arrowLeftIOSStyle,
                    color: backIconColor ?? Get.theme.colorScheme.onBackground,
                  ),
                  onPressed: onBackPress ?? () => Get.back(),
                )
              : null),
      bottom: bottom,
    );
  }
}

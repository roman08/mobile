import 'dart:ui';

import 'package:Velmie/resources/colors/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../resources/colors/custom_color_scheme.dart';
import '../../resources/strings/app_strings.dart';
import '../../resources/themes/app_text_theme.dart';
import '../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';

void showToast(BuildContext context, String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.grey.shade500,
      textColor: Colors.white,
      fontSize: 16.0.ssp);
}

void showAlertDialog(BuildContext context,
    {String title,
    String description,
    bool isDismissible,
    GestureTapCallback onPress}) {
  final Text titleWidget = Text(
    title,
    textAlign: TextAlign.center,
    style: Get.textTheme.headline4Bold.copyWith(color: Get.theme.colorScheme.onBackground),
  );

  final Column contentWidget = Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Padding(
        padding:
             EdgeInsets.only(left: 16.w, right: 16.w, bottom: 14.h, top: 4.h),
        child: Text(
          description,
          textAlign: TextAlign.center,
          style: Get.textTheme.bodyText2.copyWith(color: Get.theme.colorScheme.onBackground),
        ),
      ),
      Divider(
        thickness: 1,
        height: 0,
        color: Get.theme.colorScheme.primaryExtraLight,
      ),
      Container(
        width: double.infinity,
        height: 44,
        child: FlatButton(
          splashColor: Colors.transparent,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(14),
                bottomRight: Radius.circular(14)),
          ),
          child: Text(
            AppStrings.OK.tr().toUpperCase(),
            textAlign: TextAlign.center,
            style: Get.textTheme.button.copyWith(color: Get.theme.colorScheme.primary),
          ),
          onPressed: () {
            if (onPress == null) {
              Get.back();
            } else {
              onPress.call();
            }
          },
        ),
      ),
    ],
  );

  final AlertDialog dialogWidget = AlertDialog(
    contentPadding: const EdgeInsets.all(0),
    title: titleWidget,
    elevation: 0,
    content: contentWidget,
    backgroundColor: Get.theme.colorScheme.background,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14.0),
    ),
  );

  final BackdropFilter blurFilter = BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3), child: dialogWidget);

  // Show dialog
  showDialog(
    barrierDismissible: isDismissible ?? false,
    context: context,
    builder: (BuildContext context) {
      return blurFilter;
    },
  );
}

// TODO: Need to refactor: decomposite to separate widgets
void showSelectDialog(BuildContext context,
    {String titleText,
    String bodyText,
    bool isDismissible,
    String cancelButtonText,
    Color cancelButtonColor,
    bool isHighlightCancel = false,
    GestureTapCallback onCancelPress,
    String actionButtonText,
    Color actionButtonColor,
    bool isHighlightAction = false,
    GestureTapCallback onActionPress}) {
  final theme = Provider.of<AppThemeOld>(context, listen: false);
  final TextStyle titleTextStyle =
      theme.textStyles.m18.copyWith(color: theme.colors.darkShade);
  final TextStyle bodyTextStyle =
      theme.textStyles.r12.copyWith(color: theme.colors.darkShade);
  final TextStyle cancelButtonTextStyle =
      (isHighlightCancel ? theme.textStyles.m16 : theme.textStyles.r16)
          .copyWith(color: cancelButtonColor ?? AppColors.primary);
  final TextStyle actionButtonTextStyle =
      (isHighlightAction ? theme.textStyles.m16 : theme.textStyles.r16)
          .copyWith(color: actionButtonColor ?? AppColors.primary);

  final Text titleWidget = Text(
    titleText,
    textAlign: TextAlign.center,
    style: titleTextStyle,
  );

  final Column contentWidget = Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Container(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 10),
          child: Text(
            bodyText,
            textAlign: TextAlign.center,
            style: bodyTextStyle,
          ),
        ),
      ),
      Divider(
        thickness: 1,
        height: 0,
        color: theme.colors.lightShade,
      ),
      Container(
          height: 44,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 44,
                  child: FlatButton(
                    splashColor: Colors.transparent,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(14),
                      ),
                    ),
                    child: Text(
                      cancelButtonText,
                      textAlign: TextAlign.center,
                      style: cancelButtonTextStyle,
                    ),
                    onPressed: () {
                      if (onCancelPress == null) {
                        Get.back();
                      } else {
                        onCancelPress.call();
                      }
                    },
                  ),
                ),
              ),
              VerticalDivider(
                thickness: 1,
                width: 1,
                color: theme.colors.lightShade,
              ),
              Expanded(
                child: Container(
                  height: 44,
                  child: FlatButton(
                    splashColor: Colors.transparent,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.only(bottomRight: Radius.circular(14)),
                    ),
                    child: Text(
                      actionButtonText,
                      textAlign: TextAlign.center,
                      style: actionButtonTextStyle,
                    ),
                    onPressed: () {
                      if (onActionPress == null) {
                        Get.back();
                      } else {
                        onActionPress.call();
                      }
                    },
                  ),
                ),
              ),
            ],
          )),
    ],
  );

  final AlertDialog dialogWidget = AlertDialog(
    contentPadding: const EdgeInsets.all(0),
    title: titleWidget,
    elevation: 0,
    content: contentWidget,
    backgroundColor: theme.colors.thinShade,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14.0),
    ),
  );

  final BackdropFilter blurFilter = BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3), child: dialogWidget);

  // Show dialog
  showDialog(
    barrierDismissible: isDismissible ?? false,
    context: context,
    builder: (BuildContext context) {
      return blurFilter;
    },
  );
}

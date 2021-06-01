import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class AppOutlineButton extends StatelessWidget {
  AppOutlineButton(
      {@required this.title, this.color, this.disabledColor, this.onPressed}) {
    color = this.color ?? Get.theme.colorScheme.primary;
    disabledColor = this.disabledColor ?? Get.theme.colorScheme.surface;
  }

  final String title;
  final VoidCallback onPressed;
  Color disabledColor;
  Color color;

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      disabledBorderColor: disabledColor,
      disabledTextColor: disabledColor,
      textColor: color,
      borderSide: BorderSide(color: color),
      highlightedBorderColor: color,
      splashColor: Colors.transparent,
      highlightColor: color.withOpacity(0.9),
      onPressed: onPressed,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26.h)),
      child: Container(
          height: 48.h,
          alignment: Alignment.center,
          child: buttonText(context)),
    );
  }

  Widget buttonText(BuildContext context) => Text(
        title,
        textAlign: TextAlign.center,
        style: Get.textTheme.button,
      );
}

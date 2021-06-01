import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AppFlatButton extends StatelessWidget {
  const AppFlatButton({
    this.text,
    this.onPressed,
    this.textColor,
    this.disabledColor,
    this.textStyle,
  });

  final String text;
  final VoidCallback onPressed;
  final Color textColor;
  final Color disabledColor;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) => CupertinoButton(
        color: Colors.transparent,
        padding: EdgeInsets.zero,
        disabledColor: this.disabledColor ?? Get.theme.colorScheme.secondary,
        onPressed: onPressed,
        borderRadius: BorderRadius.all(Radius.circular(26.0.h)),
        child: buttonTitle(text),
      );

  Widget buttonTitle(String text) => Text(
        text,
        maxLines: 1,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: (this.textStyle ?? Get.textTheme.button)
            .copyWith(color: this.textColor ?? Get.theme.colorScheme.primary),
      );
}

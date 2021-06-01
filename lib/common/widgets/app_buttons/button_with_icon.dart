import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ButtonWithIcon extends StatelessWidget {
  final String title;
  final Widget icon;
  final Color color;
  final VoidCallback onPressed;

  const ButtonWithIcon({
    this.title,
    this.icon,
    this.color,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: color,
      textColor: Get.theme.colorScheme.onPrimary,
      onPressed: onPressed,
      splashColor: Colors.transparent,
      hoverColor: color.withOpacity(0.9),
      colorBrightness: Brightness.light,
      disabledColor: color.withOpacity(0.45),
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(26.0.h)),
      child: Container(
        height: 48.0.h,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (icon != null)
              Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: icon,
              )
            else
              const SizedBox(),
            buttonTitle(context)
          ],
        ),
      ),
    );
  }

  Widget buttonTitle(BuildContext context) => Text(
        title,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: Get.textTheme.button,
      );
}

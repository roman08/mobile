import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CircleButton extends StatelessWidget {
  const CircleButton({
    @required this.radius,
    @required this.iconSvgPath,
    this.iconColor,
    this.iconSize,
    this.color,
    this.disabledColor,
    this.onPressed,
    this.boxShadow,
  })  : assert(radius != null),
        assert(iconSvgPath != null);

  final double radius;
  final String iconSvgPath;
  final Color iconColor;
  final double iconSize;
  final Color color;
  final Color disabledColor;
  final VoidCallback onPressed;
  final List<BoxShadow> boxShadow;

  @override
  Widget build(BuildContext context) => Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(radius),
          ),
          boxShadow: boxShadow,
        ),
        child: CupertinoButton(
          color: color ?? Get.theme.colorScheme.surface,
          disabledColor:
              disabledColor ?? Get.theme.colorScheme.secondaryVariant,
          padding: EdgeInsets.zero,
          onPressed: onPressed,
          borderRadius: BorderRadius.all(
            Radius.circular(radius),
          ),
          child: Container(
            height: iconSize,
            width: iconSize,
            child: SvgPicture.asset(
              iconSvgPath,
              color: iconColor,
            ),
          ),
        ),
      );
}

import 'package:Velmie/resources/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CircleUIConfig {
  CircleUIConfig({
    this.extraSize = 0,
    this.borderColor = Colors.transparent,
    this.borderWidth = 0,
    this.fillColor = Colors.white,
    this.circleSize = 16,
    this.circleSpacing = 16,
  })  : assert(circleSize != null && circleSize > 0),
        assert(circleSpacing != null && circleSpacing > 0);

  final Color borderColor;
  final Color fillColor;
  final double borderWidth;
  final double circleSize;
  final double circleSpacing;
  double extraSize;
}

class PassCodeCircles extends StatelessWidget {
  const PassCodeCircles({
    Key key,
    this.count = 6,
    this.filledCount = 0,
    @required this.circleUIConfig,
  }) : super(key: key);

  final int count;
  final int filledCount;
  final CircleUIConfig circleUIConfig;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _circles(context),
      );

  List<Widget> _circles(BuildContext context) {
    final List<Widget> widgets = List(count);
    for (var i = 0; i < widgets.length; i++) {
      widgets[i] = Container(
        margin: EdgeInsets.only(
            right: i == widgets.length - 1 ? 0 : circleUIConfig.circleSpacing),
        width: circleUIConfig.circleSize.w,
        height: circleUIConfig.circleSize.h,
        decoration: BoxDecoration(
            color: i < filledCount
                ? circleUIConfig.fillColor
                : AppColors.primary.withOpacity(.4),
            shape: BoxShape.circle,
            border: Border.all(
              color: circleUIConfig.borderColor,
              width: circleUIConfig.borderWidth,
            )),
      );
    }
    return widgets;
  }
}

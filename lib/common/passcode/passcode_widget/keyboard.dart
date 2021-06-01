import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef KeyboardTapCallback = void Function(String text);

class KeyboardUIConfig {
  KeyboardUIConfig({
    this.digitBorderWidth = 0,
    this.primaryColor = Colors.white,
    this.digitFillColor = Colors.transparent,
    this.digitTextStyle,
  });

  final double digitBorderWidth;
  final TextStyle digitTextStyle;
  final Color primaryColor;
  final Color digitFillColor;
}

class Keyboard extends StatelessWidget {
  final KeyboardUIConfig keyboardUIConfig;
  final GestureTapCallback onRightWidgetTap;
  final GestureTapCallback onLeftWidgetTap;
  final KeyboardTapCallback onKeyboardTap;
  final bool isShowsRightWidget;
  final bool isShowsLeftWidget;
  final Widget leftWidget;
  final Widget rightWidget;

  const Keyboard({
    Key key,
    @required this.keyboardUIConfig,
    @required this.onKeyboardTap,
    this.rightWidget,
    this.leftWidget,
    this.onRightWidgetTap,
    this.onLeftWidgetTap,
    this.isShowsRightWidget = true,
    this.isShowsLeftWidget = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      primary: true,
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 48.w),
      crossAxisSpacing: 32.w,
      mainAxisSpacing: 16.h,
      crossAxisCount: 3,
      children: <Widget>[
        _buildKeyboardDigit('1'),
        _buildKeyboardDigit('2'),
        _buildKeyboardDigit('3'),
        _buildKeyboardDigit('4'),
        _buildKeyboardDigit('5'),
        _buildKeyboardDigit('6'),
        _buildKeyboardDigit('7'),
        _buildKeyboardDigit('8'),
        _buildKeyboardDigit('9'),
        if (isShowsLeftWidget) _addAdditionalWidget(leftWidget, onLeftWidgetTap) else Container(),
        _buildKeyboardDigit('0'),
        if (isShowsRightWidget) _addAdditionalWidget(rightWidget, onRightWidgetTap) else Container(),
      ],
    );
  }

  Widget _buildKeyboardDigit(String text) {
    return Container(
      child: ClipOval(
        child: Material(
          color: keyboardUIConfig.digitFillColor,
          child: InkWell(
            highlightColor: keyboardUIConfig.primaryColor,
            splashColor: keyboardUIConfig.primaryColor.withOpacity(0.4),
            onTap: () {
              onKeyboardTap(text);
            },
            child: Center(
              child: Text(
                text,
                style: keyboardUIConfig.digitTextStyle,
              ),
            ),
          ),
        ),
      ),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _addAdditionalWidget(Widget widget, GestureTapCallback onTap) {
    return widget != null
        ? Container(
            child: ClipOval(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  highlightColor: keyboardUIConfig.primaryColor,
                  splashColor: keyboardUIConfig.primaryColor.withOpacity(0.4),
                  onTap: onTap,
                  child: widget,
                ),
              ),
            ),
          )
        : Container();
  }
}

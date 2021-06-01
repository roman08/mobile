import 'dart:async';

import 'package:Velmie/resources/colors/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import '../../../resources/colors/custom_color_scheme.dart';

class _CountdownTimer {
  final int _countdownTimeInSeconds;
  final BehaviorSubject<int> onCountdownUpd;
  Timer _timer;

  int _countdown = 0;
  final Duration _countdownDuration = const Duration(seconds: 1);

  int get countdown => _countdown;

  _CountdownTimer(this._countdownTimeInSeconds)
      : this.onCountdownUpd = BehaviorSubject<int>();

  void restart() {
    _timer?.cancel();
    _countdown = _countdownTimeInSeconds;
    onCountdownUpd.add(_countdown);
    _timer = Timer.periodic(_countdownDuration, (Timer t) {
      onCountdownUpd.add(--_countdown);
      if (_countdown == 0) {
        _timer?.cancel();
      }
    });
  }

  void dispose() {
    _timer?.cancel();
  }
}

// ignore: must_be_immutable
class CountdownTimerButton extends StatefulWidget {
  CountdownTimerButton({
    @required this.title,
    @required this.timerTitle,
    @required this.countdownSeconds,
    this.onPressed,
    this.disableInitially = false,
    this.color,
    this.onPressColor,
    this.disabledColor,
    this.textColor,
  })  : assert(title != null),
        assert(timerTitle != null),
        assert(countdownSeconds != null) {
    color = this.color ?? Get.theme.colorScheme.primary;
    onPressColor = this.onPressColor ?? Get.theme.colorScheme.primary;
    disabledColor =
        this.disabledColor ?? Get.theme.colorScheme.primaryExtraLight;
    textColor = this.textColor ?? Get.theme.colorScheme.onPrimary;
    disabledTextColor =
        (this.disabledTextColor ?? Get.theme.colorScheme.primaryVariant)
            .withOpacity(0.5);
  }

  final String title;
  final VoidCallback onPressed;
  final String timerTitle;
  final int countdownSeconds;
  final bool disableInitially;
  Color color;
  Color onPressColor;
  Color disabledColor;
  Color textColor;
  Color disabledTextColor;

  @override
  CountdownTimerButtonState createState() => CountdownTimerButtonState();
}

class CountdownTimerButtonState extends State<CountdownTimerButton> {
  _CountdownTimer _countdownTimer;
  bool _isDisableButton = false;

  @override
  void initState() {
    _countdownTimer = _CountdownTimer(widget.countdownSeconds);
    _countdownTimer.onCountdownUpd.listen((value) {
      _disableButton(!(value == 0));
    });

    if (widget.disableInitially) {
      _disableButton(true);
      _countdownTimer.restart();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(boxShadow: [
          if (_isDisableButton)
            BoxShadow(color: Get.theme.colorScheme.background)
          else
            BoxShadow(
              color: AppColors.primary.withOpacity(.5),
              blurRadius: 16,
              offset: const Offset(0, 5), // changes position of shadow
            )
        ]),
        child: MaterialButton(
          height: 48.h,
          color: widget.color,
          elevation: 0,
          highlightElevation: 0,
          hoverColor: widget.color.withOpacity(0.9),
          disabledColor: widget.disabledColor,
          splashColor: Colors.transparent,
          onPressed: _isDisableButton ? null : () => _onPressEvent(),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(26.0.h)),
          child: StreamBuilder<int>(
            initialData: _countdownTimer.onCountdownUpd.value,
            stream: _countdownTimer.onCountdownUpd,
            builder: (context, snapshot) => _buttonTitle(_isDisableButton
                ? '${widget.timerTitle} 0:${snapshot.data}'
                : widget.title),
          ),
        ),
      );

  Widget _buttonTitle(String title) => Text(
        title,
        maxLines: 1,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: Get.textTheme.button.copyWith(
          color: _isDisableButton ? widget.disabledTextColor : widget.textColor,
        ),
      );

  void _onPressEvent() {
    _disableButton(true);
    _countdownTimer.restart();
    return widget.onPressed();
  }

  void _disableButton(bool isDisable) {
    setState(() => _isDisableButton = isDisable);
  }

  @override
  void dispose() {
    _countdownTimer.dispose();
    super.dispose();
  }
}

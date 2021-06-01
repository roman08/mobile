import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSwitch extends StatefulWidget {
  final bool value, showOnOff;
  final ValueChanged<bool> onToggle;
  final Color activeColor, inactiveColor, activeTextColor, inactiveTextColor;
  final double width, height, toggleSize, valueFontSize, borderRadius, padding;

  const CustomSwitch({
    Key key,
    this.value,
    this.onToggle,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
    this.activeTextColor = Colors.white70,
    this.inactiveTextColor = Colors.white70,
    this.width = 41,
    this.height = 25,
    this.toggleSize = 15.5,
    this.valueFontSize = 16.0,
    this.borderRadius = 20.0,
    this.padding = 3,
    this.showOnOff = false,
  }) : super(key: key);

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch>
    with SingleTickerProviderStateMixin {
  Animation _toggleAnimation;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 60),
    );
    _toggleAnimation = AlignmentTween(
      begin: widget.value ? Alignment.centerRight : Alignment.centerLeft,
      end: widget.value ? Alignment.centerLeft : Alignment.centerRight,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            if (_animationController.isCompleted) {
              _animationController.reverse();
            } else {
              _animationController.forward();
            }
            widget.value == false
                ? widget.onToggle(true)
                : widget.onToggle(false);
          },
          child: Container(
            width: widget.width,
            height: widget.height,
            padding: EdgeInsets.all(widget.padding),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                border: Border.all(
                    color: widget.value
                        ? widget.activeColor
                        : widget.inactiveColor,
                    width: 2),
                color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                if (_toggleAnimation.value == Alignment.centerRight)
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        widget.showOnOff ? "On" : "",
                        style: TextStyle(
                          color: widget.activeTextColor,
                          fontWeight: FontWeight.w900,
                          fontSize: widget.valueFontSize.ssp,
                        ),
                      ),
                    ),
                  )
                else
                  const SizedBox(),
                Align(
                  alignment: _toggleAnimation.value,
                  child: Container(
                    width: widget.toggleSize,
                    height: widget.toggleSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.value
                          ? widget.activeColor
                          : widget.inactiveColor,
                    ),
                  ),
                ),
                if (_toggleAnimation.value == Alignment.centerLeft)
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      alignment: Alignment.centerRight,
                      child: Text(
                        widget.showOnOff ? "Off" : "",
                        style: TextStyle(
                          color: widget.inactiveTextColor,
                          fontWeight: FontWeight.w900,
                          fontSize: widget.valueFontSize.ssp,
                        ),
                      ),
                    ),
                  )
                else
                  const SizedBox(),
              ],
            ),
          ),
        );
      },
    );
  }
}

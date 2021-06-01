import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//  An indicator showing the currently selected page of a PageController
class DotsIndicator extends AnimatedWidget {
  const DotsIndicator({
    this.controller,
    this.itemCount,
    this.onPageSelected,
    this.dotColor = Colors.white,
  }) : super(listenable: controller);

  /// The PageController that this DotsIndicator is representing.
  final PageController controller;

  /// The number of items managed by the PageController
  final int itemCount;

  /// Called when a dot is tapped
  final ValueChanged<int> onPageSelected;

  /// The color of the dots.
  /// Defaults to `Colors.white`.
  final Color dotColor;

  /// The base size of the dots
  static const double _dotSize = 5.0;

  /// The increase in the size of the selected dot
  static const double _maxZoom = 1.5;

  /// The distance between the center of each dot
  static const double _dotSpacing = 17.0;

  Widget _buildDot(int index) {
    final double selectedDot = Curves.easeOut.transform(
      max(0.0,
          1.0 - ((controller.page ?? controller.initialPage) - index).abs()),
    );
    final double zoom = 1.0 + (_maxZoom - 1.0) * selectedDot;
    return Container(
      width: _dotSpacing,
      child: Center(
        child: Material(
          color: dotColor,
          type: MaterialType.circle,
          child: Container(
            width: _dotSize * zoom,
            height: _dotSize * zoom,
            child: InkWell(onTap: () {
              onPageSelected(index);
            }),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(itemCount, _buildDot),
    );
  }
}

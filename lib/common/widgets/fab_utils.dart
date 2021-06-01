import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/*
    Bottom padding of FAB for prevent overlap screen when user scrolled down
 */
const int FAB_BOTTOM_PADDING = 100;
/*
    Padding for input fields when keyboard visible
 */
const int FAB_INPUT_SCROLL_PADDING = 120;

class CenterBottomFabLocation extends FloatingActionButtonLocation {
  const CenterBottomFabLocation();

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    // Compute the x-axis offset.
    final double fabX = (scaffoldGeometry.scaffoldSize.width -
            scaffoldGeometry.floatingActionButtonSize.width) /
        2.0;

    // Compute the y-axis offset.
    final double contentBottom = scaffoldGeometry.contentBottom;
    final double fabHeight = scaffoldGeometry.floatingActionButtonSize.height;
    final double fabY = contentBottom - fabHeight;
    return Offset(fabX, fabY);
  }
}

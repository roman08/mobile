import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../resources/icons/icons_svg.dart';
import '../models/tiers_result.dart';

class PropertyWidget extends StatelessWidget {
  final String title;
  final RequirementStatus status;
  final TextStyle textStyle;

  const PropertyWidget({
    Key key,
    this.title,
    this.status,
    this.textStyle,
  }) : super(key: key);

  String _getImageName() {
    switch (this.status) {
      case RequirementStatus.approved:
        return IconsSVG.check;
      case RequirementStatus.pending:
        return IconsSVG.waiting;
      case RequirementStatus.canceled:
        return IconsSVG.cross;
      default:
        return IconsSVG.empty;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SvgPicture.asset(
          _getImageName(),
        ),
        SizedBox(
          width: status == RequirementStatus.notFilled ? 15 : 10,
        ),
        SizedBox(
          width: ScreenUtil.screenWidth * 0.6,
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: textStyle,
          ),
        )
      ],
    );
  }
}

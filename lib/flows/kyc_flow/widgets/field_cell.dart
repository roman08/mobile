import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../resources/icons/icons_svg.dart';
import '../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';

class FieldCell extends StatelessWidget {
  final String text;
  final bool status;
  final Function onPressed;

  const FieldCell({
    Key key,
    this.text,
    this.status,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<AppThemeOld>(context);

    return CupertinoButton(
      minSize: 0,
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        height: 43,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              this.text,
              style: theme.textStyles.r16.copyWith(
                color: theme.colors.darkShade,
              ),
            ),
            if (status)
              SvgPicture.asset(
                IconsSVG.check,
              )
            else
              Container(),
          ],
        ),
      ),
    );
  }
}

import 'package:Velmie/resources/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';

class LoadingFooter extends StatefulWidget {
  final AppThemeOld theme = AppThemeOld.defaultTheme();

  @override
  _LoadingFooterState createState() => _LoadingFooterState();
}

class _LoadingFooterState extends State<LoadingFooter> {
  @override
  Widget build(BuildContext context) {
    return CustomFooter(
      loadStyle: LoadStyle.ShowWhenLoading,
      builder: (BuildContext context, LoadStatus mode) {
        return Container(
            height: 30,
            alignment: Alignment.center,
            child: SizedBox(
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                backgroundColor: widget.theme.colors.lightShade,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
              height: 23.0,
              width: 23.0,
            ));
      },
    );
  }
}

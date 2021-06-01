import 'package:Velmie/common/utils/ensure_localization_switched.dart';
import 'package:Velmie/resources/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';

class LoadingHeader extends StatefulWidget {
  final AppThemeOld theme = AppThemeOld.defaultTheme();

  @override
  _LoadingHeaderState createState() => _LoadingHeaderState();
}

class _LoadingHeaderState extends State<LoadingHeader> {
  double _offset;
  RefreshStatus _mode;

  @override
  Widget build(BuildContext context) {
    ensureLocalizationSwitched(context);

    return CustomHeader(
      refreshStyle: RefreshStyle.UnFollow,
      onOffsetChange: (offset) => {
        if (_mode == RefreshStatus.idle)
          {
            setState(() {
              _offset = offset / 30 - 1;
            })
          }
      },
      height: 30,
      onModeChange: (mode) {
        if (mode == RefreshStatus.refreshing) {
          setState(() {
            _offset = null;
            _mode = mode;
          });
        } else {
          setState(() {
            _mode = mode;
          });
        }
      },
      builder: (BuildContext context, RefreshStatus mode) {
        return Container(
            height: 30,
            alignment: Alignment.center,
            child: SizedBox(
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                value: _offset,
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

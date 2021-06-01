import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/widgets/app_bars/base_app_bar.dart';
import '../../../../common/widgets/app_buttons/button.dart';
import '../../../../resources/strings/app_strings.dart';
import '../../../../resources/themes/need_to_refactor_and_remove/app_colors_old.dart';
import '../../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';
import '../widget/add_funds_credit_card_form.dart';

class _AddFundsCreditCardScreenStyle {
  final TextStyle titleTextStyle;
  final TextStyle defaultTextStyle;
  final TextStyle boldTextStyle;
  final AppColorsOld colors;

  _AddFundsCreditCardScreenStyle({
    this.titleTextStyle,
    this.defaultTextStyle,
    this.boldTextStyle,
    this.colors,
  });

  factory _AddFundsCreditCardScreenStyle.fromOldTheme(AppThemeOld theme) {
    return _AddFundsCreditCardScreenStyle(
      titleTextStyle:
          theme.textStyles.m18.copyWith(color: theme.colors.darkShade),
      defaultTextStyle:
          theme.textStyles.r16.copyWith(color: theme.colors.darkShade),
      boldTextStyle:
          theme.textStyles.m16.copyWith(color: theme.colors.darkShade),
      colors: theme.colors,
    );
  }
}

class AddFundsCreditCardScreen extends StatelessWidget {
  AddFundsCreditCardScreen({this.title, this.currency});

  final _AddFundsCreditCardScreenStyle _style =
      _AddFundsCreditCardScreenStyle.fromOldTheme(AppThemeOld.defaultTheme());

  final String title;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final appBar = _appBar();
    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: Container(
          height: double.infinity,
          child: SingleChildScrollView(
            child: SizedBox(
              height: ScreenUtil.screenHeight -
                  ScreenUtil.statusBarHeight -
                  appBar.preferredSize.height,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Column(
                  children: <Widget>[
                    AddFundsCreditCardForm(),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 13.h),
                            child: RichText(
                              maxLines: 1,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                style: _style.defaultTextStyle,
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "${AppStrings.TOTAL.tr()}: ",
                                    style: _style.boldTextStyle,
                                  ),
                                  TextSpan(text: '0'),
                                  TextSpan(text: " $currency"),
                                ],
                              ),
                            ),
                          ),
                          Button(
                            onPressed: null,
                            title: AppStrings.ADD_FUNDS.tr(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  BaseAppBar _appBar() => BaseAppBar(
        titleString: title.tr(),
      );
}

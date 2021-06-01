import 'package:Velmie/resources/colors/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../resources/icons/icons_svg.dart';
import '../../../resources/strings/app_strings.dart';
import '../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';

class SuccessScreenStyle {
  final TextStyle titleTextStyle;
  final TextStyle bodyTextStyle;
  final TextStyle buttonTextStyle;
  final Color buttonBackgroundColor;

  SuccessScreenStyle({
    this.titleTextStyle,
    this.bodyTextStyle,
    this.buttonTextStyle,
    this.buttonBackgroundColor,
  });

  factory SuccessScreenStyle.fromOldTheme(AppThemeOld theme) {
    return SuccessScreenStyle(
      titleTextStyle: theme.textStyles.m20.copyWith(color: theme.colors.darkShade),
      bodyTextStyle: theme.textStyles.r16.copyWith(color: theme.colors.boldShade),
      buttonTextStyle: theme.textStyles.m16.copyWith(color: theme.colors.white),
      buttonBackgroundColor: AppColors.primary,
    );
  }
}

class SuccessScreen extends StatefulWidget {
  static const String ROUTE = '/kyc/success';

  final String title;

  const SuccessScreen({
    Key key,
    this.title,
  }) : super(key: key);

  @override
  _SuccessScreenState createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  SuccessScreenStyle _style;

  @override
  void initState() {
    _style = SuccessScreenStyle.fromOldTheme(
      Provider.of<AppThemeOld>(context, listen: false),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SvgPicture.asset(
                        IconsSVG.successLogo,
                        color: Get.theme.colorScheme.primary,
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      Text(
                        KYCStrings.SUCCESS_TITLE.tr() + ' ”${this.widget.title}”',
                        textAlign: TextAlign.center,
                        style: _style.titleTextStyle,
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      Text(
                        KYCStrings.SUCCESS_BODY.tr(),
                        textAlign: TextAlign.center,
                        style: _style.bodyTextStyle,
                      ),
                    ],
                  ),
                ),
              ),
              CupertinoButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                minSize: 0,
                padding: EdgeInsets.zero,
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      24,
                    ),
                    color: _style.buttonBackgroundColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        AppStrings.DONE.tr(),
                        style: _style.buttonTextStyle,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

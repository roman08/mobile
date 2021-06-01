import 'package:Velmie/resources/colors/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../common/widgets/info_widgets.dart';
import '../../../../../../resources/icons/icons_svg.dart';
import '../../../../../../resources/strings/app_strings.dart';
import '../../../../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';

class RecentTransfersStyle {
  final TextStyle titleTextStyle;
  final TextStyle allButtonStyle;
  final BoxShadow shadow;
  final RecentTransferStyle itemStyle;

  RecentTransfersStyle({this.titleTextStyle, this.shadow, this.allButtonStyle, this.itemStyle});

  factory RecentTransfersStyle.fromOldTheme(AppThemeOld theme) {
    return RecentTransfersStyle(
      titleTextStyle: theme.textStyles.m16.copyWith(color: theme.colors.darkShade),
      shadow: BoxShadow(
          color: theme.colors.darkShade.withOpacity(0.1), offset: const Offset(0, 2), blurRadius: 16, spreadRadius: 0),
      itemStyle: RecentTransferStyle.fromOldTheme(theme),
      allButtonStyle: theme.textStyles.m16.copyWith(color: AppColors.primary),
    );
  }
}

class RecentTransfers extends StatelessWidget {
  final RecentTransfersStyle style;

  const RecentTransfers({this.style});

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _title(context),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(left: 16, bottom: 0, top: 24, right: 16),
            decoration:
                BoxDecoration(color: Colors.white, boxShadow: [style.shadow], borderRadius: BorderRadius.circular(16)),
            child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                child: Column(children: <Widget>[
                  RecentTransfer(
                      style: style.itemStyle,
                      titleText: "[Description]",
                      descriptionText: "To: John Macou",
                      amount: "\$32",
                      assetImage: IconsSVG.income),
                  RecentTransfer(
                      style: style.itemStyle,
                      titleText: "[Description]",
                      descriptionText: "From: John Macou",
                      amount: "\$132.6",
                      assetImage: IconsSVG.outcome),
                  RecentTransfer(
                      style: style.itemStyle,
                      titleText: "[Description]",
                      descriptionText: "From GBP to USD wallet",
                      amount: "\$325",
                      assetImage: IconsSVG.transfer),
                  RecentTransfer(
                      style: style.itemStyle,
                      titleText: "[Description]",
                      descriptionText: "To: Bank Account Details",
                      amount: "\$32",
                      assetImage: IconsSVG.bankAccount),
                  RecentTransfer(
                      style: style.itemStyle,
                      titleText: "[Description]",
                      descriptionText: "To: USD Wallet",
                      amount: "\$0",
                      assetImage: IconsSVG.fund)
                ])),
          )
        ]);
  }

  Widget _title(BuildContext context) {
    final recentTransfers = AppStrings.RECENT_TRANSFERS.tr();
    final all = AppStrings.ALL.tr();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(left: 16),
          child: Text(
            recentTransfers,
            style: style.titleTextStyle,
          ),
        ),
        const Spacer(),
        CupertinoButton(
          onPressed: () {
            showToast(context, "Will be available soon");
          },
          child: Text(all, style: style.allButtonStyle),
          padding: const EdgeInsets.only(top: 24),
        )
      ],
    );
  }
}

class RecentTransferStyle {
  final TextStyle titleTextStyle;
  final TextStyle descriptionTextStyle;
  final Color shapeColor;

  RecentTransferStyle({this.titleTextStyle, this.descriptionTextStyle, this.shapeColor});

  factory RecentTransferStyle.fromOldTheme(AppThemeOld theme) {
    return RecentTransferStyle(
        titleTextStyle: theme.textStyles.m14.copyWith(color: theme.colors.darkShade),
        descriptionTextStyle: theme.textStyles.r12.copyWith(color: theme.colors.boldShade),
        shapeColor: theme.colors.midShade);
  }
}

class RecentTransfer extends StatelessWidget {
  final RecentTransferStyle style;
  final String titleText;
  final String descriptionText;
  final String amount;
  final String assetImage;

  const RecentTransfer({this.style, this.titleText, this.descriptionText, this.amount, this.assetImage});

  @override
  Widget build(BuildContext context) => Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(color: style.shapeColor, shape: BoxShape.circle),
                child: SvgPicture.asset(assetImage),
              ),
              SizedBox(
                width: 16,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(titleText, style: style.titleTextStyle),
                  SizedBox(height: 4),
                  Text(descriptionText, style: style.descriptionTextStyle)
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SizedBox(
                width: 16,
              ),
              Text(amount, style: style.titleTextStyle),
              SizedBox(width: 16)
            ],
          )
        ],
      ));
}

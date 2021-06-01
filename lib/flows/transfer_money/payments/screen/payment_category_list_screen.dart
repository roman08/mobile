import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../common/models/list/list_item_entity.dart';
import '../../../../common/widgets/app_bars/base_app_bar.dart';
import '../../../../resources/icons/icons_svg.dart';
import '../../../../resources/strings/app_strings.dart';
import '../../../../resources/themes/need_to_refactor_and_remove/app_colors_old.dart';
import '../../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';
import 'add_funds_credit_card.dart';
import 'add_funds_phone_number.dart';

class _PaymentCategoryListScreenStyle {
  final TextStyle titleTextStyle;
  final TextStyle listItemTextStyle;
  final AppColorsOld colors;

  _PaymentCategoryListScreenStyle({
    this.titleTextStyle,
    this.listItemTextStyle,
    this.colors,
  });

  factory _PaymentCategoryListScreenStyle.fromOldTheme(AppThemeOld theme) {
    return _PaymentCategoryListScreenStyle(
      titleTextStyle:
          theme.textStyles.m18.copyWith(color: theme.colors.darkShade),
      listItemTextStyle:
          theme.textStyles.r16.copyWith(color: theme.colors.darkShade),
      colors: theme.colors,
    );
  }
}

enum PaymentsType { add_funds, withdraw }

class PaymentCategoryListScreen extends StatelessWidget {
  PaymentCategoryListScreen({this.paymentsType, this.currencyCode});

  final _PaymentCategoryListScreenStyle _style =
      _PaymentCategoryListScreenStyle.fromOldTheme(AppThemeOld.defaultTheme());

  final String currencyCode;
  final PaymentsType paymentsType;

  List<ListItemEntity> get _funds => [
        ListItemEntity(
          title: "Provider",
          icon: SvgPicture.asset(
            IconsSVG.sendMoney,
            color: AppColorsOld.defaultColors().boldShade,
            width: 18.w,
          ),
          onClick: () {
            Get.to(AddFundsPhoneNumberScreen(
              title: "Provider",
              currency: currencyCode,
            ));
          },
        ),
        ListItemEntity(
          title: AppStrings.CREDIT_CARD,
          icon: SvgPicture.asset(
            IconsSVG.sendMoney,
            color: AppColorsOld.defaultColors().boldShade,
            width: 18.w,
          ),
          onClick: () {
            Get.to(AddFundsCreditCardScreen(
              title: AppStrings.CREDIT_CARD,
              currency: currencyCode,
            ));
          },
        )
      ];

  List<ListItemEntity> get _withdraw => [
        ListItemEntity(
          title: "Provider",
          icon: SvgPicture.asset(
            IconsSVG.sendMoney,
            color: AppColorsOld.defaultColors().boldShade,
            width: 18.w,
          ),
          onClick: () {
            Get.to(AddFundsPhoneNumberScreen(
              title: "Provider",
              currency: currencyCode,
            ));
          },
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final listFunds =
        (paymentsType == PaymentsType.add_funds) ? _funds : _withdraw;
    return Scaffold(
      appBar: _appBar(),
      body: SafeArea(
        child: ListView.builder(
          itemCount: listFunds.length,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          itemBuilder: (BuildContext context, int index) {
            final item = listFunds[index];
            return ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
              leading: _roundIcon(context, item.icon),
              title: Text(
                item.title.tr(),
                style: _style.listItemTextStyle,
              ),
              trailing: SvgPicture.asset(IconsSVG.arrowRightIOSStyle),
              onTap: () => item.onClick(),
            );
            ;
          },
        ),
      ),
    );
  }

  BaseAppBar _appBar() => BaseAppBar(
        titleString: ((paymentsType == PaymentsType.add_funds)
                ? AppStrings.ADD_FUNDS
                : AppStrings.WITHDRAW)
            .tr(),
      );

  Widget _roundIcon(BuildContext context, Widget icon) {
    return Container(
      width: 40.w,
      decoration: BoxDecoration(
        color: _style.colors.lightShade,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: icon,
    );
  }
}

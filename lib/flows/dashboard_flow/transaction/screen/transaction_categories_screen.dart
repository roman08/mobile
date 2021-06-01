import 'package:Velmie/resources/colors/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/app_bars/app_bar_with_left_button.dart';
import '../../../../resources/icons/icons_svg.dart';
import '../../../../resources/strings/app_strings.dart';
import '../../../../resources/themes/need_to_refactor_and_remove/app_colors_old.dart';
import '../../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';
import '../../entities/transaction/request_enum.dart';

class _TransactionCategoriesScreenStyle {
  final TextStyle titleTextStyle;
  final AppColorsOld colors;
  final TextStyle cancelButtonStyle;
  final TextStyle clearButtonStyle;
  final String iconDropDown;
  final TextStyle listTextStyle;

  _TransactionCategoriesScreenStyle({
    this.titleTextStyle,
    this.colors,
    this.cancelButtonStyle,
    this.iconDropDown,
    this.listTextStyle,
    this.clearButtonStyle,
  });

  factory _TransactionCategoriesScreenStyle.fromOldTheme(AppThemeOld theme) {
    return _TransactionCategoriesScreenStyle(
      titleTextStyle: theme.textStyles.m18.copyWith(color: theme.colors.darkShade),
      colors: theme.colors,
      cancelButtonStyle: theme.textStyles.m16.copyWith(color: AppColors.primary),
      iconDropDown: IconsSVG.arrowDown,
      listTextStyle: theme.textStyles.r16.copyWith(color: theme.colors.darkShade),
      clearButtonStyle: theme.textStyles.r16.copyWith(color: AppColors.primary),
    );
  }
}

const List<_Choice> _choices = <_Choice>[
  _Choice(category: RequestCategory.add_fund, title: AppStrings.ADD_FUND),
  _Choice(category: RequestCategory.withdraw, title: AppStrings.WITHDRAW),
  _Choice(category: RequestCategory.send_money, title: AppStrings.SEND_MONEY),
  _Choice(category: RequestCategory.request_money, title: AppStrings.REQUEST_MONEY),
  _Choice(category: RequestCategory.pay_bills, title: AppStrings.PAY_BILLS),
];

class TransactionCategoriesScreen extends StatefulWidget {
  const TransactionCategoriesScreen(this._selectedCategory);

  final RequestCategory _selectedCategory;

  @override
  _TransactionCategoriesState createState() => _TransactionCategoriesState(selectedCategory: _selectedCategory);
}

class _TransactionCategoriesState extends State<TransactionCategoriesScreen> {
  _TransactionCategoriesState({this.selectedCategory});

  RequestCategory selectedCategory;

  final _TransactionCategoriesScreenStyle style =
      _TransactionCategoriesScreenStyle.fromOldTheme(AppThemeOld.defaultTheme());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: SafeArea(
          child: ListView.separated(
              separatorBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(
                    color: style.colors.extraLightShade,
                    thickness: 1,
                  )),
              padding: const EdgeInsets.all(8),
              itemCount: _choices.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == _choices.length) {
                  return Container();
                }
                return _listViewItem(context, _choices[index]);
              })),
    );
  }

  Widget _appBar(BuildContext context) {
    return AppBarWithLeftButton(
      backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: _appBarLeftButton(context),
      title: Text(
        AppStrings.CATEGORIES.tr(),
        style: style.titleTextStyle,
      ),
      actions: <Widget>[
        CupertinoButton(
            child: Text(AppStrings.DONE.tr(), style: style.cancelButtonStyle),
            onPressed: () => {Get.back(result: selectedCategory)}),
      ],
    );
  }

  Widget _appBarLeftButton(BuildContext context) {
    if (selectedCategory != null) {
      return CupertinoButton(
          child: Text(AppStrings.CLEAR.tr(), style: style.clearButtonStyle),
          onPressed: () => {
                setState(() {
                  selectedCategory = null;
                })
              });
    } else {
      return CupertinoButton(
        child: SvgPicture.asset(
          IconsSVG.arrowLeftIOSStyle,
          color: Get.theme.colorScheme.primary,
        ),
        onPressed: () => Get.back(),
      );
    }
  }

  Widget _listViewItem(BuildContext context, _Choice choice) {
    return ListTile(
      title: Text(
        choice.title.tr(),
        style: style.listTextStyle,
      ),
      trailing: _selectedElement(choice.category == selectedCategory),
      onTap: () => {
        setState(() {
          selectedCategory = choice.category;
        })
      },
    );
  }

  Widget _selectedElement(bool isSelected) {
    if (isSelected) {
      return SvgPicture.asset(IconsSVG.successful, height: 28);
    } else {
      return Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(width: 1, color: style.colors.lightShade)),
      );
    }
  }
}

class _Choice {
  const _Choice({this.category, this.title});

  final RequestCategory category;
  final String title;
}

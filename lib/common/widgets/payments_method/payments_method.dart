import 'package:Velmie/resources/colors/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';
import 'entity/payment_method_entity.dart';
import 'payments_method_title.dart';

class _PaymentsMethodStyle {
  final TextStyle titleTextStyle;
  final TextStyle allButtonStyle;
  final PaymentsTileStyle tileStyle;
  final AppThemeOld appThemeOld;

  _PaymentsMethodStyle({this.titleTextStyle, this.allButtonStyle, this.tileStyle, this.appThemeOld});

  factory _PaymentsMethodStyle.fromOldTheme(AppThemeOld theme) {
    return _PaymentsMethodStyle(
      titleTextStyle: theme.textStyles.m16.copyWith(color: theme.colors.darkShade, fontWeight: FontWeight.w200),
      allButtonStyle: theme.textStyles.m16.copyWith(color: AppColors.primary),
      tileStyle: PaymentsTileStyle.fromOldTheme(theme),
      appThemeOld: theme,
    );
  }
}

class PaymentsMethod extends StatelessWidget {
  PaymentsMethod({
    Key key,
    @required this.payments,
    this.onPressed,
    this.title = 'Title',
    this.actionTitle = '',
  })  : assert(payments != null),
        super(key: key);

  final String title;
  final String actionTitle;
  final VoidCallback onPressed;
  final List<PaymentsMethodEntity> payments;

  final _PaymentsMethodStyle _style = _PaymentsMethodStyle.fromOldTheme(AppThemeOld.defaultTheme());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _title(context),
        Container(
          height: 130,
          child: ListView.builder(
              padding: const EdgeInsets.only(top: 8, left: 8, right: 10, bottom: 12),
              scrollDirection: Axis.horizontal,
              itemCount: payments.length,
              itemBuilder: (BuildContext context, int index) {
                final item = payments[index];
                return _paymentTile(
                  title: item.title,
                  icon: item.icon,
                  isEnable: item.isEnable,
                  onPress: item.onPressed,
                );
              }),
        ),
      ],
    );
  }

  Widget _title(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(left: 16),
          child: Text(
            title,
            style: _style.titleTextStyle,
          ),
        ),
        const Spacer(),
        CupertinoButton(
          onPressed: onPressed,
          child: Text(actionTitle, style: _style.allButtonStyle),
          padding: const EdgeInsets.only(top: 24),
        )
      ],
    );
  }

  Widget _paymentTile({String title, String icon, GestureTapCallback onPress, bool isEnable}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MostPopularPaymentsTile(
        form: PaymentsTileForm(text: title, icon: icon, isEnable: isEnable),
        style: _style.tileStyle,
        onPress: onPress,
      ),
    );
  }
}

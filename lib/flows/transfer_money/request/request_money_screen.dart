import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../common/widgets/app_bars/base_app_bar.dart';
import '../../../resources/icons/icons_svg.dart';
import '../../../resources/strings/app_strings.dart';
import '../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';
import '../send/send_by_contact/contacts_list_flow.dart';
import 'request_by_qr/bloc/request_by_qr/request_money_qr_cubit.dart';
import 'request_by_qr/bloc/request_by_qr/request_money_qr_state.dart';
import 'request_by_qr/screens/request_money_qr_screen.dart';

class RequestMoneyScreenStyle {
  final TextStyle titleTextStyle;
  final TextStyle listItemTextStyle;
  final Color backgroundColor;

  RequestMoneyScreenStyle({
    this.titleTextStyle,
    this.listItemTextStyle,
    this.backgroundColor,
  });

  factory RequestMoneyScreenStyle.fromOldTheme(AppThemeOld theme) {
    return RequestMoneyScreenStyle(
      titleTextStyle:
          theme.textStyles.m18.copyWith(color: theme.colors.darkShade),
      listItemTextStyle:
          theme.textStyles.r16.copyWith(color: theme.colors.darkShade),
      backgroundColor: theme.colors.lightShade,
    );
  }
}

class RequestMoneyScreen extends StatelessWidget {
  final RequestMoneyScreenStyle style =
      RequestMoneyScreenStyle.fromOldTheme(AppThemeOld.defaultTheme());

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestByQrCubit, RequestMoneyState>(
        builder: (context, state) {
      return Scaffold(
        appBar: _appBar(),
        body: SafeArea(
          child: Container(
            child: ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: <Widget>[
                _sendMoneyTile(
                    title: AppStrings.REQUEST_MONEY_BY_QR_CODE.tr(),
                    icon: IconsSVG.qr,
                    onPress: () {
                      Get.to(RequestMoneyByQrScreen(
                          context.read<RequestByQrCubit>()));
                    }),
                _sendMoneyTile(
                    title: AppStrings.REQUEST_FROM_CONTACT.tr(),
                    icon: IconsSVG.users,
                    onPress: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ContactListFlow(
                                      flowType: ContactFlowType.request)));
                    })
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _appBar() => BaseAppBar(
        titleString: AppStrings.REQUEST_MONEY.tr(),
        centerTitle: true,
        backgroundColor: Get.theme.colorScheme.background,
        titleColor: Get.theme.colorScheme.onBackground,
        backIconColor: Get.theme.colorScheme.onBackground,
      );

  Widget _roundIcon(BuildContext context, String iconPath, bool isEnable) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isEnable ?? true ? style.backgroundColor : Colors.red,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: SvgPicture.asset(iconPath),
    );
  }

  Widget _sendMoneyTile(
      {BuildContext context,
      String icon,
      String title,
      GestureTapCallback onPress,
      bool isEnable}) {
    return ListTile(
      enabled: isEnable ?? true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: _roundIcon(context, icon, isEnable),
      title: Text(title, style: style.listItemTextStyle),
      trailing: SvgPicture.asset(IconsSVG.arrowRightIOSStyle),
      onTap: () => isEnable ?? true ? onPress.call() : null,
    );
  }
}

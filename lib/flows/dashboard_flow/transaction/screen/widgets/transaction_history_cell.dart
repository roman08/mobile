import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../resources/icons/icons_svg.dart';
import '../../../../../resources/themes/need_to_refactor_and_remove/app_colors_old.dart';
import '../../../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';
import '../../../entities/transaction/account_entity.dart';
import '../../../entities/transaction/request_entity.dart';
import '../../../entities/transaction/request_enum.dart';

class _TransactionHistoryCellStyle {
  final TextStyle titleTextStyle;
  final TextStyle subtitleTextStyle;
  final TextStyle usernameInitialsStyle;
  final TextStyle amountGreenStyle;
  final TextStyle amountRedStyle;
  final TextStyle currencyStyle;
  final AppColorsOld colors;

  _TransactionHistoryCellStyle({
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.usernameInitialsStyle,
    this.amountGreenStyle,
    this.amountRedStyle,
    this.currencyStyle,
    this.colors,
  });

  factory _TransactionHistoryCellStyle.fromOldTheme(AppThemeOld theme) {
    return _TransactionHistoryCellStyle(
      titleTextStyle:
          theme.textStyles.m16.copyWith(color: theme.colors.darkShade),
      subtitleTextStyle:
          theme.textStyles.r12.copyWith(color: theme.colors.darkShade),
      usernameInitialsStyle:
          theme.textStyles.m16.copyWith(color: theme.colors.darkShade),
      amountGreenStyle:
          theme.textStyles.m16.copyWith(color: theme.colors.green),
      amountRedStyle:
          theme.textStyles.m16.copyWith(color: Get.theme.colorScheme.error),
      currencyStyle:
          theme.textStyles.r10.copyWith(color: theme.colors.darkShade),
      colors: theme.colors,
    );
  }
}

class TransactionHistoryCell extends StatelessWidget {
  TransactionHistoryCell(this._request);

  final RequestEntity _request;
  final _TransactionHistoryCellStyle _style =
      _TransactionHistoryCellStyle.fromOldTheme(AppThemeOld.defaultTheme());

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
            child: Row(children: <Widget>[
          Stack(
            children: <Widget>[
              _avatar(null, _getTitle()),
              Positioned.fill(
                  child: Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: SvgPicture.asset(
                              _transactionStatusImage(_request.status)))))
            ],
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    _request.description,
                    style: _style.subtitleTextStyle,
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
        ])),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                RichText(
                  text: _getAmount(),
                  overflow: TextOverflow.ellipsis,
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      _dateFormat(_request.createdAt),
                      style: _style.subtitleTextStyle,
                    ))
              ],
            ),
          ),
        )
      ],
    );
  }

  String _transactionStatusImage(RequestStatus status) {
    switch (status) {
      case RequestStatus.pending:
        return IconsSVG.pending;
      case RequestStatus.cancelled:
        return IconsSVG.failed;
      default:
        return "";
    }
  }

  String _getTitle() {
    String title;
    switch (_request.category) {
      case RequestCategory.add_fund:
        final account = _request.recipient?.account;
        if (account == null) {
          title = "";
        }
        title =
            '${account?.currencyCode} ${account?.typeName} *${account?.number?.substring((account?.number?.length ?? 4) - 4, account?.number?.length)}';
        break;
      case RequestCategory.withdraw:
        title = _request.sender?.profile?.firstName;
        break;
      case RequestCategory.send_money:
        title = _request.recipient?.profile?.firstName;
        break;
      case RequestCategory.request_money:
        title = _request.sender?.profile?.firstName;
        break;
      case RequestCategory.pay_bills:
        title = _request.sender?.profile?.companyName;
        break;
      default:
        title = "";
        break;
    }
    return title ?? "";
  }

  Widget _avatar(String photoUrl, String userName) {
    Widget child;
    if (_request.category == RequestCategory.add_fund) {
      child = SvgPicture.asset(
        IconsSVG.creditCard,
      );
    } else {
      if (photoUrl == null || photoUrl.isEmpty) {
        child = Icon(RequestEnums.requestPurposeToIcon(_request.purpose), size: 20,);
      } else {
        child = Image.network(photoUrl);
      }
    }
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
          color: _style.colors.extraLightShade, shape: BoxShape.circle),
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: child,
    );
  }

  InlineSpan _getAmount() {
    TextStyle amountTextStyle;
    String amount;
    if (_request.amount.contains("-")) {
      amountTextStyle = _style.amountRedStyle;
      amount = _request.amount.split('-').last;
    } else {
      amountTextStyle = _style.amountGreenStyle;
      amount = _request.amount;
    }
    AccountEntity account;
    switch (_request.category) {
      case RequestCategory.add_fund:
        account = _request.recipient?.account;
        break;
      case RequestCategory.withdraw:
        account = _request.sender?.account;
        break;
      case RequestCategory.send_money:
        account = _request.recipient?.account;
        break;
      case RequestCategory.request_money:
        account = _request.sender?.account;
        break;
      case RequestCategory.pay_bills:
        account = _request.sender?.account;
        break;
      default:
        break;
    }
    return TextSpan(
      text: NumberFormat.simpleCurrency(name: '').format(double.parse(amount)),
      style: amountTextStyle,
      children: <TextSpan>[
        TextSpan(
            text:
                "  ${_request.recipient != null ? _request.recipient?.account?.currencyCode : _request.sender?.account?.currencyCode}",
            style: _style.currencyStyle),
      ],
    );
  }

  String _dateFormat(DateTime date) {
    if (date == null) {
      return "";
    } else {
      return DateFormat('h:mm a, MMM d', 'en').format(date);
    }
  }
}

class GroupHeaderSectionStyle {
  final TextStyle letterStyle;

  GroupHeaderSectionStyle({this.letterStyle});

  factory GroupHeaderSectionStyle.fromOldTheme(AppThemeOld theme) {
    return GroupHeaderSectionStyle(
        letterStyle:
            theme.textStyles.m16.copyWith(color: theme.colors.darkShade));
  }
}

class GroupHeaderSection extends StatelessWidget {
  final GroupHeaderSectionStyle _style =
      GroupHeaderSectionStyle.fromOldTheme(AppThemeOld.defaultTheme());
  final String title;

  GroupHeaderSection({this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40,
        color: Colors.transparent,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 16, top: 8),
        child: Text(
          title,
          style: _style.letterStyle,
        ));
  }
}

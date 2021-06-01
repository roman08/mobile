import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../common/widgets/app_bars/base_app_bar.dart';
import '../../../../common/widgets/app_buttons/button.dart';
import '../../../../resources/icons/icons_svg.dart';
import '../../../../resources/strings/app_strings.dart';
import '../../../../resources/themes/need_to_refactor_and_remove/app_colors_old.dart';
import '../../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';
import '../../entities/transaction/request_entity.dart';
import '../../entities/transaction/request_enum.dart';

class _TransactionDetailsScreenStyle {
  final TextStyle titleTextStyle;
  final TextStyle subtitleTextStyle;
  final TextStyle informationTextStyle;
  final TextStyle textFormTextStyle;
  final TextStyle textFormSuffixTextStyle;
  final TextStyle usernameInitialsStyle;
  final AppColorsOld colors;

  _TransactionDetailsScreenStyle(
      {this.titleTextStyle,
      this.subtitleTextStyle,
      this.informationTextStyle,
      this.textFormTextStyle,
      this.textFormSuffixTextStyle,
      this.usernameInitialsStyle,
      this.colors});

  factory _TransactionDetailsScreenStyle.fromOldTheme(AppThemeOld theme) {
    return _TransactionDetailsScreenStyle(
      titleTextStyle:
          theme.textStyles.m14.copyWith(color: theme.colors.darkShade),
      subtitleTextStyle:
          theme.textStyles.r12.copyWith(color: theme.colors.boldShade),
      informationTextStyle:
          theme.textStyles.r12.copyWith(color: theme.colors.darkShade),
      textFormTextStyle:
          theme.textStyles.r16.copyWith(color: theme.colors.boldShade),
      textFormSuffixTextStyle:
          theme.textStyles.r16.copyWith(color: theme.colors.darkShade),
      usernameInitialsStyle:
          theme.textStyles.m14.copyWith(color: theme.colors.darkShade),
      colors: theme.colors,
    );
  }
}

class _CenterBottomFloatFloatingActionButtonLocation
    extends FloatingActionButtonLocation {
  const _CenterBottomFloatFloatingActionButtonLocation();

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    // Compute the x-axis offset.
    final double fabX = (scaffoldGeometry.scaffoldSize.width -
            scaffoldGeometry.floatingActionButtonSize.width) /
        2.0;

    // Compute the y-axis offset.
    final double contentBottom = scaffoldGeometry.contentBottom;
    final double fabHeight = scaffoldGeometry.floatingActionButtonSize.height;
    final double fabY = contentBottom - fabHeight;
    return Offset(fabX, fabY);
  }

  @override
  String toString() => 'FloatingActionButtonLocation.centerFloat';
}

class TransactionDetailsScreen extends StatelessWidget {
  TransactionDetailsScreen(this._request);

  final _TransactionDetailsScreenStyle style =
      _TransactionDetailsScreenStyle.fromOldTheme(AppThemeOld.defaultTheme());
  final ScreenshotController screenshotController = ScreenshotController();

  final RequestEntity _request;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      floatingActionButton: Container(
          color: const Color.fromARGB(190, 255, 255, 255),
          child: Button(
            onPressed: () => {_shareImage()},
            title: AppStrings.SHARE.tr(),
          ),
          padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 39.h)),
      floatingActionButtonLocation:
          const _CenterBottomFloatFloatingActionButtonLocation(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Screenshot(
            controller: screenshotController,
            child: Container(
              color: style.colors.white,
              child: Padding(
                  padding:
                      EdgeInsets.only(left: 16.w, right: 16.w, bottom: 100.h),
                  child: Column(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(top: 10.h),
                          child: _TransactionDetailHeader(_request)),
                      Padding(
                        padding: EdgeInsets.only(top: 19.h, bottom: 28.h),
                        child: _TransactionDetailForm(_request),
                      ),
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }

  String _dateFormat(DateTime date) {
    if (date == null) {
      return "";
    } else {
      return DateFormat('h:mm a, MMM d', 'en').format(date);
    }
  }

  BaseAppBar _appBar() => BaseAppBar(
          titleWidget: Column(
        children: <Widget>[
          Text(
            AppStrings.TRANSACTION_DETAILS.tr(),
            style: style.titleTextStyle,
          ),
          Text(
            _dateFormat(_request.createdAt),
            style: style.subtitleTextStyle,
          )
        ],
      ));

  void _shareImage() async {
    screenshotController.capture().then((File image) {
      Share.file('QrCode', '${DateTime.now().millisecondsSinceEpoch}.png',
          image.readAsBytesSync(), 'image/png');
    }).catchError((onError) {
      print(onError);
    });
  }
}

class _TransactionDetailHeaderStyle {
  final TextStyle statusTextStyle;
  final TextStyle amountGreenTextStyle;
  final TextStyle amountRedTextStyle;
  final TextStyle currencyTextStyle;
  final TextStyle categoryTextStyle;
  final AppColorsOld colors;

  _TransactionDetailHeaderStyle({
    this.statusTextStyle,
    this.amountGreenTextStyle,
    this.amountRedTextStyle,
    this.currencyTextStyle,
    this.categoryTextStyle,
    this.colors,
  });

  factory _TransactionDetailHeaderStyle.fromOldTheme(AppThemeOld theme) {
    return _TransactionDetailHeaderStyle(
      statusTextStyle:
          theme.textStyles.r16.copyWith(color: theme.colors.boldShade),
      amountGreenTextStyle:
          theme.textStyles.r32.copyWith(color: theme.colors.green),
      amountRedTextStyle:
          theme.textStyles.r32.copyWith(color: Get.theme.colorScheme.error),
      currencyTextStyle:
          theme.textStyles.r12.copyWith(color: theme.colors.darkShade),
      categoryTextStyle:
          theme.textStyles.r16.copyWith(color: theme.colors.darkShade),
      colors: theme.colors,
    );
  }
}

class _TransactionDetailHeader extends StatelessWidget {
  _TransactionDetailHeader(this._request);

  final RequestEntity _request;
  final _TransactionDetailHeaderStyle style =
      _TransactionDetailHeaderStyle.fromOldTheme(AppThemeOld.defaultTheme());

  @override
  Widget build(BuildContext context) {
    TextStyle amountTextStyle;
    String amount;
    if (_request.amount.contains("-")) {
      amountTextStyle = style.amountRedTextStyle;
      amount = _request.amount.split('-').last;
    } else {
      amountTextStyle = style.amountGreenTextStyle;
      amount = _request.amount;
    }
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 30.h, left: 16.w),
          child: Text(
            AppStrings.AMOUNT.tr(),
            style: style.currencyTextStyle,
          ),
        ),
        Padding(
            padding: EdgeInsets.only(top: 17.h),
            child: Container(
              child: Padding(
                  padding: EdgeInsets.only(top: 24.h, bottom: 16.h),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Flexible(
                                child: Text(
                              NumberFormat.simpleCurrency(name: '').format(double.parse(amount)),
                              style: amountTextStyle,
                              overflow: TextOverflow.ellipsis,
                            )),
                            Padding(
                              padding: EdgeInsets.only(left: 5.w, bottom: 5.h),
                              child: Text(
                                _request.recipient != null
                                    ? _request.recipient.account.currencyCode
                                    : _request.sender.account.currencyCode,
                                style: style.currencyTextStyle,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            _request.description ?? '',
                            style: style.categoryTextStyle,
                          ))
                    ],
                  )),
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: style.colors.extraLightShade,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(15.w))),
            )),
        Positioned.fill(
            child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(15.w)),
                        color: style.colors.thinShade),
                    child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 4.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(
                                    right: 8.w, top: 2.h, bottom: 2.h),
                                child: SvgPicture.asset(
                                    _transactionStatusImage(_request.status),
                                    width: 16.w)),
                            Text(
                              RequestEnums.requestStatusToString(
                                      _request.status)
                                  .tr(),
                              style: style.statusTextStyle,
                              textAlign: TextAlign.center,
                            )
                          ],
                        )))))
      ],
    );
  }

  String _transactionStatusImage(RequestStatus status) {
    switch (status) {
      case RequestStatus.pending:
        return IconsSVG.pending;
      case RequestStatus.executed:
        return IconsSVG.successful;
      case RequestStatus.cancelled:
        return IconsSVG.failed;
      default:
        return "";
    }
  }
}

class _TransactionDetailForm extends StatelessWidget {
  _TransactionDetailForm(this._request);

  final RequestEntity _request;
  final _TransactionDetailsScreenStyle style =
      _TransactionDetailsScreenStyle.fromOldTheme(AppThemeOld.defaultTheme());

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets;
    switch (_request.category) {
      case RequestCategory.add_fund:
        widgets = _addFunds(context);
        break;
      case RequestCategory.withdraw:
        widgets = _withdraw(context);
        break;
      case RequestCategory.send_money:
        widgets = _sendMoney(context);
        break;
      case RequestCategory.request_money:
        widgets = _requestMoney(context);
        break;
      case RequestCategory.pay_bills:
        widgets = _payBills(context);
        break;
      default:
        widgets = <Widget>[];
    }
    return Column(
      children: widgets,
    );
  }

  String _dateFormat(DateTime date) {
    if (date == null) {
      return "";
    } else {
      return DateFormat('h:mm a, d MMMM, y', 'en').format(date);
    }
  }

  String _walletFormat(String currencyCode, String number) {
    return '$currencyCode *${number.substring(number.length - 4, number.length)}';
  }

  List<Widget> _sendMoney(BuildContext context) {
    final widgets = <Widget>[];
    widgets.add(_textTextField(
        context, AppStrings.BENEFICIARY, _request.recipient.profile.firstName,
        photoUrl: _request.recipient.profile.avatar,
        name: _request.recipient.profile.firstName,
        withAvatar: true));
    widgets.add(_textTextField(context, AppStrings.BENEFICIARY_PHONE_NUMBER,
        _request.recipient.profile.phoneNumber));
    widgets.add(_textTextField(
        context,
        AppStrings.SOURCE_WALLET,
        _walletFormat(_request.sender.account.currencyCode,
            _request.sender.account.number)));
    widgets.addAll(_bottomForm(context));
    return widgets;
  }

  List<Widget> _requestMoney(BuildContext context) {
    final widgets = <Widget>[];
    widgets.add(_textTextField(
        context, AppStrings.SOURCE, _request.sender.profile.firstName,
        photoUrl: _request.sender.profile.avatar,
        name: _request.sender.profile.firstName,
        withAvatar: true));
    widgets.add(_textTextField(context, AppStrings.SOURCE_PHONE_NUMBER,
        _request.sender.profile.phoneNumber));
    widgets.add(_textTextField(
        context,
        AppStrings.RECIPIENT_WALLET,
        _walletFormat(_request.recipient.account.currencyCode,
            _request.recipient.account.number)));
    widgets.addAll(_bottomForm(context));
    return widgets;
  }

  List<Widget> _withdraw(BuildContext context) {
    final widgets = <Widget>[];
    widgets.add(_textTextField(
        context,
        AppStrings.SOURCE_WALLET,
        _walletFormat(_request.sender.account.currencyCode,
            _request.sender.account.number)));
    widgets.addAll(_bottomForm(context));
    return widgets;
  }

  List<Widget> _addFunds(BuildContext context) {
    final widgets = <Widget>[];
    widgets.add(_textTextField(
        context,
        AppStrings.RECIPIENT_WALLET,
        _walletFormat(_request.recipient.account.currencyCode,
            _request.recipient.account.number)));
    widgets.addAll(_bottomForm(context));
    return widgets;
  }

  List<Widget> _payBills(BuildContext context) {
    final widgets = <Widget>[];
    widgets.add(_textTextField(
        context, AppStrings.BILLER, _request.sender.profile.companyName,
        photoUrl: _request.sender.profile.avatar,
        name: _request.sender.profile.companyName,
        withAvatar: true));
    widgets.add(_textTextField(
        context, AppStrings.BILL_CATEGORY, _request.billCategory));
    widgets.add(_textTextField(
        context, AppStrings.BILL_NUMBER, _request.sender.profile.phoneNumber));
    widgets.add(_textTextField(
        context,
        AppStrings.SOURCE_WALLET,
        _walletFormat(_request.sender.account.currencyCode,
            _request.sender.account.number)));
    widgets.addAll(_bottomForm(context));
    return widgets;
  }

  List<Widget> _bottomForm(BuildContext context) {
    return [
      _textTextField(context, AppStrings.METHOD, /*_request.purpose*/ "N/A"),
      _textTextField(context, AppStrings.TRANSACTION_ID, "#${_request.id}"),
      _textTextField(
          context, AppStrings.DATE_CREATED, _dateFormat(_request.createdAt)),
      _textTextField(
        context,
        AppStrings.STATUS,
        RequestEnums.requestStatusToString(_request.status).tr(),
      )
    ];
  }

  Widget _textTextField(
      BuildContext context, String labelLocalisationCode, String suffix,
      {String photoUrl, String name, bool withAvatar = false}) {
    return Padding(
        padding: EdgeInsets.only(top: 14.h),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                    child: Text(
                  labelLocalisationCode.tr(),
                  style: style.textFormTextStyle,
                  overflow: TextOverflow.ellipsis,
                )),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _avatar(withAvatar, photoUrl, name),
                    Padding(
                        padding: EdgeInsets.only(left: 6.w),
                        child: Text(
                          suffix,
                          style: style.textFormSuffixTextStyle,
                        ))
                  ],
                )
              ],
            ),
            Padding(
                padding: EdgeInsets.only(top: 9.h),
                child: Divider(
                  color: style.colors.extraLightShade,
                  thickness: 1.h,
                ))
          ],
        ));
  }

  Widget _avatar(bool withAvatar, String photoUrl, String userName) {
    Widget child;
    BoxDecoration boxDecoration;
    if (withAvatar) {
      if (photoUrl == null || photoUrl.isEmpty) {
        boxDecoration = BoxDecoration(
            color: style.colors.extraLightShade, shape: BoxShape.circle);
        child = Text(
          userName != null ? userName[0] : '?',
          style: style.usernameInitialsStyle,
        );
      } else {
        boxDecoration = BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                fit: BoxFit.fill, image: NetworkImage(photoUrl)));
        child = const SizedBox();
      }
    } else {
      return const SizedBox();
    }
    return Container(
      width: 24,
      height: 24,
      decoration: boxDecoration,
      alignment: Alignment.center,
      child: child,
    );
  }
}

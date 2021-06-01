import 'dart:convert';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../app.dart';
import '../../../common/widgets/app_bars/base_app_bar.dart';
import '../../../common/widgets/info_widgets.dart';
import '../../../resources/icons/icons_svg.dart';
import '../../../resources/strings/app_strings.dart';
import '../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';
import '../request/request_by_qr/entity/transfer_qr_entity.dart';
import 'send_by_contact/contacts_list_flow.dart';
import 'send_by_qr/screens/send_by_qr_screen.dart';

class SendMoneyScreenStyle {
  final TextStyle titleTextStyle;
  final TextStyle listItemTextStyle;
  final Color backgroundColor;

  SendMoneyScreenStyle(
      {this.titleTextStyle, this.listItemTextStyle, this.backgroundColor});

  factory SendMoneyScreenStyle.fromOldTheme(AppThemeOld theme) {
    return SendMoneyScreenStyle(
      titleTextStyle:
          theme.textStyles.m18.copyWith(color: theme.colors.darkShade),
      listItemTextStyle:
          theme.textStyles.r16.copyWith(color: theme.colors.darkShade),
      backgroundColor: theme.colors.lightShade,
    );
  }
}

class SendMoneyScreen extends StatelessWidget {
  final SendMoneyScreenStyle style =
      SendMoneyScreenStyle.fromOldTheme(AppThemeOld.defaultTheme());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: SafeArea(
        child: Container(
          child: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: <Widget>[
              _sendMoneyTile(
                  title: AppStrings.SEND_MONEY_BY_QR_CODE.tr(),
                  icon: IconsSVG.qr,
                  onPress: () => scanQr(context)),
              _sendMoneyTile(
                  title: AppStrings.SEND_TO_CONTACT.tr(),
                  icon: IconsSVG.users,
                  onPress: () =>
                      Get.to(ContactListFlow(flowType: ContactFlowType.send)))
            ],
          ),
        ),
      ),
    );
  }

  Widget _appBar() => BaseAppBar(
        titleString: AppStrings.SEND_MONEY.tr(),
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

  Future scanQr(BuildContext context) async {
    try {
      const options = ScanOptions(
        strings: {
          "cancel": "Cancel",
          "flash_on": "Flash on",
          "flash_off": "Flash off",
        },
        restrictFormat: [BarcodeFormat.qr],
        autoEnableFlash: false,
        android: AndroidOptions(
          useAutoFocus: true,
        ),
      );

      final result = await BarcodeScanner.scan(options: options);

      handleScanQrResult(context, result.rawContent);
    } on PlatformException catch (e) {
      final result = ScanResult(
        type: ResultType.Error,
        format: BarcodeFormat.unknown,
      );

      if (e.code == BarcodeScanner.cameraAccessDenied) {
        logger.e('The user did not grant the camera permission!');
      } else {
        logger.e('Unknown error: $e');
      }
      handleScanQrResult(context, result.rawContent);
    }
  }

  void handleScanQrResult(BuildContext context, String scanResult) {
    try {
      logger.d('rawJson: $scanResult');
      final parsedJson = json.decode(scanResult);
      final TransferByQrEntity requestEntity =
          TransferByQrEntity.fromJson(parsedJson);
      logger.i(requestEntity.toString());
      Get.to(SendByQrScreen(sendByQREntity: requestEntity));
    } catch (error) {
      showToast(context, "Invalid QR");
      logger.e(error);
    }
  }
}

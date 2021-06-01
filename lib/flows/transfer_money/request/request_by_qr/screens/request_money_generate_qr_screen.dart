import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../../app.dart';
import '../../../../../common/widgets/app_bars/base_app_bar.dart';
import '../../../../../common/widgets/app_buttons/button.dart';
import '../../../../../resources/icons/icons_svg.dart';
import '../../../../../resources/strings/app_strings.dart';
import '../../../../../resources/themes/need_to_refactor_and_remove/app_colors_old.dart';
import '../../../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';
import '../entity/transfer_qr_entity.dart';

class _RequestMoneyGenerateQrScreenStyle {
  final TextStyle titleTextStyle;
  final AppColorsOld colors;
  final TextStyle qrTitleStyle;
  final TextStyle qrTitleAmountStyle;
  final TextStyle qrDescriptionStyle;
  final TextStyle qrDescriptionAmountStyle;

  _RequestMoneyGenerateQrScreenStyle({
    this.titleTextStyle,
    this.colors,
    this.qrTitleStyle,
    this.qrTitleAmountStyle,
    this.qrDescriptionStyle,
    this.qrDescriptionAmountStyle,
  });

  factory _RequestMoneyGenerateQrScreenStyle.fromOldTheme(AppThemeOld theme) {
    return _RequestMoneyGenerateQrScreenStyle(
      titleTextStyle:
          theme.textStyles.m18.copyWith(color: theme.colors.darkShade),
      colors: theme.colors,
      qrTitleStyle:
          theme.textStyles.r16.copyWith(color: theme.colors.darkShade),
      qrTitleAmountStyle:
          theme.textStyles.r16.copyWith(color: theme.colors.boldShade),
      qrDescriptionStyle:
          theme.textStyles.r12.copyWith(color: theme.colors.boldShade),
      qrDescriptionAmountStyle:
          theme.textStyles.r24.copyWith(color: theme.colors.darkShade),
    );
  }
}

class RequestMoneyGenerateQrScreen extends StatelessWidget {
  final TransferByQrEntity recipientQr;
  final _RequestMoneyGenerateQrScreenStyle style =
      _RequestMoneyGenerateQrScreenStyle.fromOldTheme(
          AppThemeOld.defaultTheme());

  RequestMoneyGenerateQrScreen(this.recipientQr);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(context),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.fromLTRB(75, 55, 75, 0),
                  child: QrImage(
                    data: _qrData(),
                    version: QrVersions.auto,
                    gapless: false,
                  )),
              _qrTitle(context),
              _qrDescription(context),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 39),
                      child: Button(
                        onPressed: () => _shareImage(),
                        title: AppStrings.SHARE.tr(),
                      )),
                ),
              ),
            ],
          ),
        ));
  }

  String _qrData() {
    return jsonEncode(recipientQr);
  }

  BaseAppBar _appBar(BuildContext context) => BaseAppBar(
        titleString: AppStrings.QR_CODE.tr(),
        centerTitle: true,
        backgroundColor: Get.theme.colorScheme.background,
        titleColor: Get.theme.colorScheme.onBackground,
        backIconColor: Get.theme.colorScheme.onBackground,
        actions: <Widget>[
          CupertinoButton(
            child: SvgPicture.asset(
              IconsSVG.download,
              color: Get.theme.colorScheme.primary,
            ),
            onPressed: () => _saveQr(context),
          ),
        ],
      );

  Widget _qrTitle(BuildContext context) {
    String title;
    TextStyle titleStyle;
    if (recipientQr.amount == null) {
      title = AppStrings.OPEN_REQUEST.tr();
      titleStyle = style.qrTitleStyle;
    } else {
      title = AppStrings.AMOUNT.tr();
      titleStyle = style.qrTitleAmountStyle;
    }
    return Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Text(
          title,
          style: titleStyle,
        ));
  }

  Widget _qrDescription(BuildContext context) {
    String description;
    TextStyle descriptionStyle;
    if (recipientQr.amount == null) {
      description = AppStrings.PAYERS_ENTER_AMOUNT.tr();
      descriptionStyle = style.qrDescriptionStyle;
    } else {
      description =
          "${recipientQr.amount} ${recipientQr.wallet.type.currencyCode}";
      descriptionStyle = style.qrDescriptionAmountStyle;
    }
    return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          description,
          style: descriptionStyle,
        ));
  }

  void _shareImage() async {
    final Uint8List imageInByte = await _toQrImageData();
    await Share.file(
        'Wallet QrCode',
        '${DateTime.now().millisecondsSinceEpoch}.png',
        imageInByte,
        'image/png');
  }

  Future<Uint8List> _toQrImageData() async {
    final pictureFromQrCode = await QrPainter(
            data: _qrData(),
            version: QrVersions.auto,
            gapless: true,
            color: Colors.black,
            emptyColor: Colors.white)
        .toImage(200);

    final PictureRecorder recorder = PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    canvas.drawColor(Colors.white, BlendMode.color);
    canvas.drawImage(pictureFromQrCode, const Offset(40.0, 50.0), Paint());
    final ui.Image image = await recorder.endRecording().toImage(290, 310);

    final a = await image.toByteData(format: ImageByteFormat.png);
    return a.buffer.asUint8List();
  }

  void _saveQr(BuildContext context) async {
    if (await requestPermissions()) {
      final Uint8List imageInByte = await _toQrImageData();
      final result = await ImageGallerySaver.saveImage(imageInByte);
      logger.d("file path = $result");

      showToast(context, AppStrings.SAVE_TO_GALLERY.tr());
    }
  }

  void showToast(BuildContext context, String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.grey.shade500,
        textColor: Colors.white,
        fontSize: 16.0.ssp);
  }

  Future<bool> requestPermissions() async {
    final permissionStatus = await Permission.storage.status;
    if (permissionStatus.isGranted) {
      return true;
    }
    if (permissionStatus.isUndetermined) {
      await Permission.storage.request();
      return permissionStatus == PermissionStatus.granted;
    }
    openAppSettings();
    return false;
  }
}

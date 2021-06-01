import 'package:Velmie/resources/colors/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../app.dart';
import '../../../../../../resources/icons/icons_svg.dart';
import '../../../../../../resources/strings/app_strings.dart';
import '../../../../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';
import '../../../../enities/common/common_preview_response.dart';
import '../../bloc(REFACTOR_AND_REMOVE)/send_by_qr_bloc.dart';

class AmountQRFieldStyle {
  final TextStyle feeTextStyle;
  final String lockIcon;

  AmountQRFieldStyle({this.feeTextStyle, this.lockIcon});

  factory AmountQRFieldStyle.fromOldTheme(AppThemeOld theme) {
    return AmountQRFieldStyle(
      feeTextStyle: theme.textStyles.r16.copyWith(color: AppColors.primary),
      lockIcon: IconsSVG.lock,
    );
  }
}

class AmountQRField extends StatefulWidget {
  final bool isEnable;
  final bool feeLoadInProgress;
  final ValueChanged<String> onAmountChange;
  final AmountQRFieldStyle style;
  final TextEditingController controller;
  final SendByQrBloc bloc;

  const AmountQRField({
    this.isEnable,
    this.feeLoadInProgress = false,
    this.style,
    this.onAmountChange,
    this.controller,
    this.bloc,
  });

  @override
  _AmountQRFieldState createState() => _AmountQRFieldState();
}

class _AmountQRFieldState extends State<AmountQRField> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CommonPreviewResponse>(
      stream: widget.bloc?.transactionPreviewObservable,
      builder: (context, snapshot) {
        return Stack(
          children: [
            TextFormField(
              controller: widget.controller,
              onChanged: (String amount) {
                logger.e(amount);
                widget.onAmountChange(amount);
              },
              enabled: widget.isEnable,
              decoration: InputDecoration(
                labelText: AppStrings.AMOUNT.tr(),
                suffix: _feeSection(snapshot),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            if (widget.feeLoadInProgress)
              Flex(
                direction: Axis.horizontal,
                children: [
                  Flexible(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        margin: const EdgeInsets.only(
                          top: 30,
                          right: 10,
                        ),
                        height: 20,
                        width: 20,
                        child: const CircularProgressIndicator(
                          strokeWidth: 1,
                          valueColor: AlwaysStoppedAnimation(AppColors.primary),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        );
      },
    );
  }

  Widget _feeSection(snapshot) {
    if (!snapshot.hasData || widget.feeLoadInProgress) {
      return Text('', style: widget.style.feeTextStyle);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
            '${AppStrings.FEE.tr()}: ${snapshot.data.details.isNotEmpty ? snapshot.data.details[0].amount : '0'} ${snapshot.data.incomingCurrencyCode}',
            style: widget.style.feeTextStyle),
        SizedBox(width: widget.isEnable ? 0 : 16),
        _iconLock(!widget.isEnable),
        SizedBox(width: widget.isEnable ? 0 : 8),
      ],
    );
  }

  Widget _iconLock(bool isShowLock) {
    return isShowLock ? SvgPicture.asset(widget.style.lockIcon) : const SizedBox();
  }
}

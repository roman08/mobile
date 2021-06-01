import 'package:Velmie/resources/colors/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../resources/icons/icons_svg.dart';
import '../../../../../../../resources/strings/app_strings.dart';
import '../../../../../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';
import '../../../../../enities/common/common_preview_response.dart';
import '../../../bloc/send_by_contact_bloc.dart';

class AmountFieldStyle {
  final TextStyle feeTextStyle;
  final String lockIcon;

  AmountFieldStyle({this.feeTextStyle, this.lockIcon});

  factory AmountFieldStyle.fromOldTheme(AppThemeOld theme) {
    return AmountFieldStyle(
      feeTextStyle: theme.textStyles.r16.copyWith(color: AppColors.primary),
      lockIcon: IconsSVG.lock,
    );
  }
}

class AmountContactField extends StatefulWidget {
  final bool isEnable;
  final bool feeLoadInProgress;
  final ValueChanged<String> onAmountChange;
  final AmountFieldStyle style;
  final TextEditingController controller;
  final SendByContactBloc bloc;

  const AmountContactField({
    this.isEnable,
    this.feeLoadInProgress = false,
    this.style,
    this.onAmountChange,
    this.controller,
    this.bloc,
  });

  @override
  _AmountContactFieldState createState() => _AmountContactFieldState();
}

class _AmountContactFieldState extends State<AmountContactField> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CommonPreviewResponse>(
      stream: widget.bloc.transactionPreviewObservable,
      builder: (context, snapshot) {
        return Stack(
          children: [
            TextFormField(
              controller: widget.controller,
              onChanged: (value) {
                widget.onAmountChange(value);
              },
              enabled: widget.isEnable,
              decoration: InputDecoration(
                labelText: AppStrings.AMOUNT.tr() + ' *',
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

    return Text(
      '${AppStrings.FEE.tr()}: ${snapshot.data.details.isNotEmpty ? snapshot.data.details[0].amount : '0'} ${snapshot.data.incomingCurrencyCode}',
      style: widget.style.feeTextStyle,
    );
  }
}

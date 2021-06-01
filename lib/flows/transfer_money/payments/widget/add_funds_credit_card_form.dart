import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../resources/strings/app_strings.dart';

class AddFundsCreditCardForm extends StatelessWidget {
  final TextEditingController _cardController = MaskedTextController(mask: '0000 0000 0000 0000');
  final TextEditingController _dateController = MaskedTextController(mask: '00/00');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          controller: _cardController,
          decoration: InputDecoration(
            labelText: AppStrings.CREDIT_CARD.tr(),
          ),
          keyboardType: TextInputType.phone,
          onChanged: (value) {
            //context.bloc<QrRequestFormBloc>().add(ChangeAmountEvent(value.isEmpty ? null : value.trim()));
          },
        ),
        Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: TextFormField(
            controller: _dateController,
            decoration: InputDecoration(
              labelText: AppStrings.EXPIRATION_DATE.tr(),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              //context.bloc<QrRequestFormBloc>().add(ChangeAmountEvent(value.isEmpty ? null : value.trim()));
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: TextFormField(
            decoration: InputDecoration(
              counterText: '',
              labelText: AppStrings.CVV.tr(),
            ),
            keyboardType: TextInputType.number,
            maxLength: 3,
            onChanged: (value) {
              //context.bloc<QrRequestFormBloc>().add(ChangeAmountEvent(value.isEmpty ? null : value.trim()));
            },
          ),
        ),
      ],
    );
  }
}

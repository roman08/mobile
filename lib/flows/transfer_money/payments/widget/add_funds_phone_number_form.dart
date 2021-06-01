import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../resources/strings/app_strings.dart';

class AddFundsPhoneNumberForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          decoration: InputDecoration(
            labelText: AppStrings.PHONE_NUMBER.tr(),
          ),
          keyboardType: TextInputType.phone,
          onChanged: (value) {
            //context.bloc<QrRequestFormBloc>().add(ChangeAmountEvent(value.isEmpty ? null : value.trim()));
          },
        ),
        Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: TextFormField(
            decoration: InputDecoration(
              labelText: AppStrings.AMOUNT.tr(),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              //context.bloc<QrRequestFormBloc>().add(ChangeAmountEvent(value.isEmpty ? null : value.trim()));
            },
          ),
        ),
      ],
    );
  }
}

import 'package:Velmie/resources/strings/app_strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../resources/colors/custom_color_scheme.dart';
import 'country_code.dart';
import 'custom_country_list.dart';

class PhoneField extends StatelessWidget {
  const PhoneField({
    @required this.onPhoneChanged,
    @required this.onCountryCodeChanged,
    @required this.initialCountryCode,
    this.onFieldSubmitted,
    this.focusNode,
    this.errorText,
    this.label,
  });

  final Function onPhoneChanged;
  final Function onCountryCodeChanged;
  final Function onFieldSubmitted;
  final String initialCountryCode;
  final FocusNode focusNode;
  final String errorText;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onPhoneChanged,
      textInputAction: TextInputAction.next,
      focusNode: focusNode,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        prefixIcon: CustomCountryList(
          isShowFlag: false,
          isShowTitle: false,
          isDownIcon: true,
          initialSelection: initialCountryCode,
          onChanged: (CountryCode code) => onCountryCodeChanged(code.dialCode),
        ),
        labelText: label ?? AppStrings.PHONE_NUMBER.tr(),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Get.theme.colorScheme.lightShade),
        ),
        errorText: errorText,
      ),
    );
  }
}

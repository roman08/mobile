import 'package:Velmie/resources/strings/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import '../../../../../resources/colors/custom_color_scheme.dart';

class EmailField extends StatelessWidget {
  const EmailField({
    @required this.onChanged,
    this.onFieldSubmitted,
    this.focusNode,
    this.errorText,
  });

  final Function onChanged;
  final Function onFieldSubmitted;
  final FocusNode focusNode;
  final String errorText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: AppStrings.EMAIL_ADDRESS.tr(),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Get.theme.colorScheme.lightShade),
        ),
        errorText: errorText,
      ),
      onFieldSubmitted: onFieldSubmitted,
      focusNode: focusNode,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
    );
  }
}

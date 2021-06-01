import 'package:Velmie/resources/strings/app_strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LoginField extends StatelessWidget {
  const LoginField({
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
        hintText: AppStrings.EMAIL_OR_PHONE.tr(),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelText: AppStrings.EMAIL_OR_PHONE.tr(),
        errorText: errorText,
      ),
      onFieldSubmitted: onFieldSubmitted,
      focusNode: focusNode,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
    );
  }
}

import 'package:Velmie/resources/strings/app_strings.dart';
import 'package:formz/formz.dart';
import 'package:easy_localization/easy_localization.dart';

class PasswordConfirmInput extends FormzInput<String, String> {
  const PasswordConfirmInput.pure() : super.pure('');
  const PasswordConfirmInput.dirty([String value = '']) : super.dirty(value);

  @override
  String validator(String value) {
    if (value.isEmpty) {
      return ErrorStrings.FIELD_SHOULD_NOT_BE_EMPTY.tr();
    }
    return null;
  }
}
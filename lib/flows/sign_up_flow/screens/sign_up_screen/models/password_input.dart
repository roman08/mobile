import 'package:Velmie/common/utils/validator.dart';
import 'package:Velmie/resources/strings/app_strings.dart';
import 'package:formz/formz.dart';
import 'package:easy_localization/easy_localization.dart';

class PasswordInput extends FormzInput<String, String> {
  const PasswordInput.pure() : super.pure('');
  const PasswordInput.dirty([String value = '']) : super.dirty(value);

  @override
  String validator(String value) {
    if (value.isEmpty) {
      return ErrorStrings.FIELD_SHOULD_NOT_BE_EMPTY.tr();
    }
    if (value.length < 8) {
      return ErrorStrings.SHOULD_BE_MINIMUM_EIGHT_CHARACTERS.tr();
    }
    // TODO(any): update validator class
    if (!Validator.passwordRegExp.hasMatch(value)) {
      return ErrorStrings.PASSWORD_REQUIREMENTS.tr();
    }
    return null;
  }
}
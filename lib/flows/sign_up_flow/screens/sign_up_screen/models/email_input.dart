import 'package:Velmie/common/utils/validator.dart';
import 'package:Velmie/resources/strings/app_strings.dart';
import 'package:formz/formz.dart';
import 'package:easy_localization/easy_localization.dart';

class EmailInput extends FormzInput<String, String> {
  const EmailInput.pure() : super.pure('');
  const EmailInput.dirty([String value = '']) : super.dirty(value);

  @override
  String validator(String value) {
    if (value.isEmpty) {
      return ErrorStrings.FIELD_SHOULD_NOT_BE_EMPTY.tr();
    }
    // TODO(any): update validator class
    if (!Validator.emailRegExp.hasMatch(value)) {
      return ErrorStrings.INVALID_EMAIL.tr();
    }
    return null;
  }
}
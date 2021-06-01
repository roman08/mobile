import 'package:Velmie/resources/strings/app_strings.dart';
import 'package:formz/formz.dart';
import 'package:easy_localization/easy_localization.dart';

class LoginInput extends FormzInput<String, String> {
  const LoginInput.pure() : super.pure('');
  const LoginInput.dirty([String value = '']) : super.dirty(value);

  @override
  String validator(String value) {
    if (value.isEmpty) {
      return ErrorStrings.FIELD_SHOULD_NOT_BE_EMPTY.tr();
    }
    return null;
  }
}
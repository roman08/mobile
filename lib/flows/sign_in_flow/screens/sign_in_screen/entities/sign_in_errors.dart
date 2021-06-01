import 'package:Velmie/common/utils/error_finder.dart';
import 'package:api_error_parser/api_error_parser.dart';

class SignInErrors {
  const SignInErrors({
    this.common,
    this.login,
    this.password,
  });

  final String common;
  final String login;
  final String password;

  static SignInErrors fromList(List<ParserMessageEntity<String>> errors) {
    return SignInErrors(
      common: ErrorFinder.findCommonErrorCode(errors),
      login: ErrorFinder.findErrorCodeByFieldName(errors, fieldName: 'email'),
      password: ErrorFinder.findErrorCodeByFieldName(errors, fieldName: 'password'),
    );
  }

  @override
  String toString() {
    return 'SignInErrors{common: $common, login: $login, password: $password}';
  }
}

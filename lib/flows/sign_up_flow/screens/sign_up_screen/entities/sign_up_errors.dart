import 'package:Velmie/common/utils/error_finder.dart';
import 'package:api_error_parser/api_error_parser.dart';

class SignUpErrors {
  const SignUpErrors({
    this.common,
    this.email,
    this.password,
    this.confirmPassword,
    this.phoneNumber,
    this.nickname,
  });

  final String common;
  final String email;
  final String password;
  final String confirmPassword;
  final String phoneNumber;
  final String nickname;

  static SignUpErrors fromList(List<ParserMessageEntity<String>> errors) {
    return SignUpErrors(
      common: ErrorFinder.findCommonErrorCode(errors),
      email: ErrorFinder.findErrorCodeByFieldName(errors, fieldName: 'email'),
      password: ErrorFinder.findErrorCodeByFieldName(errors, fieldName: 'password'),
      confirmPassword: ErrorFinder.findErrorCodeByFieldName(errors, fieldName: 'confirmPassword'),
      phoneNumber: ErrorFinder.findErrorCodeByFieldName(errors, fieldName: 'phoneNumber'),
      nickname: ErrorFinder.findErrorCodeByFieldName(errors, fieldName: 'nickname'),
    );
  }

  @override
  String toString() {
    return 'SignUpErrors{common: $common, email: $email, password: $password, confirmPassword: $confirmPassword, phoneNumber: $phoneNumber, nickname: $nickname}';
  }
}

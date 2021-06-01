import 'package:api_error_parser/api_error_parser.dart';

class ErrorFinder {
  const ErrorFinder();

  static String findCommonErrorCode(List<ParserMessageEntity<String>> errors) {
    if (errors == null) {
      return null;
    }
    return errors
        .firstWhere(
          (error) => error.target == 'common',
      orElse: () => null,
    )
        ?.code;
  }

  static String findErrorCodeByFieldName(
      List<ParserMessageEntity<String>> errors,
      {String fieldName}) {
    if (errors == null) {
      return null;
    }

    return errors
        .firstWhere(
          (error) =>
      error.target == 'field' &&
          error.source.field.split('.').last == fieldName,
      orElse: () => null,
    )
        ?.code;
  }
}

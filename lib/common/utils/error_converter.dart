import 'package:api_error_parser/api_error_parser.dart';

/// This class is needed for converting deprecated errors from backend to
/// relevant ErrorMessageEntity structure
///
/// Example
///
/// Error we get:
/// {
///   "title":"Unprocessable Entity",
///   "details":"`johndoe13376@mail.ru` already exists",
///   "code":"NO_EMAIL_EXISTS",
///   "source":"email",
///   "target":"field"
/// }
///
/// Error we want to return from api call method:
/// {
///   "code": "NO_EMAIL_EXISTS",
///   "target": "field",
///   "source": {
///     "field": "email"
///   },
///   "message": "`johndoe13376@mail.ru` already exists"
/// }
///
/// Example of usage inside API provider:
///
/// ....
///     } on DioError catch (error) {
///       logger.e(error.toString());
///       return ApiResponseEntity<UserEntity>(
///         null,
///         ErrorConverter.errorsFromInvalidJson(error.response.data),
///       );
///     }
/// ....
///
class ErrorConverter {
  static List<ErrorMessageEntity> errorsFromInvalidJson(Map<String, dynamic> json) {
    final errorsJson = json['errors'];
    List<ErrorMessageEntity> list;
    if (errorsJson != null) {
      list = (json['errors'] as List).map((error) {
        ErrorSourceEntity source;
        if (error['source'] != null && error['target'] == 'field') {
          source = ErrorSourceEntity(error['source']);
        }

        print(error['details']);

        return ErrorMessageEntity(
          error['code'],
          error['target'],
          error['details'],
          source: source,
        );
      }).toList();
    }
    return list;
  }
}
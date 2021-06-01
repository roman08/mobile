// Errors description for handling server errors. Used library standard: https://pub.dev/packages/api_error_parser
import '../strings/app_strings.dart';
import 'app_error_code.dart';
import 'app_error_field.dart';

class AppErrorTarget {
  static const common = "common";
  static const field = "field";
}

class AppError {
  static const errors = {
    AppErrorCode.required: ErrorStrings.FIELD_IS_REQUIRED,
    AppErrorCode.unauthorized: ErrorStrings.USER_NOT_FOUND,
    AppErrorCode.maintenance_mode: ErrorStrings.MAINTENANCE_MODE,
    AppErrorCode.users_user_is_blocked: ErrorStrings.BLOCKED_ACCOUNT,
    AppErrorCode.users_ip_is_blocked: ErrorStrings.BLOCKED_IP,
    AppErrorCode.users_invalid_username_or_password:
        ErrorStrings.INVALID_PASSWORD_OR_EMAIL,
    AppErrorCode.users_user_is_dormant: ErrorStrings.USERS_USER_IS_DORMANT,
    AppErrorCode.users_user_is_not_active:
        ErrorStrings.USERS_USER_IS_NOT_ACTIVE,
    AppErrorCode.users_user_is_pending: ErrorStrings.USERS_USER_IS_PENDING,
    AppErrorCode.limits_exceeded: ErrorStrings.LIMITS_EXCEEDED,
  };

  static const Map<String, Map<String, String>> fieldErrors = {
    AppErrorField.user_password: {
      AppErrorFieldCode.min: ErrorStrings.SHOULD_BE_MIN_CHARS,
      AppErrorFieldCode.max: ErrorStrings.SHOULD_BE_MAX_CHARS,

      /// TODO(Dmitry Kuzhelko): Need to discuss with backend team (https://velmie.atlassian.net/wiki/spaces/WAL/pages/44695727/Users+service)
      AppErrorFieldCode.invalid_field: ErrorStrings.PASSWORD_REQUIREMENTS,
    },
    AppErrorField.user_email: {
      AppErrorFieldCode.min: ErrorStrings.SHOULD_BE_MIN_CHARS,
      AppErrorFieldCode.max: ErrorStrings.SHOULD_BE_MAX_CHARS,

      /// TODO(Dmitry Kuzhelko): Need to discuss with backend team (https://velmie.atlassian.net/wiki/spaces/WAL/pages/44695727/Users+service)
      AppErrorFieldCode.invalid_field: ErrorStrings.WRONG_EMAIL_OR_PHONE_NUMBER,
    },
    AppErrorField.email: {
      AppErrorFieldCode.email_already_exists: ErrorStrings.EMAIL_ALREADY_EXISTS,
    },
    AppErrorField.phoneNumber: {
      AppErrorFieldCode.phone_already_exists: ErrorStrings.PHONE_ALREADY_EXISTS,
    }
  };
}

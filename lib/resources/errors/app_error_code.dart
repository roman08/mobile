class AppErrorCode {
  static const required = "REQUIRED";
  static const unauthorized = "UNAUTHORIZED";
  static const maintenance_mode = "MAINTENANCE_MODE";
  static const users_user_is_blocked = "USERS_USER_IS_BLOCKED";
  static const users_ip_is_blocked = "USERS_IP_IS_BLOCKED";
  static const users_invalid_username_or_password =
      "USERS_INVALID_USERNAME_OR_PASSWORD";
  static const users_user_is_dormant = "USERS_USER_IS_DORMANT";
  static const users_user_is_not_active = "USERS_USER_IS_NOT_ACTIVE";
  static const users_user_is_pending = "USERS_USER_IS_PENDING";
  static const limits_exceeded = 'LIMIT_EXCEEDED';
  static const invalid_wallet = 'INVALID_WALLET';
  static const insufficient_funds = 'INSUFFICIENT_FUNDS';
  static const deposit_not_allowed = 'DEPOSIT_NOT_ALLOWED';
  static const withdrawal_not_allowed = 'WITHDRAWAL_NOT_ALLOWED';
  static const invalid_account_owner = 'INVALID_ACCOUNT_OWNER';

  static const tfa_code_is_required = 'TFA_CODE_IS_REQUIRED';
  static const tfa_code_is_not_valid = 'TFA_CODE_IS_NOT_VALID';
  static const tfa_max_send_attempts_reached = 'TFA_MAX_SEND_ATTEMPTS_REACHED';
  static const your_phone_number_is_empty = 'YOUR_PHONE_NUMBER_IS_EMPTY';
  static const your_phone_number_is_not_valid =
      'YOUR_PHONE_NUMBER_IS_NOT_VALID';
}

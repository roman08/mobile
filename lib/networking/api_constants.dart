import 'environments.dart';

class PublicApi {
  static String downloadPublicFile(int id) {
    assert(id != null);

    /// TODO: Need to refactor by backend requirements
    return '${Environments.current.baseUrl}/files/public/v1/storage/bin/$id';
  }
}

class ApiConstants {
  static final ApiConstants _instance = ApiConstants._privateConstructor();

  ApiConstants._privateConstructor();

  factory ApiConstants() {
    return _instance;
  }

  final _Auth auth = _Auth();
  final _Password password = _Password();
  final _TransferMoney transferMoney = _TransferMoney();
  final _Notifications notifications = _Notifications();
  final _KYC kyc = _KYC();
  final _File file = _File();
  final _Verifications verifications = _Verifications();
  final _Currency currency = _Currency();
  final _Country country = _Country();
  final _Cards cards = _Cards();
}

class _Auth {
  String signInPath = '/users/public/v1/auth/signin';
  String signUpPath = '/users/public/v1/auth/signup';
  String getUserData = '/users/private/v1/auth/me';

  String updateUserData(String uid) => '/users/private/v1/users/$uid';
  String sentRegistrationSmsCode =
      '/users/private/v1/auth/generate-new-phone-code';
  String sentRegistrationEmailCode =
      '/users/private/v1/auth/generate-new-email-code';
  String checkRegistrationSmsCode = '/users/private/v1/auth/check-phone-code';
  String checkRegistrationEmailCode = '/users/private/v1/auth/check-email-code';
  String logOutPath = '/users/private/v1/auth/logout';
  String refresh = '/users/public/v1/auth/refresh';
  String registerDevice = '/private/v1/users/devices';
}

class _Password {
  String forgot = '/users/public/v1/auth/forgot-password';
  String checkCode = '/users/public/v1/auth/check-reset-password-code';
  String createNew = '/users/public/v1/auth/reset-password';
  String change = '/users/private/v1/auth/change_password';
}

class _TransferMoney {
  String contactsPath = '/users/private/v1/list-contacts';

  /// TBU
  String tbuPreview = '/accounts/private/v1/tbu-requests/preview';
  String tbu = '/accounts/private/v1/tbu-requests';

  /// TBU_REQUEST
  String tbuRequestPreview = '/accounts/private/v1/tbu-money-requests/preview';
  String tbuRequest = '/accounts/private/v1/tbu-money-requests';

  /// OWT
  String owtPreview = '/accounts/private/v1/owt-requests/preview';
  String owtRequest = '/accounts/private/v1/owt-requests';

  String walletsPath = '/accounts/private/v1/accounts';
  String moneyRequestPath = '/accounts/private/v1/money-requests';
  String transactionHistory = '/accounts/private/v1/user/transactions-history';

  String markRequestOld(int requestId) =>
      '/accounts/private/v1/money-requests/id/$requestId/mark-old';

  String accountsPath(String uid) => '/accounts/private/v1/users/$uid/accounts';

  String iwtInstructions(int accountId) =>
      '/accounts/private/v1/iwt-bank-accounts/$accountId/by-account-id';

  String iwtPdf({
    int accountId,
    int iwtId,
  }) =>
      '/accounts/private/v1/iwt-bank-accounts/$iwtId/pdf-for-account/$accountId';

  String getInvestmentAccountConditions = '/accounts/private/v1/investment-account-options';
  String requestInvestmentAccount = '/accounts/private/v1/investment-account-requests/create';
}

class _Notifications {
  String requestsPath = '/accounts/private/v1/money-requests/incoming';
  String allPath = '/messages/private/v1/notifications';

  String detailRequestPath(int id) => '/accounts/private/v1/money-requests/$id';

  String deleteRequestPath(int id) => '/messages/private/v1/notifications/$id';
}

class _Verifications {
  String generateNewPhoneCode =
      '/users/private/v1/auth/generate-new-phone-code';
  String checkPhoneCode = '/users/private/v1/auth/check-phone-code';
  String generateNewEmailCode =
      '/users/private/v1/auth/generate-new-email-code';
  String checkEmailCode = '/users/private/v1/auth/check-email-code';
}

class _KYC {
  String tiers = '/kyc/private/v1/tiers';
  String current = '/kyc/private/v1/tiers/current';

  String tier({int id}) => '/kyc/private/v1/tier/$id';

  String requirement({int id}) => '/kyc/private/v1/requirement/$id';
  String requests = '/kyc/private/v1/requests';
  String termsAndConditions = '/kyc/public/settings/terms-and-conditions';
  String signature = '/kyc/private/v1/signatory/terms-and-conditions';

  String cashOut = '/accounts/private/v1/user/cash-out/request';
  
}

class _File {
  String file({int id}) => '/files/private/v1/files/$id';

  String bin({int id}) => '/files/private/v1/storage/bin/$id';

  String publicBin({int id}) => '/files/public/v1/storage/bin/$id';

  String privateFile({String id}) => '/files/private/v1/files/private/$id';

  String publicFile({String id}) => '/files/private/v1/files/public/$id';

  String profileImage = '/files/private/v1/files/profile-image';

  String voucherImage({String id}) => '/files/private/v1/files/voucher/$id?type=voucher';
}

class _Currency {
  String currencies = '/currencies/private/v1/currencies';
}

class _Country {
  String countries = '/accounts/public/v1/countries';
}

class _Cards {
  String request = '/accounts/private/v1/card-requests/create';
  String activeRequest = '/accounts/private/v1/user/card-request/active-request';
  String settings = '/accounts/private/v1/user/card-request/settings';
}
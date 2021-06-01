import 'package:local_auth/local_auth.dart';
import 'package:meta/meta.dart';

import '../exception/security_exception.dart';
import '../utils/jwt_decoder.dart';

class Session {
  final int _idleMaxTime = const Duration(minutes: 5).inMilliseconds;

  String _accessToken;
  String _refreshToken;
  String uid;
  String passCode;
  BiometricType biometricType;
  int _lastInteractionTime;
  String _localeLanguageCode;

  String get accessToken => _accessToken;

  String get refreshToken => _refreshToken;

  bool get isValidSession =>
      accessToken != null && isValidRefreshToken() && isValidPassCode();

  bool get isBlocked =>
      isValidSession &&
      DateTime.now().millisecondsSinceEpoch - _lastInteractionTime >
          _idleMaxTime;

  String get localeLanguageCode => _localeLanguageCode;

  void init({@required String accessToken, @required String refreshToken}) {
    if (accessToken == null) {
      throw WrongSecurityDataException("accessToken");
    }
    if (refreshToken == null) {
      throw WrongSecurityDataException("refreshToken");
    }
    if (this.accessToken == null && this.refreshToken == null) {
      _accessToken = accessToken;
      _refreshToken = refreshToken;
      _lastInteractionTime = DateTime.now().millisecondsSinceEpoch;
    } else {
      throw MultipleSessionException();
    }
  }

  void update({@required String accessToken, @required String refreshToken}) {
    if (accessToken == null) {
      throw WrongSecurityDataException("accessToken");
    }
    if (refreshToken == null) {
      throw WrongSecurityDataException("refreshToken");
    }
    _accessToken = accessToken;
    _refreshToken = refreshToken;
  }

  void updateInteractionTime() {
    _lastInteractionTime = DateTime.now().millisecondsSinceEpoch;
  }

  void destroy() {
    _accessToken = null;
    _refreshToken = null;
    _lastInteractionTime = null;
    uid = null;
    biometricType = null;
  }

  Future<void> initFromStorage({
    @required String accessToken,
    @required String refreshToken,
    @required String uid,
    @required String passCode,
    @required bool hasBiometricRequest,
    @required BiometricType biometricType,
    @required String localeLanguageCode,
  }) async {
    _localeLanguageCode = localeLanguageCode;

    if (refreshToken == null) {
      return;
    }
    _refreshToken = refreshToken;
    _accessToken = accessToken;
    this.uid = uid;
    this.passCode = passCode;
    this.biometricType = biometricType;
    _lastInteractionTime = DateTime.now().millisecondsSinceEpoch;

    if (!isValidRefreshToken()) {
      destroy();
    }
  }

  bool isValidAccessToken() {
    try {
      final Map<String, dynamic> parsedAccessToken = parseJwt(this.accessToken);
      final expTime = parsedAccessToken["exp"];
      return expTime != null &&
          expTime > DateTime.now().millisecondsSinceEpoch / 1000;
    } catch (e) {
      return false;
    }
  }

  bool isValidRefreshToken() {
    try {
      final Map<String, dynamic> parsedRefreshToken =
          parseJwt(this.refreshToken);
      final expTime = parsedRefreshToken["exp"];
      return expTime != null &&
          expTime > DateTime.now().millisecondsSinceEpoch / 1000;
    } catch (e) {
      return false;
    }
  }

  bool isValidPassCode() {
    return passCode != null && passCode.isNotEmpty;
  }
}

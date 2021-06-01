import 'package:local_auth/local_auth.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../flows/sign_in_flow/entities/user.dart';
import '../cache/cache_repository.dart';
import '../secure_repository.dart';
import '../storage_constants.dart';
import '../utils/enum_extension.dart';
import 'session.dart';

class SessionRepository {
  SessionRepository(this._session, this._secureRepository, this._cacheRepository);

  final Session _session;
  final SecureRepository _secureRepository;
  final CacheRepository _cacheRepository;
  bool isTokenRefreshing = false;

  Session get sessionController => _session;

  String get accessToken => _session.accessToken;

  String get refreshToken => _session.refreshToken;

  String get uid => _session.uid;

  bool get isValidAccessToken => _session.isValidAccessToken();

  bool get isValidRefreshToken => _session.isValidRefreshToken();

  bool get isValidSession => _session.isValidSession;

  bool get isValidPassCode => _session.isValidPassCode();

  bool get isBlocked => _session.isBlocked;

  Future<String> get languageCode async => await _secureRepository.getFromStorage(StorageConstants.languageCode);

  BiometricType get biometricType => _session.biometricType;

  BehaviorSubject<UserData> get userData => _cacheRepository.userDataStream;

  String get localeLanguageCode => _session.localeLanguageCode;

  Future<void> initSession({String accessToken, String refreshToken}) async {
    _session.init(accessToken: accessToken, refreshToken: refreshToken);
    await _saveTokensToStorage(accessToken, refreshToken);
  }

  Future<void> initSessionFromStorage() async {
    final refreshToken = await _secureRepository.getFromStorage(StorageConstants.refreshTokenKey);
    final accessToken = await _secureRepository.getFromStorage(StorageConstants.accessTokenKey);
    final passCode = await _secureRepository.getFromStorage(StorageConstants.passCodeKey);
    final uid = await _secureRepository.getFromStorage(StorageConstants.uidKey);
    final localeLanguageCode = await _secureRepository.getFromStorage(StorageConstants.languageCode);
    final biometricTypeAsString = await _secureRepository.getFromStorage(StorageConstants.biometricType);
    _session.initFromStorage(
      accessToken: accessToken,
      refreshToken: refreshToken,
      passCode: passCode,
      uid: uid,
      biometricType: biometricTypeAsString?.parseBiometricType(),
      localeLanguageCode: localeLanguageCode,
    );
  }

  Future<void> updateSession({@required String accessToken, @required String refreshToken}) async {
    _session.update(accessToken: accessToken, refreshToken: refreshToken);
    await _saveTokensToStorage(accessToken, refreshToken);
  }

  Future<void> _saveTokensToStorage(String accessToken, String refreshToken) async {
    return _secureRepository.persistTokens(accessToken, refreshToken);
  }

  void setBiometricType(BiometricType type) {
    _session.biometricType = type;
    _secureRepository.addToStorage(StorageConstants.biometricType, type.toNameString());
  }

  void savePassCode(String passCode) {
    _session.passCode = passCode;
    _secureRepository.addToStorage(StorageConstants.passCodeKey, passCode);
  }

  bool equalPassCode(String passCode) {
    return _session.passCode == passCode;
  }

  void saveUid(String uid) {
    _session.uid = uid;
    _secureRepository.addToStorage(StorageConstants.uidKey, uid);
  }

  void updateLastInteractionTime() {
    _session.updateInteractionTime();
  }

  void cacheUserData(UserData userData) {
    _cacheRepository.addUserData(userData);
    saveUid(userData.uid);
  }

  void updateUserData({String firstName, String lastName, String nickname, int profileImageId}) {
    final UserData userInfo = userData.value;
    if (firstName != null) {
      userInfo.firstName = firstName;
    }
    if (lastName != null) {
      userInfo.lastName = lastName;
    }
    if (nickname != null) {
      userInfo.nickname = nickname;
    }
    if (profileImageId != null) {
      userInfo.profileImageId = profileImageId;
    }
    _cacheRepository.updateUserData(userInfo);
  }

  void setLanguageCode(String code) {
    _secureRepository.addToStorage(
      StorageConstants.languageCode,
      code,
    );
  }

  void destroySession() {
    _session.destroy();
    _secureRepository.clearSecureStorage();
    _cacheRepository.clearAll();
  }
}

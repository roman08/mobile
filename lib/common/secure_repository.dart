import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../app.dart';
import 'storage_constants.dart';

class SecureRepository extends FlutterSecureStorage {
  SecureRepository._privateConstructor();

  static final SecureRepository _instance =
      SecureRepository._privateConstructor();

  factory SecureRepository() {
    return _instance;
  }

  Future<void> addToStorage(String key, String value) async {
    await write(key: key, value: value).then((void data) {
      logger.i('$key: $value added to secure storage');
    });
  }

  /// Get value by key
  Future<String> getFromStorage(String key) async {
    return await read(key: key);
  }

  /// Get all values
  Future<Map<String, String>> getAllFromStorage() async {
    return await readAll();
  }

  /// Delete value by key
  Future<void> deleteFromStorage(String key) async {
    await delete(key: key).then((void data) {
      logger.i('$key deleted from secure storage');
    });
  }

  /// Delete all values from storage
  Future<bool> clearSecureStorage() async {
    return await deleteAll().then((void data) {
      logger.i('Secure storage has been cleared');
      return true;
    });
  }

  Future<bool> persistTokens(String accessToken, String refreshToken) async {
    return Future.wait([
      addToStorage(StorageConstants.accessTokenKey, accessToken),
      addToStorage(StorageConstants.refreshTokenKey, refreshToken),
    ]).then((value) => true);
  }
}

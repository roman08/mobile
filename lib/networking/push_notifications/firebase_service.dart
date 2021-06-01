import 'package:firebase_messaging/firebase_messaging.dart';

import '../../common/secure_repository.dart';
import '../../common/storage_constants.dart';

class FirebaseService {
  final FirebaseMessaging _firebaseMessaging;
  final SecureRepository _secureRepository;

  factory FirebaseService() => _instance;

  static final FirebaseService _instance = FirebaseService._privateConstructor(
    FirebaseMessaging(),
    SecureRepository(),
  );

  FirebaseService._privateConstructor(
    FirebaseMessaging firebaseMessaging,
    SecureRepository secureRepository,
  )   : _firebaseMessaging = firebaseMessaging,
        _secureRepository = secureRepository;

  void setup() {
    _firebaseMessaging.getToken().then((token) => _secureRepository
        .addToStorage(StorageConstants.firebaseTokenKey, token));
  }
}

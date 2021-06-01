import 'dart:async';
import 'dart:typed_data';

import 'package:Velmie/common/exception/security_exception.dart';
import 'package:Velmie/common/models/file_info.dart';
import 'package:Velmie/common/session/session_repository.dart';
import 'package:Velmie/flows/sign_in_flow/entities/credentials.dart';
import 'package:Velmie/flows/sign_in_flow/entities/user.dart';
import 'package:Velmie/networking/api_providers/auth_api_provider.dart';
import 'package:Velmie/networking/api_providers/file_provider.dart';
import 'package:api_error_parser/api_error_parser.dart';
import 'package:flutter/cupertino.dart';
import 'package:network_utils/network_bound_resource.dart';
import 'package:network_utils/resource.dart';

class UserRepository {
  final ApiParser<String> _apiParser;
  final AuthApiProvider _apiProvider;
  final FileProvider _fileProvider;
  final SessionRepository _sessionRepository;
  final AuthApiProvider _authApiProvider;

  UserRepository(
    this._apiParser,
    this._apiProvider,
    this._fileProvider,
    this._sessionRepository,
    this._authApiProvider,
  );

  Stream<Resource<bool, String>> signIn({
    @required String email,
    @required String password,
  }) {
    final networkClient = NetworkBoundResource<bool, CredentialsData, String>(
      _apiParser,
      saveCallResult: (item) async {
        try {
          await _sessionRepository.initSession(
            accessToken: item.accessToken,
            refreshToken: item.refreshToken,
          );
        } on MultipleSessionException catch (e) {
          _sessionRepository.destroySession();
          await _sessionRepository.initSession(
            accessToken: item.accessToken,
            refreshToken: item.refreshToken,
          );
        }

        return _sessionRepository.isValidSession;
      },
      createCall: () {
        return _apiProvider.signIn(email, password);
      },
      loadFromCache: () {
        return null;
      },
      shouldFetch: (data) {
        return true;
      },
    );
    return networkClient.asStream();
  }

  Stream<Resource<void, String>> signUp({
    @required String email,
    @required String password,
    @required String confirmPassword,
    @required String phoneNumber,
    @required bool isCorporate,
  }) {
    final networkClient = NetworkBoundResource<void, CredentialsData, String>(_apiParser, saveCallResult: (item) async {
      try {
        await _sessionRepository.initSession(
          accessToken: item.accessToken,
          refreshToken: item.refreshToken,
        );
      } on MultipleSessionException catch (e) {
        _sessionRepository.destroySession();
        await _sessionRepository.initSession(
          accessToken: item.accessToken,
          refreshToken: item.refreshToken,
        );
      }
    }, createCall: () {
      return _apiProvider.signUp(
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        phoneNumber: phoneNumber,
        isCorporate: isCorporate,
      );
    }, loadFromCache: () {
      return null;
    }, shouldFetch: (data) {
      return true;
    });
    return networkClient.asStream();
  }

  Stream<Resource<UserData, String>> getUserData() {
    final networkClient =
        NetworkBoundResource<UserData, UserData, String>(_apiParser, saveCallResult: (UserData item) async {
      _sessionRepository.cacheUserData(item);
      return item;
    }, createCall: () {
      return _apiProvider.getUserUser();
    }, loadFromCache: () {
      return null;
      //return _sessionRepository.userData;
    }, shouldFetch: (data) {
      return data == null;
    });
    return networkClient.asStream();
  }

  Stream<Resource<void, String>> updateUserData(
      {String firstName, String lastName, String middleName, String nickName}) {
    final networkClient = NetworkBoundResource<void, void, String>(_apiParser, saveCallResult: (void item) async {
      _sessionRepository.updateUserData(firstName: firstName, lastName: lastName, nickname: nickName);
      return item;
    }, createCall: () {
      return _apiProvider.updateUserData(firstName: firstName, lastName: lastName, nickName: nickName);
    }, loadFromCache: () {
      return null;
    }, shouldFetch: (data) {
      return true;
    });
    return networkClient.asStream();
  }

  Stream<Resource<void, String>> forgotPassword(String emailOrPhone) {
    final networkClient = NetworkBoundResource<void, void, String>(_apiParser, saveCallResult: (void item) async {
      return item;
    }, createCall: () {
      return _apiProvider.forgotPassword(emailOrPhone);
    }, loadFromCache: () {
      return null;
    }, shouldFetch: (data) {
      return true;
    });
    return networkClient.asStream();
  }

  Stream<Resource<void, String>> checkResetPasswordCode(String code) {
    final networkClient = NetworkBoundResource<void, void, String>(_apiParser, saveCallResult: (void item) async {
      return item;
    }, createCall: () {
      return _apiProvider.checkResetPasswordCode(code);
    }, loadFromCache: () {
      return null;
    }, shouldFetch: (data) {
      return true;
    });
    return networkClient.asStream();
  }

  Stream<Resource<void, String>> createNewPassword({String code, String password}) {
    final networkClient = NetworkBoundResource<void, void, String>(_apiParser, saveCallResult: (void item) async {
      return item;
    }, createCall: () {
      return _apiProvider.createNewPassword(code, password);
    }, loadFromCache: () {
      return null;
    }, shouldFetch: (data) {
      return true;
    });
    return networkClient.asStream();
  }

  Stream<Resource<void, String>> resetPassword(
      {String previousPassword, String proposedPassword, String confirmPassword}) {
    final networkClient = NetworkBoundResource<void, void, String>(_apiParser,
        saveCallResult: (void item) async => item,
        createCall: () => _apiProvider.resetPassword(previousPassword, proposedPassword, confirmPassword),
        loadFromCache: () => null,
        shouldFetch: (data) => true);
    return networkClient.asStream();
  }

  Stream<Resource<void, String>> sendRegistrationSmsCode() {
    final networkClient = NetworkBoundResource<void, void, String>(_apiParser, saveCallResult: (void item) async {
      return item;
    }, createCall: () {
      return _apiProvider.sendRegistrationSmsCode();
    }, loadFromCache: () {
      return null;
    }, shouldFetch: (data) {
      return true;
    });
    return networkClient.asStream();
  }

  Stream<Resource<void, String>> sendRegistrationEmailCode() {
    final networkClient = NetworkBoundResource<void, void, String>(_apiParser, saveCallResult: (void item) async {
      return item;
    }, createCall: () {
      return _apiProvider.sendRegistrationEmailCode();
    }, loadFromCache: () {
      return null;
    }, shouldFetch: (data) {
      return true;
    });
    return networkClient.asStream();
  }

  Stream<Resource<void, String>> checkRegistrationSmsCode(String code) {
    final networkClient = NetworkBoundResource<void, void, String>(_apiParser, saveCallResult: (void item) async {
      return item;
    }, createCall: () {
      return _apiProvider.checkRegistrationSmsCode(code);
    }, loadFromCache: () {
      return null;
    }, shouldFetch: (data) {
      return true;
    });
    return networkClient.asStream();
  }

  Stream<Resource<void, String>> checkRegistrationEmailCode(String code) {
    final networkClient = NetworkBoundResource<void, void, String>(_apiParser, saveCallResult: (void item) async {
      return item;
    }, createCall: () {
      return _apiProvider.checkRegistrationEmailCode(code);
    }, loadFromCache: () {
      return null;
    }, shouldFetch: (data) {
      return true;
    });
    return networkClient.asStream();
  }

  Stream<Resource<void, String>> logOut() {
    final networkClient = NetworkBoundResource<void, void, String>(
      _apiParser,
      saveCallResult: (void item) async {
        return item;
      },
      createCall: () {
        return _apiProvider.logout();
      },
      loadFromCache: () {
        return null;
      },
      shouldFetch: (data) {
        return true;
      },
    );
    return networkClient.asStream();
  }

  Stream<Resource<void, String>> uploadAvatar(String path) {
    final networkClient = NetworkBoundResource<void, FileInfo, String>(
      _apiParser,
      saveCallResult: (FileInfo item) async {
        _sessionRepository.updateUserData(profileImageId: item.id);
        return item;
      },
      createCall: () {
        return _fileProvider.uploadProfileImage(path: path);
      },
      loadFromCache: () {
        return null;
      },
      shouldFetch: (data) {
        return true;
      },
    );
    return networkClient.asStream();
  }

  Stream<Resource<void, String>> uploadVaucher(String path)  {
     

    final networkClient = NetworkBoundResource<void, FileInfo, String>(
      _apiParser,
      saveCallResult: (FileInfo item) async {
        // _sessionRepository.updateUserData(profileImageId: item.id);
        return;
      },
      createCall: ()async {
        final user = await _authApiProvider.getUserUser();
        return _fileProvider.uploadVoucher(path: path,uid: user.data.uid );
      },
      loadFromCache: () {
        return null;
      },
      shouldFetch: (data) {
        return true;
      },
    );
    return networkClient.asStream();
  }


  // cash-out
  Stream<Resource<void, String>> uploadCashOut({String bankName, String accountNumber, String type, String referencesAdditional, String numberRef})  {

    
    final networkClient = NetworkBoundResource<void, void, String>(_apiParser, saveCallResult: (void item) async {
     
      return;
    }, createCall: () async {
      final user = await _authApiProvider.getUserUser();
      return _fileProvider.cashOutUpload( 
        bankName:bankName,
        accountNumber:accountNumber,
        type:type,
        referencesAdditional:referencesAdditional,
        uid: user.data.uid,
        numberRef:numberRef);
    }, loadFromCache: () {
      return null;
    }, shouldFetch: (data) {
      return true;
    });
    return networkClient.asStream();



    // final networkClient = NetworkBoundResource<void, FileInfo, String>(
    //   _apiParser,
    //   saveCallResult: (FileInfo item) async {
    //     // _sessionRepository.updateUserData(profileImageId: item.id);
    //     return;
    //   },
    //   createCall: ()async {
    //     final user = await _authApiProvider.getUserUser();
    //     return _fileProvider.cashOutUpload(path: path,uid: user.data.uid );
    //   },
    //   loadFromCache: () {
    //     return null;
    //   },
    //   shouldFetch: (data) {
    //     return true;
    //   },
    // );
    // return networkClient.asStream();
  }
  Future<Uint8List> downloadAvatar(int id) async {
    if (id != null) {
      final list = await _fileProvider.getBin(id: id);
      return Uint8List.fromList(list);
    } else {
      return Uint8List(0);
    }
  }
}

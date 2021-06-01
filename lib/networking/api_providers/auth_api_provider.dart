import 'dart:io';

import 'package:Velmie/common/utils/error_converter.dart';
import 'package:api_error_parser/api_error_parser.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_udid/flutter_udid.dart';

import '../../app.dart';
import '../../common/secure_repository.dart';
import '../../common/session/session_repository.dart';
import '../../common/storage_constants.dart';
import '../../flows/dashboard_flow/more/profile/change_password/entities/reset_password.dart';
import '../../flows/forgot_password_flow/entities/create_new_password.dart';
import '../../flows/forgot_password_flow/entities/forgot_password.dart';
import '../../flows/forgot_password_flow/entities/password_verify_code.dart';
import '../../flows/sign_in_flow/entities/credentials.dart';
import '../../flows/sign_in_flow/entities/sign_in_request.dart';
import '../../flows/sign_in_flow/entities/user.dart';
import '../../flows/sign_up_flow/entities/device.dart';
import '../../flows/sign_up_flow/entities/registration_verify_code.dart';
import '../../flows/sign_up_flow/entities/sign_up_request.dart';
import '../api_constants.dart';
import '../network_client.dart';

class AuthApiProvider {
  AuthApiProvider(this._sessionRepository, this._networkClient);

  final SessionRepository _sessionRepository;
  final NetworkClient _networkClient;

  final ApiConstants _apiConstants = ApiConstants();
  final SecureRepository _secureRepository = SecureRepository();

  Future<ApiResponseEntity<CredentialsData>> signIn(String email, String password) async {
    try {
      final String firebaseToken = await FirebaseMessaging().getToken();
      final String osType = Platform.isAndroid ? "android" : "ios";
      final String deviceId = await FlutterUdid.udid;
      final Device device = Device(deviceId: deviceId, osType: osType, pushToken: firebaseToken);

      // await _networkClient.dio.post(_apiConstants.auth.registerDevice, data: device);

      final SignInData signInData = SignInData(device: device, email: email, password: password);
      final SignInRequest requestModel = SignInRequest(data: signInData);

      _networkClient.disableRefreshToken();
      final Response response = await _networkClient.dio.post(_apiConstants.auth.signInPath, data: requestModel);

      return ApiResponseEntity<CredentialsData>.fromJson(
          response.data as Map<String, dynamic>, CredentialsData.fromJson);
    } on DioError catch (error) {
      logger.e(error.toString());
      return ApiResponseEntity<CredentialsData>(
        null,
        ErrorConverter.errorsFromInvalidJson(error.response.data),
      );
    }
  }

  Future<ApiResponseEntity<CredentialsData>> signUp({
    String email,
    String password,
    String confirmPassword,
    String phoneNumber,
    bool isCorporate,
  }) async {
    try {
      final String firebaseToken = await _secureRepository.getFromStorage(StorageConstants.firebaseTokenKey);
      final String osType = Platform.isAndroid ? "android" : "ios";
      final String deviceId = await FlutterUdid.udid;
      final Device device = Device(
        deviceId: deviceId,
        osType: osType,
        pushToken: firebaseToken,
      );
      final SignUpData signUpData = SignUpData(
        device: device,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        phoneNumber: phoneNumber,
        isCorporate: isCorporate,
        // TODO: Hardcoded at now, need to refactor when backend be ready
        roleName: 'client',
      );

      _networkClient.disableRefreshToken();
      final Response response = await _networkClient.dio.post(
        _apiConstants.auth.signUpPath,
        data: signUpData.toJson(),
      );

      // TODO(anybody): remove this kludge in the future when credentials can be retrieved via sign up
      // Sign up doesn't return bearer token so there is another one request
      // that retrieves tokens and doesn't break surrounding logic
      _networkClient.disableRefreshToken();
      final SignInData signInData = SignInData(device: device, email: email, password: password);
      final SignInRequest signInRequestModel = SignInRequest(data: signInData);
      final Response signInResponse = await _networkClient.dio.post(
        _apiConstants.auth.signInPath,
        data: signInRequestModel,
      );

      return ApiResponseEntity<CredentialsData>.fromJson(
        signInResponse.data as Map<String, dynamic>,
        CredentialsData.fromJson,
      );
    } on DioError catch (error) {
      logger.e(error.toString());
      return ApiResponseEntity<CredentialsData>(
        null,
        ErrorConverter.errorsFromInvalidJson(error.response.data),
      );
    }
  }

  Future<ApiResponseEntity<UserData>> getUserUser() async {
    try {
      final Response response = await _networkClient.dio.get(_apiConstants.auth.getUserData);
      return ApiResponseEntity<UserData>.fromJson(response.data as Map<String, dynamic>, UserData.fromJson);
    } on DioError catch (error) {
      logger.e(error.toString());
      return ApiResponseEntity<UserData>.fromJson(error.response.data as Map<String, dynamic>, null);
    }
  }

  Future<ApiResponseEntity<void>> updateUserData({
    String firstName,
    String lastName,
    String nickName,
  }) async {
    try {
      await _networkClient.dio.patch(
        _apiConstants.auth.updateUserData(_sessionRepository.uid),
        data: {
          if (firstName != null) 'firstName': firstName,
          if (lastName != null) 'lastName': lastName,
          if (nickName != null) 'nickname': nickName,
        },
      );
      return ApiResponseEntity(null, null);
    } on DioError catch (error) {
      logger.e(error.toString());
      return ApiResponseEntity<void>(
        null,
        ErrorConverter.errorsFromInvalidJson(error.response.data),
      );
    }
  }

  Future<ApiResponseEntity<void>> sendRegistrationSmsCode() async {
    try {
      await _networkClient.dio.post(_apiConstants.auth.sentRegistrationSmsCode);
      return ApiResponseEntity(null, null);
    } on DioError catch (error) {
      logger.e(error.toString());
      return ApiResponseEntity<void>(
        null,
        ErrorConverter.errorsFromInvalidJson(error.response.data),
      );
    }
  }

  Future<ApiResponseEntity<void>> sendRegistrationEmailCode() async {
    try {
      await _networkClient.dio.post(_apiConstants.auth.sentRegistrationEmailCode);
      return ApiResponseEntity(null, null);
    } on DioError catch (error) {
      logger.e(error.toString());
      return ApiResponseEntity<void>(
        null,
        ErrorConverter.errorsFromInvalidJson(error.response.data),
      );
    }
  }

  Future<ApiResponseEntity<void>> sendTbuSmsCode(String code) async {
    try {
      final VerifyCode requestModel = VerifyCode(code: code);
      await _networkClient.dio.put(_apiConstants.auth.checkRegistrationSmsCode, data: requestModel);
      return ApiResponseEntity(null, null);
    } on DioError catch (error) {
      logger.e(error.toString());
      return ApiResponseEntity<void>.fromJson(error.response.data as Map<String, dynamic>, null);
    }
  }

  Future<ApiResponseEntity<void>> checkRegistrationSmsCode(String code) async {
    try {
      final VerifyCode requestModel = VerifyCode(code: code);
      await _networkClient.dio.put(_apiConstants.auth.checkRegistrationSmsCode, data: requestModel);
      return ApiResponseEntity(null, null);
    } on DioError catch (error) {
      logger.e(error.toString());
      return ApiResponseEntity<void>.fromJson(error.response.data as Map<String, dynamic>, null);
    }
  }

  Future<ApiResponseEntity<void>> checkRegistrationEmailCode(String code) async {
    try {
      final VerifyCode requestModel = VerifyCode(code: code);
      await _networkClient.dio.put(_apiConstants.auth.checkRegistrationEmailCode, data: requestModel);
      return ApiResponseEntity(null, null);
    } on DioError catch (error) {
      logger.e(error.toString());
      return ApiResponseEntity<void>.fromJson(error.response.data as Map<String, dynamic>, null);
    }
  }

  Future<ApiResponseEntity<void>> forgotPassword(String emailOrPhone) async {
    try {
      final ForgotPassword requestModel = ForgotPassword(emailOrPhone: emailOrPhone);
      _networkClient.disableRefreshToken();
      await _networkClient.dio.post(_apiConstants.password.forgot, data: requestModel);
      return ApiResponseEntity(null, null);
    } on DioError catch (error) {
      logger.e(error.toString());
      return ApiResponseEntity<void>(null, ErrorConverter.errorsFromInvalidJson(error.response.data));
    }
  }

  Future<ApiResponseEntity<void>> checkResetPasswordCode(String code) async {
    try {
      final PasswordVerifyCode requestModel = PasswordVerifyCode(confirmationCode: code);
      _networkClient.disableRefreshToken();
      await _networkClient.dio.post(_apiConstants.password.checkCode, data: requestModel);
      return ApiResponseEntity(null, null);
    } on DioError catch (error) {
      logger.e(error.toString());
      return ApiResponseEntity<void>.fromJson(error.response.data as Map<String, dynamic>, null);
    }
  }

  Future<ApiResponseEntity<void>> createNewPassword(String code, String password) async {
    try {
      final CreateNewPassword requestModel = CreateNewPassword(confirmationCode: code, newPassword: password);
      _networkClient.disableRefreshToken();
      await _networkClient.dio.post(_apiConstants.password.createNew, data: requestModel);
      return ApiResponseEntity(null, null);
    } on DioError catch (error) {
      logger.e(error.toString());
      return ApiResponseEntity<void>.fromJson(error.response.data as Map<String, dynamic>, null);
    }
  }

  Future<ApiResponseEntity<void>> resetPassword(
      String previousPassword, String proposedPassword, String confirmPassword) async {
    try {
      final ResetPassword requestModel = ResetPassword(
          data: Data(
              previousPassword: previousPassword,
              proposedPassword: proposedPassword,
              confirmPassword: confirmPassword));
      await _networkClient.dio.post(_apiConstants.password.change, data: requestModel);
      return ApiResponseEntity(null, null);
    } on DioError catch (error) {
      logger.e(error.toString());
      return ApiResponseEntity<void>.fromJson(error.response.data as Map<String, dynamic>, null);
    }
  }

  Future<ApiResponseEntity<void>> logout() async {
    try {
      await _networkClient.dio.delete(_apiConstants.auth.logOutPath);
      return ApiResponseEntity(null, null);
    } on DioError catch (error) {
      logger.e(error.toString());
      return ApiResponseEntity<void>.fromJson(error.response.data as Map<String, dynamic>, null);
    }
  }
}

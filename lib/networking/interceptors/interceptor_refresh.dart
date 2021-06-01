import 'package:api_error_parser/api_error_parser.dart';
import 'package:dio/dio.dart';

import '../../common/session/cubit/session_cubit.dart';
import '../../common/session/cubit/session_state.dart';
import '../../common/session/session_repository.dart';
import '../../flows/sign_in_flow/entities/credentials.dart';
import '../api_constants.dart';
import '../environments.dart';

class RefreshInterceptor extends InterceptorsWrapper {
  RefreshInterceptor(this._sessionRepository, this._sessionCubit);

  final SessionRepository _sessionRepository;
  final SessionCubit _sessionCubit;
  final ApiConstants _apiConstants = ApiConstants();
  final _RefreshClient _refreshClient =
      _RefreshClient(Environments.current.baseUrl);

  bool _isLock = false;

  void lock() {
    _isLock = true;
  }

  void unlock() {
    _isLock = false;
  }

  @override
  Future onRequest(RequestOptions options) async {
    if (!_isLock) {
      while (_sessionRepository.isTokenRefreshing) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      if (!_sessionRepository.isValidAccessToken) {
        _sessionRepository.isTokenRefreshing = true;
        _refreshClient.refreshTokenHeader(
            _sessionRepository.accessToken, _sessionRepository.refreshToken);
        try {
          final Response response =
              await _refreshClient.dio.get(_apiConstants.auth.refresh);
          final apiResponse = ApiResponseEntity<CredentialsData>.fromJson(
              response.data as Map<String, dynamic>, CredentialsData.fromJson);
          _sessionRepository.updateSession(
              accessToken: apiResponse.data.accessToken,
              refreshToken: apiResponse.data.refreshToken);
          options.headers['authorization'] =
              'Bearer ${apiResponse.data.accessToken}';
          _sessionRepository.isTokenRefreshing = false;
        } on DioError catch (error) {
          if (error.response.statusCode == 401 &&
              _sessionCubit.state.runtimeType != LogOutSessionState) {
            _sessionCubit.logout();
          }
        }
      }
      options.headers['authorization'] =
          'Bearer ${_sessionRepository.accessToken}';
    }
    return options;
  }

  @override
  Future onResponse(Response response) async {
    unlock();
    return response;
  }

  @override
  Future onError(DioError err) async {
    unlock();
    return err;
  }
}

class _RefreshClient {
  _RefreshClient(String baseUrl) {
    _setupDioClient(baseUrl);
  }

  final Dio dio = Dio();

  final int connectTimeoutInMillis = 30 * 1000;
  final int sentTimeoutInMillis = 30 * 1000;
  final int receiveTimeoutInMillis = 30 * 1000;

  void _setupDioClient(String baseUrl) {
    dio.options.baseUrl = baseUrl;
    dio.options.headers[Headers.contentTypeHeader] = Headers.jsonContentType;

    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    _defaultTimeouts();
  }

  void _defaultTimeouts() {
    dio.options.connectTimeout = connectTimeoutInMillis;
    dio.options.sendTimeout = sentTimeoutInMillis;
    dio.options.receiveTimeout = receiveTimeoutInMillis;
  }

  void refreshTokenHeader(String accessToken, String refreshToken) {
    dio.options.headers['Authorization'] = 'Bearer $accessToken';
    dio.options.headers['X-Refresh-Token'] = '$refreshToken';
  }
}

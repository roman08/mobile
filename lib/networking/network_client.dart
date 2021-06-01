import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../common/session/cubit/session_cubit.dart';
import '../common/session/session_repository.dart';
import 'interceptors/interceptor_refresh.dart';

class NetworkClient {
  NetworkClient(String baseUrl, this._sessionRepository, this._sessionBloc) {
    _setupDioClient(baseUrl);
  }

  final SessionRepository _sessionRepository;
  final SessionCubit _sessionBloc;

  final Dio dio = Dio();

  final int connectTimeoutInMillis = 30 * 1000;
  final int sentTimeoutInMillis = 30 * 1000;
  final int receiveTimeoutInMillis = 30 * 1000;

  void _setupDioClient(String baseUrl) {
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.findProxy = (url) {
        return 'PROXY localhost:8888; DIRECT';
      };

      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => Platform.isAndroid;
    };
    dio.options.baseUrl = baseUrl;
    _defaultHeaders();
    _defaultInterceptors();
    _defaultTimeouts();
  }

  void _defaultHeaders() {
    dio.options.headers[Headers.contentTypeHeader] = Headers.jsonContentType;
  }

  void _defaultInterceptors() {
    dio.interceptors.add(RefreshInterceptor(_sessionRepository, _sessionBloc));
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }

  void _defaultTimeouts() {
    dio.options.connectTimeout = connectTimeoutInMillis;
    dio.options.sendTimeout = sentTimeoutInMillis;
    dio.options.receiveTimeout = receiveTimeoutInMillis;
  }

  void addHeader({@required String headerKey, @required String headerValue}) {
    dio.options.headers[headerKey] = headerValue;
  }

  void removeHeader(String headerKey) {
    dio.options.headers.remove(headerKey);
  }

  void clearHeaders() {
    dio.options.headers.clear();
  }

  void enableRefreshToken() {
    dio.interceptors.whereType<RefreshInterceptor>().single.unlock();
  }

  void disableRefreshToken() {
    dio.interceptors.whereType<RefreshInterceptor>().single.lock();
  }
}

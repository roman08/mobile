import 'package:Velmie/flows/in_app_notifications/entities/request_notifications_list.dart';
import 'package:api_error_parser/api_error_parser.dart';
import 'package:dio/dio.dart';

import '../../app.dart';
import '../../flows/in_app_notifications/entities/request_notification_details.dart';
import '../../flows/in_app_notifications/entities/sent_notification.dart';
import '../api_constants.dart';
import '../network_client.dart';

class NotificationsApiProvider {
  NotificationsApiProvider(this._networkClient);

  final NetworkClient _networkClient;

  final ApiConstants _apiConstants = ApiConstants();

  Future<ApiResponseEntity<RequestNotificationsList>>
      getRequestMoneyNotifications() async {
    try {
      final Map<String, dynamic> queryParameters = {};
      queryParameters.putIfAbsent("sort", () => "-createdAt");
      final Response response = await _networkClient.dio.get(
        _apiConstants.notifications.requestsPath,
        queryParameters: {
          'sort': '-createdAt',
          'filter[isNew]': true,
          'include': 'recipient',
        },
      );

      return ApiResponseEntity<RequestNotificationsList>(
          RequestNotificationsList.fromJson(response.data), null);
    } on DioError catch (error) {
      logger.e(error.toString());
      return ApiResponseEntity<RequestNotificationsList>.fromJson(
          error.response.data as Map<String, dynamic>, null);
    }
  }

  Future<ApiResponsePaginationEntity<SentNotification>>
      getNotifications() async {
    try {
      final Map<String, dynamic> queryParameters = {};
      queryParameters.putIfAbsent("sort", () => "-createdAt");
      final Response response = await _networkClient.dio.get(
          _apiConstants.notifications.allPath,
          queryParameters: queryParameters);
      return ApiResponsePaginationEntity<SentNotification>.fromJson(
          response.data as Map<String, dynamic>, SentNotification.fromJson);
    } on DioError catch (error) {
      logger.e(error.toString());
      return ApiResponsePaginationEntity<SentNotification>.fromJson(
          error.response.data as Map<String, dynamic>, null);
    }
  }

  Future<ApiResponseEntity<RequestNotificationDetails>> detailRequest(
      int requestId) async {
    try {
      final Response response = await _networkClient.dio
          .get(_apiConstants.notifications.detailRequestPath(requestId));
      return ApiResponseEntity<RequestNotificationDetails>.fromJson(
          response.data as Map<String, dynamic>,
          RequestNotificationDetails.fromJson);
    } on DioError catch (error) {
      logger.e(error.toString());
      return ApiResponseEntity<RequestNotificationDetails>.fromJson(
          error.response.data as Map<String, dynamic>, null);
    }
  }

  Future<ApiResponseEntity<void>> deleteRequest(int notificationId) async {
    try {
      await _networkClient.dio.put(
          _apiConstants.transferMoney.markRequestOld(notificationId));
      return ApiResponseEntity(null, null);
    } on DioError catch (error) {
      logger.e(error.toString());
      return ApiResponseEntity<void>.fromJson(
          error.response.data as Map<String, dynamic>, null);
    }
  }
}

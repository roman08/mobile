import 'package:Velmie/flows/in_app_notifications/entities/request_notifications_list.dart';
import 'package:api_error_parser/api_error_parser.dart';
import 'package:flutter/cupertino.dart';
import 'package:network_utils/network_bound_resource.dart';
import 'package:network_utils/resource.dart';

import '../../../app.dart';
import '../../../networking/api_providers/notifications_api_provider.dart';
import '../entities/request_notification_details.dart';
import '../entities/sent_notification.dart';

class NotificationsRepository {
    final NotificationsApiProvider _apiProvider;
    final ApiParser<String> _apiParser;

    NotificationsRepository(this._apiParser, this._apiProvider);

    Stream<Resource<RequestNotificationsList, String>> getRequestMoneyNotifications() {
        final networkClient = NetworkBoundResource<RequestNotificationsList, RequestNotificationsList, String>(_apiParser,
            saveCallResult: (RequestNotificationsList item) async {
                return item;
            },
            createCall: () {
                return _apiProvider.getRequestMoneyNotifications();
            },
            loadFromCache: () {
                return null;
            },
            shouldFetch: (data) {
                return true;
            }, paginationCall: (pagination) {
                logger.d("pagination = $pagination");
            });
        return networkClient.asStream();
    }


    Stream<Resource<List<SentNotification>, String>> getNotifications() {
        final networkClient = NetworkBoundResource<List<SentNotification>, List<SentNotification>, String>(_apiParser,
            saveCallResult: (List<SentNotification> item) async {
                return item;
            },
            createCall: () {
                return _apiProvider.getNotifications();
            },
            loadFromCache: () {
                return null;
            },
            shouldFetch: (data) {
                return true;
            }, paginationCall: (pagination) {
                logger.d("pagination = $pagination");
            });
        return networkClient.asStream();
    }

    Stream<Resource<RequestNotificationDetails, String>> detailRequest(int id) {
        final networkClient = NetworkBoundResource<RequestNotificationDetails, RequestNotificationDetails, String>(_apiParser,
            saveCallResult: (RequestNotificationDetails item) async {
                return item;
            },
            createCall: () {
                return _apiProvider.detailRequest(id);
            },
            loadFromCache: () {
                return null;
            },
            shouldFetch: (data) {
                return true;
            });
        return networkClient.asStream();
    }

    Stream<Resource<void, String>> deleteNotification({@required int id}) {
        final networkClient = NetworkBoundResource<void, void, String>(_apiParser,
            saveCallResult: (void item) async {
                return item;
            },
            createCall: () {
                return _apiProvider.deleteRequest(id);
            },
            loadFromCache: () {
                return null;
            },
            shouldFetch: (data) {
                return true;
            });
        return networkClient.asStream();
    }
}

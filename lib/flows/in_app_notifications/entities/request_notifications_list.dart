import 'package:Velmie/flows/in_app_notifications/entities/request_notification.dart';

class RequestNotificationsList {
  List<RequestNotificationEntity> notifications;

  RequestNotificationsList({this.notifications});

  RequestNotificationsList.fromJson(Map<String, dynamic> json) {
    final notifications = json['data'] as List<dynamic>;

    this.notifications =
        notifications.map((e) => RequestNotificationEntity.fromJson(e)).toList();
  }
}

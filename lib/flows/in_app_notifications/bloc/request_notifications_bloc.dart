import 'package:contacts_service/contacts_service.dart';
import 'package:network_utils/resource.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';

import '../entities/request_notification.dart';
import '../entities/request_notification_details.dart';
import '../repository/notifications_repository.dart';

class RequestNotificationsBloc {
  final NotificationsRepository repository;

  final BehaviorSubject<List<RequestNotificationEntity>> requestNotifications = BehaviorSubject();
  final BehaviorSubject<RequestNotificationDetails> detailsNotification = BehaviorSubject();

  // TODO: For prevent open detail transaction screen many times. Need to refactor to BLOC arcritecture
  final BehaviorSubject<bool> lock = BehaviorSubject.seeded(true);
  final BehaviorSubject<bool> isDeleteNotification = BehaviorSubject();
  final BehaviorSubject<bool> showLoading = BehaviorSubject();

  RequestNotificationsBloc(this.repository);

  void fetchRequestNotifications() async {
    await for (final resource in repository.getRequestMoneyNotifications()) {
      if (resource.status == Status.success) {
        final notifications = resource.data.notifications;

        if (await Permission.contacts.request().isGranted) {
          final contacts = await ContactsService.getContacts(withThumbnails: true, photoHighResolution: false);

          for (final notification in notifications) {
            final contact = contacts.firstWhere((e) {
              if (e.phones.isEmpty) {
                return false;
              }

              return e.phones.first.value.replaceAll(RegExp(r'\D'), '') ==
                  notification.phoneNumber.replaceAll(RegExp(r'\D'), '');
            }, orElse: () => null);
            if (contact != null) {
              notification.avatar = contact.avatar;
            }
          }
        }

        requestNotifications.add(notifications);
        showLoading.add(false);
        return;
      } else if (resource.status == Status.error) {
        showLoading.add(false);
        return;
      } else if (resource.status == Status.loading) {
        showLoading.add(true);
      }
    }
  }

  void fetchDetailNotification(int id) {
    repository.detailRequest(id).listen((resource) {
      switch (resource.status) {
        case Status.success:
          detailsNotification.add(resource.data);
          showLoading.add(false);
          break;
        case Status.loading:
          showLoading.add(true);
          break;
        case Status.error:
          showLoading.add(false);
          break;
      }
    });
  }

  void deleteNotification(int id) {
    repository.deleteNotification(id: id).listen((resource) {
      switch (resource.status) {
        case Status.success:
          requestNotifications.add(requestNotifications.value..removeWhere((element) => element.id == id));
          isDeleteNotification.add(true);
          break;
        case Status.error:
          // TODO: Handle this case.
          break;
        case Status.loading:
          // TODO: Handle this case.
          break;
      }
    });
  }

  void dispose() {
    detailsNotification.close();
    requestNotifications.close();
    showLoading.close();
  }
}

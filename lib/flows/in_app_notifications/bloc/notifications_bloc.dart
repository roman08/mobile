import 'package:collection/collection.dart';
import 'package:network_utils/resource.dart';
import 'package:rxdart/rxdart.dart';

import '../entities/sent_notification.dart';
import '../repository/notifications_repository.dart';
import '../screens/notifications_list/widgets/notifications_cell.dart';
import '../screens/notifications_list/widgets/notifications_date_cell.dart';

class NotificationsBloc {
    final NotificationsRepository repository;

    List<SentNotification> _notificationList = [];

    final BehaviorSubject<List<dynamic>> notificationListForms = BehaviorSubject();
    final BehaviorSubject<bool> showLoading = BehaviorSubject();

    NotificationsBloc(this.repository);

    void fetchNotifications() {
        repository.getNotifications().listen((resource) {
            switch (resource.status) {
                case Status.success:
                    _notificationList = resource.data;
                    _regenerateForms();
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

    void _regenerateForms() {
        final List<NotificationCellForm> notificationForms = _notificationList
            .map((SentNotification item) => NotificationCellForm(notification: item))
            .toList();

        final Map<String, List<NotificationCellForm>> groupedByDateList = groupBy<NotificationCellForm, String>(notificationForms, (form) => form.notification.createdDate);
        final keys = groupedByDateList.keys.toList();

        final forms = <dynamic>[];
        keys.forEach((key) {
            forms.add(NotificationsListSectionForm(title: key.toString()));
            forms.addAll(groupedByDateList[key]);
        });
        notificationListForms.add(forms);
    }

    void dispose() {
        notificationListForms.close();
        showLoading.close();
    }
}

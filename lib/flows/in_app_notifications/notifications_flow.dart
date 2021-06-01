import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'bloc/request_notifications_bloc.dart';
import 'repository/notifications_repository.dart';
import 'screens/notifications_list/notifications_list_screen.dart';

class NotificationsFlow extends StatefulWidget {
    @override
    _NotificationsFlowState createState() => _NotificationsFlowState();
}

class _NotificationsFlowState extends State<NotificationsFlow> {
    RequestNotificationsBloc _requestNotificationsBloc;

    @override
    void initState() {
        super.initState();
        _requestNotificationsBloc = RequestNotificationsBloc(
            context.repository<NotificationsRepository>(),
        );
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: MultiProvider(
                providers: [
                    Provider<RequestNotificationsBloc>(
                        create: (context) => _requestNotificationsBloc,
                        dispose: (context, bloc) => bloc.dispose(),
                    ),
                ],
                child: NotificationListScreen(),
            ),
        );
    }

}

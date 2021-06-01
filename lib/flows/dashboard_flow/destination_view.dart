import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../in_app_notifications/notifications_flow.dart';
import 'more/profile/screen/profile_screen.dart';
import 'payments/screen/payments_screen.dart';
import 'screens/overview/overview_screen.dart';
import 'transaction/screen/transaction_history_screen.dart';

enum Navigation { overview, payments, transactions, notifications, more }

class Destination {
  const Destination(this.title, this.icon, this.navigation);

  final String title;
  final String icon;
  final Navigation navigation;
}

class DestinationView extends StatefulWidget {
  const DestinationView({Key key, this.destination}) : super(key: key);

  final Destination destination;

  @override
  _DestinationViewState createState() => _DestinationViewState();
}

class _DestinationViewState extends State<DestinationView> {
  @override
  Widget build(BuildContext context) {
    switch (widget.destination.navigation) {
      case Navigation.payments:
        return PaymentsScreen();
      case Navigation.transactions:
        return TransactionHistoryScreen();
      case Navigation.notifications:
        return NotificationsFlow();
      case Navigation.more:
        return ProfileScreen();
      default:
        return const OverviewScreen();
    }
  }
}

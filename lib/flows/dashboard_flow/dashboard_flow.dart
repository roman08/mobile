import 'dart:io';

import 'package:Velmie/resources/colors/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../app.dart';
import '../../common/widgets/info_widgets.dart';
import '../../resources/icons/icons_svg.dart';
import '../../resources/strings/app_strings.dart';
import '../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';
import '../in_app_notifications/notifications_flow.dart';
import 'bloc/bottom_navigation/bottom_navigation_bloc.dart';
import 'destination_view.dart';

const List<Destination> _allDestinations = <Destination>[
  Destination(AppStrings.OVERVIEW_VIEW, IconsSVG.tabBarHome, Navigation.overview),
  // Destination(AppStrings.PAYMENTS, IconsSVG.tabBarPayments, Navigation.payments),
  Destination(AppStrings.TRANSACTIONS, IconsSVG.tabBarHistory, Navigation.transactions),
  Destination(AppStrings.NOTIFICATIONS, IconsSVG.tabBarBell, Navigation.notifications),
  Destination(AppStrings.MORE, IconsSVG.tabBarMore, Navigation.more)
];

class DashboardFlow extends StatelessWidget {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  Widget build(BuildContext context) {
    context.locale;

    handleNotifications(context);
    final AppThemeOld theme = Provider.of<AppThemeOld>(context);
    final itemTextSelectedStyle = theme.textStyles.m10.copyWith(color: AppColors.onPrimary);
    final itemTextStyle = theme.textStyles.m10.copyWith(color: theme.colors.boldShade);

    return BlocBuilder<BottomNavigationCubit, BottomNavigationState>(
      builder: (context, state) {
        return Scaffold(
            body: SafeArea(
              child: IndexedStack(
                index: state.index,
                children: _allDestinations.map<Widget>((destination) {
                  return DestinationView(destination: destination);
                }).toList(),
              ),
            ),
            bottomNavigationBar: CupertinoTabBar(
              backgroundColor: AppColors.primary,
              currentIndex: state.index,
              onTap: (int index) {
                context.read<BottomNavigationCubit>().navigateTo(Navigation.values[index]);
              },
              items: _allDestinations.map((Destination destination) {
                return BottomNavigationBarItem(
                  icon: SvgPicture.asset(destination.icon),
                  activeIcon: SvgPicture.asset(
                    destination.icon,
                    color: AppColors.onPrimary,
                  ),
                  title: Text(
                    destination.title.tr(),
                    style: state.navigation == destination.navigation ? itemTextSelectedStyle : itemTextStyle,
                  ),
                );
              }).toList(),
            ));
      },
    );
  }

  void handleNotifications(BuildContext context) {
    if (Platform.isIOS) {
      _firebaseMessaging.requestNotificationPermissions(const IosNotificationSettings());
    }

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        _parseNotification(context, message, true);
      },
      onLaunch: (Map<String, dynamic> message) async {
        _parseNotification(context, message, false);
      },
      onResume: (Map<String, dynamic> message) async {
        _parseNotification(context, message, false);
      },
    );
  }

  Future<void> _parseNotification(BuildContext context, Map<dynamic, dynamic> message, bool showDialog) async {
    logger.i(message);
    Map<dynamic, dynamic> notification;
    String type;
    // TODO: TMP, need to refactor after define firebase notification model
    if (Platform.isIOS) {
      notification = message['aps']['alert'];
      type = message['type'] ?? 'Unknown';
    } else {
      notification = message['notification'];
      type = message['data']['action'] ?? 'Unknown';
    }

    final String title = notification['title'] ?? 'Unknown';
    final String body = notification['body'] ?? 'Unknown';

    final onClickOpenAction = () {
      Get.back();
      setupNotificationsRouting(context, type);
    };

    if (showDialog) {
      showSelectDialog(context,
          titleText: title,
          bodyText: body,
          isDismissible: false,
          cancelButtonText: AppStrings.CLOSE.tr(),
          actionButtonText: AppStrings.OPEN.tr(),
          isHighlightAction: true,
          onActionPress: onClickOpenAction);
    } else {
      setupNotificationsRouting(context, type);
    }
  }

  // Navigate to screen by key from notification
  void setupNotificationsRouting(BuildContext context, String type) {
    // TODO: Need to refactor constants naming with backend team. "request_money" is tmp solution for demo build
    if (type == "request_money") {
      Get.to(NotificationsFlow());
    } else {
      logger.e(type);
      Get.to(NotificationsFlow());
    }
  }
}

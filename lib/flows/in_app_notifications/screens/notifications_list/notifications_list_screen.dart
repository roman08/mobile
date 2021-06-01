import 'dart:async';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../common/widgets/shimmering_effect/list_shimmering.dart';
import '../../../../resources/colors/custom_color_scheme.dart';
import '../../../../resources/icons/icons_svg.dart';
import '../../../../resources/strings/app_strings.dart';
import '../../../../resources/themes/app_text_theme.dart';
import '../../../../resources/themes/need_to_refactor_and_remove/app_colors_old.dart';
import '../../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';
import '../../../dashboard_flow/bloc/bottom_navigation/bottom_navigation_bloc.dart';
import '../../../dashboard_flow/destination_view.dart';
import '../../../transfer_money/send/send_by_request/entities/transfer_link_entity.dart';
import '../../bloc/request_notifications_bloc.dart';
import '../../entities/request_notification.dart';
import 'request_notifications_list_screen.dart';
import 'widgets/notifications_cell.dart';
import 'widgets/notifications_date_cell.dart';
import 'widgets/request_notification.dart';

class NotificationListScreenStyle {
  final TextStyle titleStyle;
  final TextStyle requestTitleTextStyle;
  final TextStyle requestCounterTextStyle;
  final TextStyle emptyTextStyle;
  final NotificationsListSectionStyle sectionStyle;
  final NotificationCellStyle cellStyle;
  final AppColorsOld colors;

  NotificationListScreenStyle(
      {this.titleStyle,
      this.requestTitleTextStyle,
      this.requestCounterTextStyle,
      this.emptyTextStyle,
      this.sectionStyle,
      this.cellStyle,
      this.colors});

  factory NotificationListScreenStyle.fromOldTheme(AppThemeOld theme) {
    return NotificationListScreenStyle(
        titleStyle:
            theme.textStyles.m18.copyWith(color: theme.colors.darkShade),
        requestTitleTextStyle:
            theme.textStyles.r16.copyWith(color: Colors.black),
        requestCounterTextStyle:
            theme.textStyles.m16.copyWith(color: Colors.white),
        emptyTextStyle: Get.textTheme.headline6Bold
            .copyWith(color: Get.theme.colorScheme.midShade),
        sectionStyle: NotificationsListSectionStyle.fromOldTheme(theme),
        cellStyle: NotificationCellStyle.fromOldTheme(theme),
        colors: theme.colors);
  }
}

class NotificationListScreen extends StatefulWidget {
  @override
  _NotificationListScreenState createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  RequestNotificationsBloc _requestNotificationsBloc;
  NotificationListScreenStyle _style;
  StreamSubscription _navigationSubscription;

  @override
  void initState() {
    super.initState();
    _style = NotificationListScreenStyle.fromOldTheme(
        Provider.of<AppThemeOld>(context, listen: false));
    _requestNotificationsBloc =
        Provider.of<RequestNotificationsBloc>(context, listen: false);

    _navigationSubscription =
        context.read<BottomNavigationCubit>().listen((value) {
      if (value.navigation == Navigation.notifications) {
        _requestNotificationsBloc.fetchRequestNotifications();
      }
    });
  }

  @override
  void dispose() {
    _navigationSubscription.cancel();
    super.dispose();
  }

  _onRefresh() {
    _requestNotificationsBloc.fetchRequestNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(context),
        body: SafeArea(
            child: CustomRefreshIndicator(

                /// A function that's called when the user has dragged the refresh indicator
                /// far enough to demonstrate that they want the app to refresh.
                /// Should return [Future].
                onRefresh: () => _onRefresh(),
                child: _body(context),

                /// Custom indicator builder function
                builder: (BuildContext context, Widget child,
                    IndicatorController controller) {
                  return AnimatedBuilder(
                    animation: controller,
                    builder: (BuildContext context, _) {
                      return Stack(
                        alignment: Alignment.topCenter,
                        children: <Widget>[
                          if (!controller.isIdle)
                            Positioned(
                              top: 12.0 * controller.value,
                              child: SizedBox(
                                height: 27,
                                width: 27,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.5,
                                  backgroundColor: _style.colors.lightShade,
                                  value: controller.isLoading
                                      ? null
                                      : controller.value.clamp(0.0, 1.0),
                                ),
                              ),
                            ),
                          Transform.translate(
                            offset: Offset(0, 70.0 * controller.value),
                            child: child,
                          ),
                        ],
                      );
                    },
                  );
                })));
  }

  Widget _appBar(BuildContext context) {
    return AppBar(
      title: Text(
        AppStrings.NOTIFICATIONS.tr(), 
        style: _style.titleStyle.copyWith(fontWeight: FontWeight.bold )
        ),
      centerTitle: true,
      // backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      bottom: PreferredSize(
          child: _divider(), preferredSize: const Size.fromHeight(1.0)),
    );
  }

  Widget _body(BuildContext context) {
    return StreamBuilder<bool>(
        stream: _requestNotificationsBloc.showLoading,
        builder: (context, snapshot) {
          final value = snapshot.data ?? false;
          final child = value ? ListShimmering() : _notificationsList(context);
          return AnimatedSwitcher(
              duration: const Duration(milliseconds: 400), child: child);
        });
  }

  Widget _sendMoneyRequestsBlock() {
    return StreamBuilder<List<dynamic>>(
        stream: _requestNotificationsBloc.requestNotifications,
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot.data.isNotEmpty) {

            return Column(
              children: <Widget>[
                InkWell(
                    onTap: () => Get.to(RequestNotificationListScreen(
                        _requestNotificationsBloc)),
                    child: Container(
                      height: 56,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(AppStrings.SEND_MONEY_REQUESTS.tr(),
                                  style: _style.requestTitleTextStyle),
                              _requestsCounter(snapshot.data)
                            ],
                          ),
                        ],
                      ),
                    )),
                _divider()
              ],
            );
          } else if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot.data.isEmpty) {
            return emptyScreen();
          } else {
                            
            return emptyScreen2();
            // return const SizedBox();
          }
        });
  }

  Widget _requestsCounter(List<dynamic> forms) {
    return Container(
        alignment: Alignment.center,
        width: 38,
        height: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Get.theme.colorScheme.error,
        ),
        child: Text(forms.length.toString(),
            style: _style.requestCounterTextStyle));
  }

  Widget _notificationsList(BuildContext context) {
    return StreamBuilder<List<RequestNotificationEntity>>(
        stream: _requestNotificationsBloc.requestNotifications,
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot.data.isNotEmpty) {
            return ListView.separated(
                itemCount: snapshot.data.length ?? 0,
                separatorBuilder: (BuildContext context, int index) {
                  if (snapshot.data[index] is NotificationsListSectionForm ||
                      snapshot.data[index + 1]
                          is NotificationsListSectionForm) {
                    return const SizedBox();
                  } else {
                    return Divider(
                        indent: 70,
                        height: 1,
                        thickness: 1,
                        color: _style.colors.extraLightShade);
                  }
                },
                itemBuilder: (context, index) {
                  final notification = snapshot.data[index];

                  return RequestNotification(
                    transfer: TransferByRequestEntity(
                      description: notification.description,
                      amount: notification.amount,
                      currencyCode: notification.currency,
                      phoneNumber: notification.phoneNumber,
                      moneyRequestId: notification.id,
                      username: notification.username,
                    ),
                    avatar: notification.avatar,
                    requestNotificationsBloc: _requestNotificationsBloc,
                  );
                });
          } else {
            return ListView.separated(
                itemCount: 1,
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(),
                itemBuilder: (context, index) => _sendMoneyRequestsBlock());
          }
        });
  }

  Widget emptyScreen() {
    return StreamBuilder<List<dynamic>>(
        stream: _requestNotificationsBloc.requestNotifications,
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot.data.isEmpty) {
            final AppBar appBar = _appBar(context);
            return Container(
                height: MediaQuery.of(context).size.height -
                    appBar.preferredSize.height -
                    MediaQuery.of(context).padding.top -
                    100,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        AppStrings.NO_NOTIFICATIONS.tr(),
                        style: _style.emptyTextStyle.copyWith(color: Colors.black),
                      ),
                    ]));
          } else {
            
            return const SizedBox();
          }
        });
  }

Widget emptyScreen2() {
       
            return Container(
              padding: EdgeInsets.only(top: 260.0),
              child: Center(
                    
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        
                        children: <Widget>[
                          Text(
                            AppStrings.NO_NOTIFICATIONS.tr(),
                            style: _style.emptyTextStyle.copyWith(color: Colors.black, ),
                          ),
                        ]),
              ),
            );
         
  }

  Widget _divider() =>
      Divider(height: 1, thickness: 1, color: _style.colors.primaryBlue);
}

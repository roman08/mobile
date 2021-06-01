import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common/widgets/app_bars/base_app_bar.dart';
import '../../../../common/widgets/shimmering_effect/list_shimmering.dart';
import '../../../../resources/strings/app_strings.dart';
import '../../../../resources/themes/need_to_refactor_and_remove/app_colors_old.dart';
import '../../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';
import '../../bloc/request_notifications_bloc.dart';
import '../../entities/request_notification.dart';
import 'widgets/request_notifications_cell.dart';

class RequestNotificationListScreenStyle {
  final TextStyle titleTextStyle;
  final RequestNotificationCellStyle requestCellStyle;
  final AppColorsOld colors;

  RequestNotificationListScreenStyle(
      {this.titleTextStyle, this.requestCellStyle, this.colors});

  factory RequestNotificationListScreenStyle.fromOldTheme(AppThemeOld theme) {
    return RequestNotificationListScreenStyle(
        titleTextStyle:
            theme.textStyles.m18.copyWith(color: theme.colors.darkShade),
        requestCellStyle: RequestNotificationCellStyle.fromOldTheme(theme),
        colors: theme.colors);
  }
}

class RequestNotificationListScreen extends StatefulWidget {
  final RequestNotificationsBloc bloc;

  const RequestNotificationListScreen(this.bloc);

  @override
  _RequestNotificationListScreenState createState() =>
      _RequestNotificationListScreenState();
}

class _RequestNotificationListScreenState
    extends State<RequestNotificationListScreen> {
  RequestNotificationListScreenStyle _style;

  @override
  void initState() {
    super.initState();
    _style = RequestNotificationListScreenStyle.fromOldTheme(
        Provider.of<AppThemeOld>(context, listen: false));
  }

  _onRefresh() {
    return widget.bloc.fetchRequestNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(),
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

  BaseAppBar _appBar() => BaseAppBar(
        titleString: AppStrings.SEND_MONEY_REQUESTS.tr(),
        bottom: PreferredSize(
            child: Divider(
              height: 1,
              thickness: 1,
              color: _style.colors.extraLightShade,
            ),
            preferredSize: const Size.fromHeight(0.0)),
      );

  Widget _body(BuildContext context) {
    return StreamBuilder<bool>(
        stream: widget.bloc.showLoading,
        builder: (context, snapshot) {
          final value = snapshot.data ?? false;
          final child =
              value ? ListShimmering() : _requestNotificationsList(context);
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: child,
          );
        });
  }

  Widget _requestNotificationsList(BuildContext context) {
    return StreamBuilder<List<RequestNotificationEntity>>(
        stream: widget.bloc.requestNotifications,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data.isNotEmpty) {
            return ListView.separated(
              itemCount: snapshot.data.length,
              separatorBuilder: (BuildContext context, int index) => _divider(),
              itemBuilder: (context, index) {
                if (index == snapshot.data.length - 1) {
                  // Add divider to last item
                  return Column(children: <Widget>[
                    RequestNotificationCell(
                        form: RequestNotificationCellForm(
                            notification: snapshot.data[index]),
                        style: _style.requestCellStyle,
                        bloc: widget.bloc),
                    _divider()
                  ]);
                } else {
                  return RequestNotificationCell(
                      form: RequestNotificationCellForm(
                          notification: snapshot.data[index]),
                      style: _style.requestCellStyle,
                      bloc: widget.bloc);
                }
              },
            );
          } else {
            return const SizedBox();
          }
        });
  }

  Widget _divider() => Divider(
      indent: 70,
      height: 1,
      thickness: 1,
      color: _style.colors.extraLightShade);
}

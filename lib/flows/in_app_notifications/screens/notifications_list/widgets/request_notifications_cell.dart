import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../app.dart';
import '../../../../../common/widgets/app_buttons/button.dart';
import '../../../../../common/widgets/info_widgets.dart';
import '../../../../../resources/icons/icons_svg.dart';
import '../../../../../resources/strings/app_strings.dart';
import '../../../../../resources/themes/need_to_refactor_and_remove/app_colors_old.dart';
import '../../../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';
import '../../../../transfer_money/send/send_by_request/entities/transfer_link_entity.dart';
import '../../../../transfer_money/send/send_by_request/screens/send_by_request_screen.dart';
import '../../../bloc/request_notifications_bloc.dart';
import '../../../entities/request_notification.dart';
import '../../../entities/request_notification_details.dart';

class RequestNotificationCellForm {
  final RequestNotificationEntity notification;

  RequestNotificationCellForm({this.notification});
}

class RequestNotificationCellStyle {
  final TextStyle defaultTextStyle;
  final TextStyle boldTextStyle;
  final TextStyle usernameInitialsStyle;
  final TextStyle buttonTextStyle;
  final AppColorsOld colors;

  RequestNotificationCellStyle(
      {this.defaultTextStyle,
      this.boldTextStyle,
      this.usernameInitialsStyle,
      this.buttonTextStyle,
      this.colors});

  factory RequestNotificationCellStyle.fromOldTheme(AppThemeOld theme) {
    return RequestNotificationCellStyle(
        defaultTextStyle:
            theme.textStyles.r12.copyWith(color: theme.colors.darkShade),
        boldTextStyle:
            theme.textStyles.m12.copyWith(color: theme.colors.darkShade),
        usernameInitialsStyle:
            theme.textStyles.m16.copyWith(color: theme.colors.darkShade),
        buttonTextStyle: theme.textStyles.m12.copyWith(color: Colors.white),
        colors: theme.colors);
  }
}

class RequestNotificationCell extends StatefulWidget {
  final RequestNotificationCellForm form;
  final RequestNotificationCellStyle style;
  final RequestNotificationsBloc bloc;

  const RequestNotificationCell({this.form, this.style, this.bloc});

  @override
  _RequestNotificationsCellState createState() =>
      _RequestNotificationsCellState();
}

class _RequestNotificationsCellState extends State<RequestNotificationCell> {
  @override
  void initState() {
    widget.bloc.detailsNotification.stream
        .listen((RequestNotificationDetails details) {
      logger.d(details?.toString());
      if (details != null && widget.bloc.lock.value) {
        final String username = details.recipient.getUsername();
        final String phoneNumber = details.recipient.phoneNumber;
        final String amount = details.amount;
        final String description = details.description;
        // final int moneyRequestId = widget.form.notification.payload.moneyRequestId;
        // final String currencyCode = widget.form.notification.payload.currency;
        final TransferByRequestEntity data = TransferByRequestEntity(
          username: username,
          phoneNumber: phoneNumber,
          amount: amount,
          description: description,
          // moneyRequestId: moneyRequestId,
          // currencyCode: currencyCode
        );
        widget.bloc.lock.add(false);
        Get.to(SendByRequestScreen(
            transferData: data, requestNotificationBloc: widget.bloc));
      }
    });

    widget.bloc.isDeleteNotification.stream.listen((bool isDeleted) {
      if (isDeleted) {
        widget.bloc.fetchRequestNotifications();
        widget.bloc.isDeleteNotification.add(false);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final titleText = RichText(
      maxLines: 2,
      softWrap: true,
      text: TextSpan(
        style: widget.style.defaultTextStyle,
        children: <TextSpan>[
          // TextSpan(text: '${widget.form.notification.payload.recipientFirstName} ', style: widget.style.boldTextStyle),
          TextSpan(text: 'requested '),
          // TextSpan(text: '${widget.form.notification.payload.amount} ${widget.form.notification.payload.currency} ', style: widget.style.boldTextStyle),
          TextSpan(text: 'from you'),
        ],
      ),
    );

    return Container(
      height: 56,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _avatar(context),
          const SizedBox(width: 14),
          Expanded(child: titleText),
          const SizedBox(width: 12),
          _sendMoneyButton(context),
          const SizedBox(width: 8),
          _closeButton(context)
        ],
      ),
    );
  }

  Widget _avatar(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
          color: widget.style.colors.extraLightShade, shape: BoxShape.circle),
      alignment: Alignment.center,
      margin: const EdgeInsets.only(left: 16),
      // child: Text(
      //     widget.form.notification.payload.recipientFirstName[0] ?? '?',
      //     style: widget.style.usernameInitialsStyle,
      // ),
    );
  }

  Widget _sendMoneyButton(BuildContext context) {
    return Container(
      height: 28,
      child: Button(
          title: AppStrings.SEND_MONEY.tr(),
          onPressed: () {
            widget.bloc.lock.add(true);
            // widget.bloc.fetchDetailNotification(widget.form.notification.payload.moneyRequestId);
          }),
    );
  }

  Widget _closeButton(BuildContext context) {
    return CupertinoButton(
        padding: const EdgeInsets.only(left: 12, right: 20),
        color: Colors.transparent,
        child: SvgPicture.asset(
          IconsSVG.cross,
          color: widget.style.colors.midShade,
        ),
        onPressed: () => _showRejectDialog(context));
  }

  void _showRejectDialog(BuildContext context) {
    final rejectRequestAction = () {
      widget.bloc.deleteNotification(widget.form.notification.id);
      Get.back();
    };

    showSelectDialog(context,
        titleText: AppStrings.DELETE_REQUEST.tr(),
        bodyText: AppStrings.DELETE_SEND_MONEY_REQUEST.tr(),
        isDismissible: true,
        cancelButtonText: AppStrings.CANCEL.tr(),
        isHighlightCancel: true,
        actionButtonColor: Get.theme.colorScheme.error,
        actionButtonText: AppStrings.DELETE.tr(),
        onActionPress: rejectRequestAction);
  }
}

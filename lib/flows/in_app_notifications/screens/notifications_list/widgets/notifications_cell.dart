import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../resources/themes/need_to_refactor_and_remove/app_colors_old.dart';
import '../../../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';
import '../../../bloc/notifications_bloc.dart';
import '../../../entities/sent_notification.dart';

class NotificationCellForm {
    final SentNotification notification;

    NotificationCellForm({this.notification});
}

class NotificationCellStyle {
    final TextStyle defaultTextStyle;
    final TextStyle boldTextStyle;
    final TextStyle usernameInitialsStyle;
    final TextStyle amountStyle;
    final TextStyle currencyStyle;
    final AppColorsOld colors;

    NotificationCellStyle({
        this.defaultTextStyle,
        this.boldTextStyle,
        this.usernameInitialsStyle,
        this.amountStyle,
        this.currencyStyle,
        this.colors
    });

    factory NotificationCellStyle.fromOldTheme(AppThemeOld theme) {
        return NotificationCellStyle(
            defaultTextStyle: theme.textStyles.r12.copyWith(color: theme.colors.darkShade),
            boldTextStyle: theme.textStyles.m12.copyWith(color: theme.colors.darkShade),
            usernameInitialsStyle: theme.textStyles.m16.copyWith(color: theme.colors.darkShade),
            amountStyle: theme.textStyles.m16.copyWith(color: theme.colors.green),
            currencyStyle: theme.textStyles.r10.copyWith(color: theme.colors.darkShade),
            colors: theme.colors
        );
    }
}

class NotificationsCell extends StatelessWidget {

    final NotificationCellForm form;
    final NotificationCellStyle style;
    final NotificationsBloc notificationsBloc;

    const NotificationsCell({Key key, this.form, this.style, this.notificationsBloc}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        final titleText = RichText(
            maxLines: 2,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
                style: style.defaultTextStyle,
                children: <TextSpan>[
                    TextSpan(text: '${form.notification.payload.senderFirstName} '),
                    TextSpan(text: 'sent '),
                    TextSpan(text: '${form.notification.payload.amount} ${form.notification.payload.currency} ', style: style.boldTextStyle),
                    TextSpan(text: 'to your '),
                    TextSpan(text: '${form.notification.payload.currency} '),
                    TextSpan(text: 'Wallet '),
                    TextSpan(text: '${form.notification.payload.getLastFourNumberString()}')
                ],
            ),
        );

        return Container(
            height: 56,
            child: Row(
                children: <Widget>[
                    _avatar(context),
                    const SizedBox(width: 14),
                    Flexible(flex: 4, child: titleText),
                    const Spacer(),
                    _amount(context),
                    const SizedBox(width: 16)
                ],
            ),
        );
    }

    Widget _avatar(BuildContext context) {
        return Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: style.colors.extraLightShade,
                shape: BoxShape.circle
            ),
            alignment: Alignment.center,
            margin: const EdgeInsets.only(left: 16),
            child: Text(
                form.notification.payload.senderFirstName[0] ?? '?',
                style: style.usernameInitialsStyle,
            ),
        );
    }

    Widget _amount(BuildContext context) {
        return Container(
            child: Row(children: <Widget>[
                Text(
                    '+ ${form.notification.payload.amount.toString()} ' ?? '? ',
                    style: style.amountStyle,
                ),
                Text(
                    form.notification.payload.currency,
                    style: style.currencyStyle,
                ),
            ],
            )
        );
    }
}

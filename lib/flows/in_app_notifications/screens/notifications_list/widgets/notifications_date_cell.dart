import 'package:flutter/material.dart';

import '../../../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';

class NotificationsListSectionForm {
    final String title;

    NotificationsListSectionForm({this.title});
}

class NotificationsListSectionStyle {
    final TextStyle letterStyle;

    NotificationsListSectionStyle({this.letterStyle});

    factory NotificationsListSectionStyle.fromOldTheme(AppThemeOld theme) {
        return NotificationsListSectionStyle(
            letterStyle: theme.textStyles.m16.copyWith(color: theme.colors.darkShade)
        );
    }
}

class NotificationsListSection extends StatelessWidget {

    final NotificationsListSectionForm form;
    final NotificationsListSectionStyle style;

    const NotificationsListSection({
        Key key,
        @required this.form,
        @required this.style
    }) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return Container(
            height: 40,
            color: Colors.transparent,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 16, top: 8),
            child: Text(
                form.title,
                style: style.letterStyle,
            )
        );
    }
}

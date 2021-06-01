import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../../../../common/widgets/info_widgets.dart';
import '../../../../../../resources/strings/app_strings.dart';
import '../../../../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';
import 'whats_new_tile.dart';

class WhatsNewForm {
  final String text;
  final String icon;

  WhatsNewForm({this.text, this.icon});
}

class WhatsNewStyle {
  final TextStyle titleTextStyle;
  final BoxShadow shadow;
  final WhatsNewTileStyle tileStyle;

  WhatsNewStyle({this.titleTextStyle, this.shadow, this.tileStyle});

  factory WhatsNewStyle.fromOldTheme(AppThemeOld theme) {
    return WhatsNewStyle(
      titleTextStyle:
          theme.textStyles.m16.copyWith(color: theme.colors.darkShade),
      tileStyle: WhatsNewTileStyle.fromOldTheme(theme),
      shadow: BoxShadow(
          color: theme.colors.darkShade.withOpacity(0.1),
          offset: const Offset(0, 2),
          blurRadius: 16,
          spreadRadius: 0),
    );
  }
}

class WhatsNew extends StatelessWidget {
  final WhatsNewStyle style;

  const WhatsNew({this.style});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _title(context),
        Container(
          height: 130,
          child: ListView(
            padding:
                const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 12),
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              GestureDetector(
                // TODO: Generate random image, remove after prepare backend
                child: _tile(
                    title: 'Safe payments in internet',
                    icon:
                        "https://picsum.photos/100?image=${Random().nextInt(50)}"),
                onTap: () => showToast(context, "Not implemented"),
              ),
              GestureDetector(
                child: _tile(
                    title: 'Safe Bank',
                    icon:
                        "https://picsum.photos/200?image=${Random().nextInt(50)}"),
                onTap: () => showToast(context, "Not implemented"),
              ),
              GestureDetector(
                child: _tile(
                    title: 'QR-Code\nPayments',
                    icon:
                        "https://picsum.photos/200?image=${Random().nextInt(50)}"),
                onTap: () => showToast(context, "Not implemented"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _title(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, bottom: 0, top: 24),
      child: Text(
        AppStrings.WHATS_NEW.tr(),
        style: style.titleTextStyle,
      ),
    );
  }

  Widget _tile({String title, String icon}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: WhatsNewTile(
          form: WhatsNewTileForm(text: title, icon: icon),
          style: style.tileStyle),
    );
  }
}

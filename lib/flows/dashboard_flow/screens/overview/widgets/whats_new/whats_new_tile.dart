import 'package:flutter/material.dart';

import '../../../../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';

class WhatsNewTileForm {
    final String text;
    final String icon;

    WhatsNewTileForm({this.text, this.icon});
}

class WhatsNewTileStyle {
    final TextStyle titleTextStyle;
    final BoxShadow shadow;

    WhatsNewTileStyle({this.titleTextStyle, this.shadow});

    factory WhatsNewTileStyle.fromOldTheme(AppThemeOld theme) {
        return WhatsNewTileStyle(
            titleTextStyle: theme.textStyles.sm12.copyWith(color: Colors.white),
            shadow: BoxShadow(
                color: theme.colors.darkShade.withOpacity(0.1),
                offset: const Offset(0, 2),
                blurRadius: 16,
                spreadRadius: 1
            ),
        );
    }
}

class WhatsNewTile extends StatelessWidget {

    final WhatsNewTileForm form;
    final WhatsNewTileStyle style;

    const WhatsNewTile({Key key, this.form, this.style}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
                boxShadow: [style.shadow],
                borderRadius: BorderRadius.circular(16)
            ),
            child: Stack(
                children: <Widget>[
                    _icon(context),
                    Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Padding(
                            padding: const EdgeInsets.only(left: 8, bottom: 10, right: 8),
                            child: _text(context)
                        )
                    )
                ],
            ),
        );
    }

    Widget _icon(BuildContext context) {
        return Container(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(form.icon),
            )
        );
    }

    Widget _text(BuildContext context) {
        return Text(
            form.text,
            style: style.titleTextStyle,
            maxLines: 3
        );
    }
}

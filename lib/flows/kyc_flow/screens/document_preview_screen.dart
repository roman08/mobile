import 'dart:io';

import 'package:Velmie/resources/colors/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/widgets/app_bars/base_app_bar.dart';
import '../../../resources/strings/app_strings.dart';
import '../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';

class DocumentPreviewObject {
  final String path;
  final String title;
  final Function onPressed;

  DocumentPreviewObject({
    this.path,
    this.title,
    this.onPressed,
  });
}

class DocumentPreviewScreenStyle {
  final TextStyle titleTextStyle;
  final TextStyle headerTextStyle;
  final TextStyle descriptionTextStyle;
  final TextStyle applyButtonTextStyle;
  final TextStyle cancelButtonTextStyle;

  DocumentPreviewScreenStyle({
    this.titleTextStyle,
    this.headerTextStyle,
    this.descriptionTextStyle,
    this.applyButtonTextStyle,
    this.cancelButtonTextStyle,
  });

  factory DocumentPreviewScreenStyle.fromOldTheme(AppThemeOld theme) {
    return DocumentPreviewScreenStyle(
      titleTextStyle: theme.textStyles.m18.copyWith(
        color: theme.colors.darkShade,
      ),
      headerTextStyle: theme.textStyles.m24.copyWith(
        color: theme.colors.darkShade,
      ),
      descriptionTextStyle: theme.textStyles.r16.copyWith(
        color: theme.colors.darkShade,
      ),
      applyButtonTextStyle: theme.textStyles.m16.copyWith(
        color: theme.colors.white,
      ),
      cancelButtonTextStyle: theme.textStyles.m16.copyWith(
        color: AppColors.primary,
      ),
    );
  }
}

class DocumentPreviewScreen extends StatefulWidget {
  static const String ROUTE = '/kyc/document_preview';

  final DocumentPreviewObject object;

  const DocumentPreviewScreen({
    Key key,
    this.object,
  }) : super(key: key);

  @override
  _DocumentPreviewScreenState createState() => _DocumentPreviewScreenState();
}

class _DocumentPreviewScreenState extends State<DocumentPreviewScreen> {
  DocumentPreviewScreenStyle _style;

  @override
  void initState() {
    _style = DocumentPreviewScreenStyle.fromOldTheme(
      Provider.of<AppThemeOld>(context, listen: false),
    );
    super.initState();
  }

  BaseAppBar _appBar() => BaseAppBar(
        titleString: this.widget.object.title,
        centerTitle: true,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: Container(
                height: MediaQuery.of(context).size.width * 0.55,
                width: MediaQuery.of(context).size.width,
                child: Image.file(
                  File(this.widget.object.path),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  KYCStrings.CHECK_QUALITY.tr(),
                  style: _style.headerTextStyle,
                ),
                const SizedBox(
                  height: 17,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                  ),
                  child: Text(
                    KYCStrings.QUALITY_DESCRIPTION.tr(),
                    textAlign: TextAlign.center,
                    style: _style.descriptionTextStyle,
                  ),
                ),
                const SizedBox(
                  height: 27,
                ),
                CupertinoButton(
                  minSize: 0,
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    this.widget.object.onPressed();
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(24)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          KYCStrings.DOCUMENT_READABLE.tr(),
                          style: _style.applyButtonTextStyle,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                CupertinoButton(
                  minSize: 0,
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: 48,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          KYCStrings.TAKE_NEW_PICTURE.tr(),
                          style: _style.cancelButtonTextStyle,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 36,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

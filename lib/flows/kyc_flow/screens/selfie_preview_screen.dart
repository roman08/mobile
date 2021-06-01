import 'dart:io';

import 'package:Velmie/resources/colors/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../common/widgets/app_bars/base_app_bar.dart';
import '../../../flows/kyc_flow/models/requirement_request.dart';
import '../../../flows/kyc_flow/models/tiers_result.dart';
import '../../../resources/strings/app_strings.dart';
import '../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';
import '../cubit/kyc_cubit.dart';

class SelfiePreviewObject {
  final String path;
  final Function onSelected;

  SelfiePreviewObject({this.path, this.onSelected});
}

class SelfiePreviewScreenStyle {
  final TextStyle titleTextStyle;
  final TextStyle applyButtonTextStyle;
  final TextStyle cancelButtonTextStyle;

  SelfiePreviewScreenStyle({
    this.titleTextStyle,
    this.applyButtonTextStyle,
    this.cancelButtonTextStyle,
  });

  factory SelfiePreviewScreenStyle.fromOldTheme(AppThemeOld theme) {
    return SelfiePreviewScreenStyle(
      titleTextStyle: theme.textStyles.m18.copyWith(
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

class SelfiePreviewScreen extends StatefulWidget {
  final String picturePath;
  final KycCubit kycCubit;
  final Requirement requirement;

  const SelfiePreviewScreen({
    Key key,
    this.picturePath,
    this.kycCubit,
    this.requirement,
  }) : super(key: key);

  @override
  _SelfiePreviewScreenState createState() => _SelfiePreviewScreenState();
}

class _SelfiePreviewScreenState extends State<SelfiePreviewScreen> {
  SelfiePreviewScreenStyle _style;

  @override
  void initState() {
    _style = SelfiePreviewScreenStyle.fromOldTheme(
      Provider.of<AppThemeOld>(context, listen: false),
    );
    super.initState();
  }

  void _confirmPicture() {
    final requirementRequest = RequirementRequest(
      values: [
        ElementValue(
          index: widget.requirement.elements.first.index,
          value: widget.picturePath,
        ),
      ],
    );

    this.widget.kycCubit.updateRequirement(
          id: widget.requirement.id,
          requirement: requirementRequest,
        );

    Get.close(2);
  }

  void _takeNewPicture() {
    Get.back();
  }

  BaseAppBar _appBar() => BaseAppBar(
        titleString: KYCStrings.SELFIE.tr(),
      );

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<AppThemeOld>(context);
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: Container(
                height: MediaQuery.of(context).size.width,
                child: ClipOval(
                  child: Image.file(
                    File(widget.picturePath),
                    fit: BoxFit.cover,
                  ),
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
                CupertinoButton(
                  minSize: 0,
                  padding: EdgeInsets.zero,
                  onPressed: _confirmPicture,
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(24)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          KYCStrings.SELFIE_NOTE.tr(),
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
                  onPressed: _takeNewPicture,
                  child: Container(
                    height: 48,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          KYCStrings.NEW_PICTURE.tr(),
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

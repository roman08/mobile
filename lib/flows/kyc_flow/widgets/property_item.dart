import 'dart:typed_data';

import 'package:Velmie/resources/colors/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../resources/icons/icons_svg.dart';
import '../../../resources/strings/app_strings.dart';
import '../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';
import '../models/tiers_result.dart';
import 'image_status.dart';

class PropertyItem extends StatelessWidget {
  final Color imageBackgroundColor;
  final TextStyle titleTextStyle;
  final TextStyle placeholderTextStyle;
  final TextStyle valueTextStyle;

  final String title;
  final String value;
  final RequirementStatus status;
  final ElementIndex index;
  final String placeholder;
  final Function onTap;
  final String imagePath;
  final Uint8List bytes;

  const PropertyItem({
    Key key,
    this.imageBackgroundColor,
    this.titleTextStyle,
    this.placeholderTextStyle,
    this.valueTextStyle,
    this.title,
    this.value,
    this.status,
    this.index,
    this.placeholder,
    this.onTap,
    this.imagePath,
    this.bytes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<AppThemeOld>(context);

    return CupertinoButton(
      minSize: 0,
      padding: EdgeInsets.zero,
      onPressed: this.onTap,
      child: Container(
        height: 72,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                const SizedBox(
                  width: 16,
                ),
                ImageStatus(
                  backgroundColor: imageBackgroundColor,
                  status: this.status,
                  imagePath: imagePath,
                  bytes: bytes,
                ),
                const SizedBox(
                  width: 16,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      this.title,
                      style: titleTextStyle,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    if (this.index == ElementIndex.selfiePhoto)
                      Text(
                        this.value == null ? KYCStrings.ADD_PHOTO.tr() : KYCStrings.CHANGE_PHOTO.tr(),
                        style: valueTextStyle.copyWith(
                          color: AppColors.primary,
                        ),
                      )
                    else if (this.value.isNotEmpty)
                      Text(
                        this.value,
                        style: valueTextStyle,
                      )
                    else
                      Text(
                        this.placeholder,
                        style: placeholderTextStyle,
                      ),
                  ],
                ),
              ],
            ),
            Row(
              children: <Widget>[
                SvgPicture.asset(
                  this.status == RequirementStatus.approved ||
                          this.status == RequirementStatus.pending ||
                          this.status == RequirementStatus.notAvailable
                      ? IconsSVG.lock
                      : IconsSVG.arrowRightIOSStyle,
                ),
                const SizedBox(
                  width: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

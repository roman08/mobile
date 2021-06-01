import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../resources/colors/custom_color_scheme.dart';
import '../../../resources/icons/icons_svg.dart';
import '../models/tiers_result.dart';

class ImageStatusStyle {
  final Color successColor;
  final Color waitingColor;
  final Color rejectedColor;

  ImageStatusStyle({
    this.successColor,
    this.waitingColor,
    this.rejectedColor,
  });

  factory ImageStatusStyle.fromOldTheme() {
    return ImageStatusStyle(
      successColor: Get.theme.colorScheme.success,
      waitingColor: Get.theme.colorScheme.warning,
      rejectedColor: Get.theme.colorScheme.error,
    );
  }
}

class ImageStatus extends StatelessWidget {
  final RequirementStatus status;
  final Color backgroundColor;
  final String imagePath;
  final Uint8List bytes;

  const ImageStatus({
    Key key,
    this.status,
    this.backgroundColor,
    this.imagePath,
    this.bytes,
  }) : super(key: key);

  Color _getColor(BuildContext context, {RequirementStatus status}) {
    final style = ImageStatusStyle.fromOldTheme();

    switch (status) {
      case RequirementStatus.approved:
        return style.successColor;
      case RequirementStatus.pending:
        return style.waitingColor;
      case RequirementStatus.canceled:
        return Get.theme.colorScheme.error;
      default:
        return style.waitingColor;
    }
  }

  String _getImageName() {
    switch (this.status) {
      case RequirementStatus.approved:
        return IconsSVG.check;
      case RequirementStatus.pending:
        return IconsSVG.waiting;
      case RequirementStatus.canceled:
        return IconsSVG.cross;
      default:
        return IconsSVG.empty;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: <Widget>[
          Center(
            child: imagePath == null
                ? (bytes == null
                    ? SvgPicture.asset(
                        IconsSVG.propertyPlaceholder,
                      )
                    : ClipOval(
                        child: Image.memory(
                          bytes,
                          fit: BoxFit.cover,
                          width: 40,
                          height: 40,
                        ),
                      ))
                : ClipOval(
                    child: Image.file(
                      File(imagePath),
                      fit: BoxFit.cover,
                      width: 40,
                      height: 40,
                    ),
                  ),
          ),
          if (this.status == RequirementStatus.notFilled ||
              this.status == RequirementStatus.waiting)
            Container()
          else
            Align(
              alignment: Alignment.topRight,
              child: Container(
                transform: Matrix4.translationValues(4.0, -4.0, 0.0),
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    width: 2,
                    color: Colors.white,
                  ),
                  boxShadow: [
                    const BoxShadow(
                      offset: Offset(0, 2),
                      blurRadius: 2,
                      color: Colors.black26,
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: _getColor(
                        context,
                        status: this.status,
                      ),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        _getImageName(),
                        width: 9,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

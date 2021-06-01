import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../resources/colors/custom_color_scheme.dart';

Widget progressLoader() => Container(
      color: Get.theme.colorScheme.onPrimary,
      child: Center(
        child: CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Get.theme.colorScheme.primary),
            strokeWidth: 1.5,
            backgroundColor: Get.theme.colorScheme.primaryExtraLight),
      ),
    );

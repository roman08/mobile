import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../resources/colors/custom_color_scheme.dart';

class LoaderScreen extends StatelessWidget {
  const LoaderScreen();

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: Container(
            color: Get.theme.colorScheme.onPrimary,
            child: Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Get.theme.colorScheme.primary),
                  strokeWidth: 1.5,
                  backgroundColor: Get.theme.colorScheme.primaryExtraLight),
            ),
          ),
        ),
      );
}

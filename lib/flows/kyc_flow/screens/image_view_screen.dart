import 'dart:typed_data';

import 'package:Velmie/common/widgets/app_bars/base_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageViewScreen extends StatelessWidget {
  final Uint8List data;

  const ImageViewScreen({this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.memory(data),
            SizedBox(height: 100.h),
          ],
        ),
      ),
    );
  }
}

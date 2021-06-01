import 'dart:typed_data';

import 'package:Velmie/common/widgets/app_bars/base_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

class CardDocumentScreen extends StatelessWidget {
  final Uint8List data;
  final String title;

  const CardDocumentScreen({
    this.data,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(titleString: title),
      body: SafeArea(
        minimum: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 20.w),
        child: PdfView(
          controller: PdfController(document: PdfDocument.openData(data)),
        ),
      ),
    );
  }
}

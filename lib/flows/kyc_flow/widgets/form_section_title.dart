import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FormSectionTitle extends StatelessWidget {
  final String title;

  const FormSectionTitle({@required this.title}) : assert(title != null);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.blueGrey,
        fontSize: 20.ssp,
      ),
    );
  }
}

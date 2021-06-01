import 'package:Velmie/common/widgets/app_bars/base_app_bar.dart';
import 'package:Velmie/flows/sign_in_flow/screens/sign_in_screen/widgets/sign_in_form.dart';
import 'package:Velmie/resources/icons/icons_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(backIconPath: IconsSVG.cross),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 40.h, 16.w, 24.h),
                child: SignInForm(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

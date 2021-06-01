import 'package:Velmie/common/widgets/app_bars/base_app_bar.dart';
import 'package:Velmie/common/widgets/app_buttons/button.dart';
import 'package:Velmie/common/widgets/info_widgets.dart';
import 'package:Velmie/common/widgets/loader/progress_loader.dart';
import 'package:Velmie/flows/sign_up_flow/cubit/sign_up_cubit.dart';
import 'package:Velmie/resources/errors/app_common_error.dart';
import 'package:Velmie/resources/strings/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart'; 
import 'package:Velmie/flows/kyc_flow/kyc_flow.dart';

class SignatureScreen extends StatefulWidget {
  final VoidCallback onDone;
  final bool showSkipButton;

  const SignatureScreen({
    this.onDone,
    this.showSkipButton = false,
  });

  @override
  _SignatureScreenState createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  @override
  void initState() {
    Future.microtask(() {
      final locale = context.locale;
      context.read<SignUpCubit>().loadSignatureLink(language: locale.languageCode);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        titleString: AppStrings.E_SIGNATURE.tr(),
        titleColor: Colors.black,
        onBackPress: () {
          context.read<SignUpCubit>().stepChanged(SignUpStep.residence);
          Get.back();
        },
        actions: [
          if (widget.showSkipButton)
            
            //  FlatButton(onPressed: () => widget.onDone?.call(), child: Text(AppStrings.SKIP.tr())),
            FlatButton(onPressed: () => Get.to(const KycFlow()), child: Text(AppStrings.SKIP.tr())),
        ],
      ),
      body: SafeArea(
        minimum: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 20.h),
        child: BlocConsumer<SignUpCubit, SignUpState>(
          listener: (context, state) {
            if (state.signatureError != null) {
              showAlertDialog(
                context,
                title: AppStrings.ERROR.tr(),
                description: CommonErrors[state.signatureError]?.tr() ?? AppStrings.YOU_CANT_CREATED_A_SIGNATURE.tr(),
                //onPress: () => widget.onDone?.call(), 
                // onPress: () => Get.to(const KycFlow()),
                onPress: () => Navigator.pop(context, true),
              );
            }
          },
          buildWhen: (previous, current) => previous.signatureLink != current.signatureLink,
          builder: (context, state) {
            if (state.signatureLink == null) {
              return progressLoader();
            }

            return Column(
              children: [
                Expanded(
                  child: SizedBox(
                    height: ScreenUtil.screenHeight - Scaffold.of(context).appBarMaxHeight - 100.h,
                    child: InAppWebView(initialUrl: state.signatureLink),
                  ),
                ),
                SizedBox(height: 16.h),
                Button(
                  title: AppStrings.CONTINUE.tr(),
                  // onPressed: () => widget.onDone?.call(),
                  onPressed: () => Get.to(const KycFlow()),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

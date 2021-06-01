import 'package:Velmie/common/passcode/pass_code_screen.dart';
import 'package:Velmie/common/passcode/passcode_widget/pass_code_widget.dart';
import 'package:Velmie/common/widgets/app_bars/base_app_bar.dart';
import 'package:Velmie/common/widgets/app_buttons/button.dart';
import 'package:Velmie/common/widgets/info_widgets.dart';
import 'package:Velmie/flows/sign_up_flow/cubit/sign_up_cubit.dart';
import 'package:Velmie/flows/sign_up_flow/screens/signature_screen.dart';
import 'package:Velmie/flows/sign_up_flow/widgets/document_loader.dart';
import 'package:Velmie/resources/errors/app_common_error.dart';
import 'package:Velmie/resources/strings/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';

class ProofOfResidenceScreen extends StatelessWidget { 
  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listenWhen: (previous, current) =>
          previous.step != current.step || previous.proofOfResidenceErrorCode != current.proofOfResidenceErrorCode,
      listener: (context, state) {
        if (state.proofOfResidenceErrorCode != null) {
          showAlertDialog(
            context,
            title: AppStrings.ERROR.tr(),
            description: CommonErrors[state.proofOfResidenceErrorCode]?.tr() ?? ErrorStrings.SOMETHING_WENT_WRONG.tr(),
            onPress: () => Get.close(1),
          );
        }
        if (state.step == SignUpStep.signature) {
          Get.to(SignatureScreen(
            onDone: () => Get.to(const PassCodeScreen(status: PassCodeStatus.signInCreate)),
            showSkipButton: true,
          ));
        }
      },
      child: Scaffold(
        appBar: BaseAppBar(
          titleString: AppStrings.PROOF_OF_RESIDENCE.tr(),
          titleColor: Colors.black,
          onBackPress: () {
            context.read<SignUpCubit>().stepChanged(SignUpStep.idDocuments);
            Get.back();
          },
          actions: [
            FlatButton(
              onPressed: () => Get.to(SignatureScreen(
                onDone: () => Get.to(const PassCodeScreen(status: PassCodeStatus.signInCreate)),
                showSkipButton: true,
              )),
              child: Text(AppStrings.SKIP.tr()),
            ),
          ],
        ),
        body: SafeArea(
          minimum: EdgeInsets.only(bottom: 20.h),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                DocumentLoader(
                  onChange: (filePath) => context.read<SignUpCubit>().setProofOfResidencePath(filePath),
                ),
                const Spacer(),
                BlocBuilder<SignUpCubit, SignUpState>(
                  builder: (context, state) => Button(
                    isSupportLoading: true,
                    title: AppStrings.CONTINUE.tr(),
                    onPressed: state.proofOfResidencePath != null
                        ? () {
                            context.read<SignUpCubit>().sendProofOfResidence();
                          }
                        : null,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:Velmie/common/widgets/app_bars/base_app_bar.dart';
import 'package:Velmie/common/widgets/app_buttons/button.dart';
import 'package:Velmie/common/widgets/info_widgets.dart';
import 'package:Velmie/flows/sign_up_flow/cubit/sign_up_cubit.dart';
import 'package:Velmie/flows/sign_up_flow/screens/proof_of_residence_screen.dart';
import 'package:Velmie/flows/sign_up_flow/widgets/document_loader.dart';
import 'package:Velmie/resources/errors/app_common_error.dart';
import 'package:Velmie/resources/strings/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';

class IdDocumentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listenWhen: (previous, current) =>
          previous.step != current.step || previous.idDocumentsErrorCode != current.idDocumentsErrorCode,
      listener: (context, state) {
        if (state.idDocumentsErrorCode != null) {
          showAlertDialog(
            context,
            title: AppStrings.ERROR.tr(),
            description: CommonErrors[state.idDocumentsErrorCode]?.tr() ?? ErrorStrings.SOMETHING_WENT_WRONG.tr(),
            onPress: () => Get.close(1),
          );
        }
        if (state.step == SignUpStep.residence) {
          Get.to(ProofOfResidenceScreen());
        }
      },
      child: Scaffold(
        appBar: BaseAppBar(
          titleString: AppStrings.ID_DOCUMENT.tr(),
          titleColor: Colors.black,
          actions: [
            FlatButton(onPressed: () => Get.to(ProofOfResidenceScreen()), child: Text(AppStrings.SKIP.tr())),
          ],
        ),
        body: SafeArea(
          minimum: EdgeInsets.only(bottom: 20.h),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DocumentLoader(
                    title: AppStrings.FRONT.tr() + ' *',
                    onChange: (filePath) => context.read<SignUpCubit>().setIdFront(filePath),
                  ),
                  SizedBox(height: 30.h),
                  DocumentLoader(
                    title: AppStrings.BACK.tr(),
                    onChange: (filePath) => context.read<SignUpCubit>().setIdBack(filePath),
                  ),
                  SizedBox(height: 30.h),
                  DocumentLoader(
                    title: AppStrings.USER_SELFIE.tr() + ' *',
                    onChange: (filePath) => context.read<SignUpCubit>().setSelfie(filePath),
                  ),
                  SizedBox(height: 30.h),
                  BlocBuilder<SignUpCubit, SignUpState>(
                    builder: (context, state) {
                      return Button(
                        title: AppStrings.CONTINUE.tr(),
                        onPressed: state.idFrontPath != null && state.selfiePath != null
                            ? () {
                                context.read<SignUpCubit>().sendIdDocuments();
                              }
                            : null,
                        isSupportLoading: true,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

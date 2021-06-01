import 'package:flutter/material.dart';

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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import '../../../common/screens/camera-view-screen/camera_view_screen.dart';
import '../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';
import 'package:Velmie/resources/colors/app_colors.dart';
import '../../../resources/themes/need_to_refactor_and_remove/app_colors_old.dart';
import 'package:Velmie/flows/dashboard_flow/more/profile/cubit/profile_cubit.dart';


class _SendVoucherScrenStyle {
  final TextStyle titleTextStyle;
  final TextStyle itemTitleStyle;
  final TextStyle itemTitleRedStyle;
  final TextStyle itemSubtitleStyle;
  final TextStyle usernameInitialsStyle;
  final TextStyle sheetActionTextStyle;
  final TextStyle sheetCancelTextStyle;
  final AppColorsOld colors;

  _SendVoucherScrenStyle({
    this.titleTextStyle,
    this.itemTitleStyle,
    this.itemTitleRedStyle,
    this.itemSubtitleStyle,
    this.usernameInitialsStyle,
    this.sheetActionTextStyle,
    this.sheetCancelTextStyle,
    this.colors,
  });

  factory _SendVoucherScrenStyle.fromOldTheme(AppThemeOld theme) {
    return _SendVoucherScrenStyle(
      titleTextStyle: theme.textStyles.m24.copyWith(color: Get.theme.colorScheme.onBackground),
      itemTitleStyle: theme.textStyles.r16.copyWith(color: theme.colors.darkShade),
      itemTitleRedStyle: theme.textStyles.r16.copyWith(color: AppColors.primary),
      itemSubtitleStyle: theme.textStyles.m16.copyWith(color: theme.colors.darkShade),
      usernameInitialsStyle: theme.textStyles.m30.copyWith(color: theme.colors.white),
      sheetActionTextStyle: theme.textStyles.r20.copyWith(color: AppColors.primary),
      sheetCancelTextStyle: theme.textStyles.m20.copyWith(color: AppColors.primary),
      colors: theme.colors,
    );
  }
}
  
class SendVoucherScren extends StatelessWidget {
  final _SendVoucherScrenStyle _style = _SendVoucherScrenStyle.fromOldTheme(AppThemeOld.defaultTheme());

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
            showAlertDialog(
              context,
              title: AppStrings.SUCCESS.tr(),
              description: AppStrings.SUCCESS_VOUCHER.tr(),
              onPress: () => Get.close(2),
          );
          // Get.to(SignatureScreen(
          //   onDone: () => Get.to(const PassCodeScreen(status: PassCodeStatus.signInCreate)),
          //   showSkipButton: true,
          // ));
        }
      },
      child: Scaffold(
        appBar: BaseAppBar(
          titleString: AppStrings.VOUCHER.tr(),
          titleColor: Colors.black,
          onBackPress: () {
            context.read<SignUpCubit>().stepChanged(SignUpStep.idDocuments);
            Get.back();
          },
          // actions: [
          //   FlatButton(
          //     onPressed: () => Get.to(SignatureScreen(
          //       onDone: () => Get.to(const PassCodeScreen(status: PassCodeStatus.signInCreate)),
          //       showSkipButton: false,
          //     )),
          //     child: Text(AppStrings.SKIP.tr()),
          //   ),
          // ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: SafeArea(
            minimum: EdgeInsets.only(bottom: 20.h),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  DocumentLoader(
                    onChange: (filePath) => context.read<SignUpCubit>().setVoucherPath(filePath),
                  ),
                  const Spacer(),
                  BlocBuilder<SignUpCubit, SignUpState>(
                    builder: (context, state) => Button(
                      isSupportLoading: true,
                      title: AppStrings.CONTINUE.tr(),
                      onPressed: state.setVoucherPath != null
                          ? () {
                            // print('hola camara');
                              context.read<SignUpCubit>().sendVoucher();
                            }
                          : null,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }



}
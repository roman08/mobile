import 'package:Velmie/common/widgets/info_widgets.dart';
import 'package:Velmie/flows/kyc_flow/cubit/kyc_cubit.dart';
import 'package:Velmie/flows/kyc_flow/cubit/kyc_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/payments_method/entity/payment_method_entity.dart';
import '../../../../common/widgets/payments_method/payments_method.dart';
import '../../../../resources/icons/icons_svg.dart';
import '../../../../resources/strings/app_strings.dart';
import '../../../../resources/themes/need_to_refactor_and_remove/app_colors_old.dart';
import '../../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';
import '../../../transfer_money/request/request_money_screen.dart';
import '../../../transfer_money/screens/iwt/iwt_screen.dart';
import '../../../transfer_money/screens/owt/owt_screen.dart';
import '../../../transfer_money/send/send_money_screen.dart';

class _PaymentsScreenStyle {
  final TextStyle titleTextStyle;
  final AppColorsOld colors;

  _PaymentsScreenStyle({
    this.titleTextStyle,
    this.colors,
  });

  factory _PaymentsScreenStyle.fromOldTheme(AppThemeOld theme) {
    return _PaymentsScreenStyle(
      titleTextStyle: theme.textStyles.m30.copyWith(color: theme.colors.darkShade),
      colors: theme.colors,
    );
  }
}

class PaymentsScreen extends StatelessWidget {
  final _PaymentsScreenStyle _style = _PaymentsScreenStyle.fromOldTheme(AppThemeOld.defaultTheme());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: BlocBuilder<KycCubit, KycState>(
            builder: (context, state) => Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 16.w, top: 89.h),
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      AppStrings.PAYMENTS.tr(),
                      textAlign: TextAlign.start,
                      style: _style.titleTextStyle,
                    ),
                  ),
                ),
                PaymentsMethod(
                  payments: _getPayments(context, state is SuccessState && state.currentTier.level > 0),
                  title: AppStrings.OTHER_SERVICES.tr(),
                ),
                PaymentsMethod(
                  payments: _getIWTOWT(context, state is SuccessState && state.currentTier.level > 0),
                  title: AppStrings.IWT_OWT.tr(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<PaymentsMethodEntity> _getPayments(BuildContext context, bool enabled) {
    return [
      PaymentsMethodEntity(
        title: AppStrings.SEND_MONEY.tr(),
        icon: IconsSVG.sendMoney,
        onPressed: () {
          if (enabled) {
            Get.to(SendMoneyScreen());
          } else {
            showToast(context, AppStrings.PLEASE_UPGRADE_YOUR_KYC_LEVEL.tr());
          }
        },
      ),
      PaymentsMethodEntity(
        title: AppStrings.REQUEST_MONEY.tr(),
        icon: IconsSVG.requestMoney,
        onPressed: () {
          if (enabled) {
            Get.to(RequestMoneyScreen());
          } else {
            showToast(context, AppStrings.PLEASE_UPGRADE_YOUR_KYC_LEVEL.tr());
          }
        },
      ),
    ];
  }

  List<PaymentsMethodEntity> _getIWTOWT(BuildContext context, bool enabled) {
    return [
      PaymentsMethodEntity(
        title: AppStrings.INCOMING_WIRE_TRANSFER.tr(),
        icon: IconsSVG.sendMoney,
        onPressed: () {
          if (enabled) {
            Get.to(IWTScreen());
          } else {
            showToast(context, AppStrings.PLEASE_UPGRADE_YOUR_KYC_LEVEL.tr());
          }
        },
      ),
      PaymentsMethodEntity(
        title: AppStrings.OUTGOING_WIRE_TRANSFER.tr(),
        icon: IconsSVG.requestMoney,
        onPressed: () {
          if (enabled) {
            Get.to(const OWTScreen());
          } else {
            showToast(context, AppStrings.PLEASE_UPGRADE_YOUR_KYC_LEVEL.tr());
          }
        },
      ),
    ];
  }
}

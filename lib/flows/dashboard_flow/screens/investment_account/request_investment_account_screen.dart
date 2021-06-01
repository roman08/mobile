import 'package:Velmie/common/widgets/app_bars/base_app_bar.dart';
import 'package:Velmie/common/widgets/info_widgets.dart';
import 'package:Velmie/common/widgets/loader/progress_loader.dart';
import 'package:Velmie/flows/dashboard_flow/cubit/investment_accounts_cubit.dart';
import 'package:Velmie/flows/dashboard_flow/screens/investment_account/widgets/investment_account_conditions.dart';
import 'package:Velmie/flows/kyc_flow/screens/customer_profile_screen.dart';
import 'package:Velmie/resources/strings/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';

const HALF_OF_YEAR_IN_DAYS = 183;
const FULL_YEAR_IN_DAYS = 356;

class RequestInvestmentAccountScreen extends StatelessWidget {
  void onRequest(BuildContext context, int conditionId, String currency) {
    context.read<InvestmentAccountsCubit>().requestAccount(
          optionId: conditionId,
          currency: currency,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InvestmentAccountsCubit, InvestmentAccountsState>(
      listener: (context, state) {
        if (state?.additionalKycRequired == true) {
          Get.to(const CustomerProfileScreen(excludeFilled: true));
        }

        if (state?.accountRequested == true) {
          showToast(context, AppStrings.INVESTMENT_ACCOUNT_REQUESTED.tr());
          Get.back();
        }
      },
      child: Scaffold(
        appBar: BaseAppBar(titleString: AppStrings.INVESTMENT_ACCOUNT.tr(), titleColor: Colors.black,),
        body: SafeArea(
          minimum: EdgeInsets.only(bottom: 20.h, left: 24.w, right: 24.w),
          child: BlocBuilder<InvestmentAccountsCubit, InvestmentAccountsState>(
            builder: (context, state) {
              if (state.conditions == null || state.currencies == null) {
                return progressLoader();
              }

              return Column(
                children: state.conditions
                    .map(
                      (condition) => InvestmentAccountConditions(
                        conditions: [
                          '${AppStrings.FUNDS_SINCE.tr()} ${NumberFormat.currency(name: '\$').format(condition.minFunds)} ${condition.paramCurrency}',
                          if (condition.currency.isEmpty) AppStrings.MULTI_CURRENCY.tr() else condition.currency,
                          '${AppStrings.ANNUAL_RETURNS_OF.tr()} ${condition.rate}%',
                          if (condition.duration == HALF_OF_YEAR_IN_DAYS)
                            AppStrings.MAINTAIN_MINIMUM_CAPITAL_FOR_HALF_YEAR.tr()
                          else
                            AppStrings.MAINTAIN_MINIMUM_CAPITAL_FOR_ONE_YEAR.tr(),
                          '${AppStrings.ANNUAL_FEE.tr()} ${NumberFormat.currency(name: '\$').format(condition.fee)} ${condition.paramCurrency}',
                        ],
                        currencies: state.currencies,
                        onRequest: (currency) => onRequest(context, condition.id, currency),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}

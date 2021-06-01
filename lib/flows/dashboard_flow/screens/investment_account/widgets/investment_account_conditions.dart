import 'package:Velmie/common/widgets/select.dart';
import 'package:Velmie/flows/dashboard_flow/cubit/investment_accounts_cubit.dart';
import 'package:Velmie/flows/transfer_money/enities/common/currency_entity.dart';
import 'package:Velmie/resources/colors/app_colors.dart';
import 'package:Velmie/resources/strings/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class InvestmentAccountConditions extends StatefulWidget {
  final List<String> conditions;
  final List<CurrencyEntity> currencies;
  final Function(String currency) onRequest;

  const InvestmentAccountConditions({
    @required this.conditions,
    this.currencies,
    this.onRequest,
  }) : assert(conditions != null);

  @override
  _InvestmentAccountConditionsState createState() => _InvestmentAccountConditionsState();
}

class _InvestmentAccountConditionsState extends State<InvestmentAccountConditions> {
  String currency;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(15.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.h),
            color: AppColors.primary.withOpacity(.4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: widget.conditions
                .map(
                  (condition) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    child: Text(
                      condition,
                      style: TextStyle(color: Colors.black, fontSize: 14.ssp),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Select(
              placeholder: AppStrings.CURRENCY.tr(),
              options: widget.currencies.map((currency) => SelectItem(title: currency.code)).toList(),
              onChange: (value) => setState(() => currency = value),
            ),
            BlocBuilder<InvestmentAccountsCubit, InvestmentAccountsState>(
              builder: (context, state) => GestureDetector(
                onTap: () {
                  if (currency != null || state.loading) {
                    widget.onRequest?.call(currency);
                  }
                },
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: 30.h,
                    minWidth: 120.w,
                  ),
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 15.w),
                  decoration: BoxDecoration(
                    color: currency != null ? AppColors.primary : AppColors.primary.withOpacity(.4),
                    borderRadius: BorderRadius.circular(8.h),
                  ),
                  child: !state.loading
                      ? Text(AppStrings.REQUEST.tr(), style: TextStyle(fontSize: 16.ssp))
                      : SizedBox(
                          height: 15.h,
                          width: 15.h,
                          child: CircularProgressIndicator(
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.onPrimary),
                            strokeWidth: 1.w,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}

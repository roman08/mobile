import 'package:Velmie/flows/transfer_money/enities/owt/owt_preview_response.dart';
import 'package:api_error_parser/api_error_parser.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../app.dart';
import '../../../../common/widgets/app_bars/base_app_bar.dart';
import '../../../../common/widgets/app_buttons/button.dart';
import '../../../../common/widgets/info_widgets.dart';
import '../../../../common/widgets/loader/loader_screen.dart';
import '../../../../common/widgets/success_screen.dart';
import '../../../../resources/errors/app_error_code.dart';
import '../../../../resources/strings/app_strings.dart';
import '../../../dashboard_flow/bloc/bottom_navigation/bottom_navigation_bloc.dart';
import '../../../dashboard_flow/dashboard_flow.dart';
import '../../../dashboard_flow/destination_view.dart';
import '../../../dashboard_flow/entities/wallet_list_wrapper.dart';
import '../../cubit/owt/owt_cubit.dart';
import '../../enities/owt/owt_request.dart';

class OwtPreviewScreen extends StatelessWidget {
  final Wallet wallet;
  final OwtRequest request;
  final Detail fee;

  const OwtPreviewScreen({
    @required this.request,
    @required this.wallet,
    this.fee,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OwtCubit, OwtState>(listener: (context, state) {
      if (state is OwtRequestPerformed) {
        context.read<BottomNavigationCubit>().navigateTo(Navigation.transactions);
        Get.to(SuccessScreen(
          title: AppStrings.OUTGOING_WIRE_TRANSFER.tr(),
          body: AppStrings.YOUR_REQUEST_SENT_FOR_APPROVAL.tr(namedArgs: {
            'id': state.requestId.toString(),
          }),
          canBack: false,
          onButtonPressed: () => Get.offAll(DashboardFlow()),
        ));
      }

      if (state is OwtPreviewFailed) {
        _handleError(context, state.errors);
      }

      if (state is OwtRequestFailed) {
        _handleError(context, state.errors);
      }
    }, builder: (context, state) {
      if (state is OwtRequestPerforming) {
        return const LoaderScreen();
      } else {
        return Scaffold(
          appBar: BaseAppBar(
            titleString: AppStrings.OUTGOING_WIRE_TRANSFER.tr(),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  Text(
                    wallet.number,
                    style: TextStyle(
                      fontSize: 18.ssp,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '${wallet.type.currencyCode} ${NumberFormat.simpleCurrency(name: '').format(double.parse(wallet.availableAmount))}',
                    style: TextStyle(
                      fontSize: 16.ssp,
                      color: Colors.black,
                    ),
                  ),
                  _sectionTitle('Transfer Details'),
                  _row(
                    'Amount to transfer',
                    NumberFormat.simpleCurrency(name: '').format(double.parse(request.outgoingAmount)) +
                        ' ' +
                        request.referenceCurrency.code,
                  ),
                  if (request.referenceCurrency.code != wallet.type.currencyCode)
                    _row(
                      'Debit amount (approximate)',
                      NumberFormat.simpleCurrency(name: '')
                              .format(double.parse(request.confirmTotalOutgoingAmount).abs()) +
                          ' ' +
                          wallet.type.currencyCode,
                    ),
                  if (fee != null)
                    _row(
                      'OWT Fee',
                      NumberFormat.simpleCurrency(name: '').format(double.parse(fee.amount).abs()) + ' ' + fee.currencyCode,
                    ),
                  if (request.description.isNotEmpty) _row('Description', request.description),
                  _sectionTitle('Specify Beneficiary Bank'),
                  _row('SWIFT / BIC', request.bankSwiftBic),
                  _row('Name', request.bankName),
                  _row('Address', request.bankAddress),
                  _row('Location', request.bankLocation),
                  _row('Country', request.bankCountry.name),
                  _row('ISO2 Country Code', request.bankCountry.code),
                  if (request.bankAbaRtn.isNotEmpty) _row('ABA / RTN', request.bankAbaRtn),
                  _sectionTitle('Specify Beneficiary Customer'),
                  _row('Name', request.customerName),
                  _row('Address', request.customerAddress),
                  _row('Acc# / IBAN', request.customerAccIban),
                  _sectionTitle('Additional Information'),
                  _row('Ref message', request.refMessage),
                  if (request.isIntermediaryBankRequired)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionTitle('Specify Intermediary Bank'),
                        _row('SWIFT / BIC', request.intermediaryBankSwiftBic),
                        _row('Name', request.intermediaryBankName),
                        _row('Address', request.intermediaryBankAddress),
                        _row('Location', request.intermediaryBankLocation),
                        _row('Country', request.intermediaryBankCountry.name),
                        _row('ISO2 Country Code', request.intermediaryBankCountry.code),
                        if (request.intermediaryBankAbaRtn.isNotEmpty)
                          _row('ABA / RTN', request.intermediaryBankAbaRtn),
                        _row('Acc# / IBAN', request.intermediaryBankAccIban),
                      ],
                    ),
                  SizedBox(height: 30.h),
                  BlocBuilder<OwtCubit, OwtState>(
                    builder: (context, state) => Button(
                      title: AppStrings.CONTINUE.tr(),
                      onPressed: state is OwtRequestPerforming
                          ? null
                          : () {
                              context.read<OwtCubit>().owtRequest = request;
                              context.read<OwtCubit>().owtPerformRequest();
                            },
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        );
      }
    });
  }

  void _handleError(BuildContext context, List<ParserMessageEntity> errors) {
    logger.e(errors?.first?.toString());
    String description = ErrorStrings.SOMETHING_WENT_WRONG.tr();
    switch (errors?.first?.code) {
      case AppErrorCode.limits_exceeded:
        description = ErrorStrings.KYC_LIMITS_EXCEEDED.tr();
        break;
      case AppErrorCode.invalid_wallet:
        description = ErrorStrings.ERROR_INVALID_WALLET.tr();
        break;
      case AppErrorCode.insufficient_funds:
        description = ErrorStrings.INSUFFICIENT_WALLET_BALANCE.tr();
        break;
      case AppErrorCode.deposit_not_allowed:
        description = ErrorStrings.DEPOSIT_NOT_ALLOWED.tr();
        break;
      case AppErrorCode.withdrawal_not_allowed:
        description = ErrorStrings.WITHDRAWALS_NOT_ALLOWED.tr();
        break;
      case AppErrorCode.invalid_account_owner:
        description = ErrorStrings.INVALID_ACCOUNT_OWNER.tr();
        break;
      case AppErrorCode.tfa_code_is_required:
        description = ErrorStrings.TFA_CODE_IS_REQUIRED.tr();
        break;
      case AppErrorCode.tfa_code_is_not_valid:
        description = ErrorStrings.TFA_CODE_IS_NOT_VALID.tr();
        break;
      case AppErrorCode.your_phone_number_is_empty:
        description = ErrorStrings.YOUR_PHONE_NUMBER_IS_EMPTY.tr();
        break;
      case AppErrorCode.your_phone_number_is_not_valid:
        description = ErrorStrings.YOUR_PHONE_NUMBER_IS_NOT_VALID.tr();
        break;
      case AppErrorCode.tfa_max_send_attempts_reached:
        description = ErrorStrings.TFA_MAX_SEND_ATTEMPTS_REACHED.tr();
        break;
      default:
        description = ErrorStrings.SOMETHING_WENT_WRONG.tr();
    }

    showAlertDialog(
      context,
      title: AppStrings.ALERT.tr(),
      description: description,
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 22.ssp,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          SizedBox(
            width: 200.w,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16.ssp,
                color: Colors.black,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.ssp,
              color: Colors.blueGrey,
            ),
          ),
        ],
      ),
    );
  }
}

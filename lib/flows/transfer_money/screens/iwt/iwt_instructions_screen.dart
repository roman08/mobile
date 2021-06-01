import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/widgets/app_bars/base_app_bar.dart';
import '../../../../common/widgets/app_buttons/button.dart';
import '../../../../common/widgets/info_widgets.dart';
import '../../../../resources/strings/app_strings.dart';
import '../../../dashboard_flow/entities/wallet_list_wrapper.dart';
import '../../cubit/iwt/iwt_cubit.dart';
import '../../enities/iwt/iwt_instruction_entity.dart';

class IwtInstructionsScreen extends StatelessWidget {
  final IwtInstruction instruction;
  final Wallet wallet;

  const IwtInstructionsScreen({
    @required this.instruction,
    @required this.wallet,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<IwtCubit, IwtState>(
      listener: (context, state) {
        if (state is IwtFileSaved) {
          showToast(context, 'File ${state.fileName} saved');
        }

        if (state is IwtFileSaveError) {
          showToast(context, ErrorStrings.SOMETHING_WENT_WRONG.tr());
        }
      },
      child: Scaffold(
        appBar: BaseAppBar(
          titleString: AppStrings.INCOMING_WIRE_TRANSFER.tr(),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (instruction.intermediaryBankDetails != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle('Intermediary Bank Details'),
                    _subtitle(
                        'Please fund your account using the following bank instructions:'),
                    _row('Swift / BIC',
                        instruction.intermediaryBankDetails.swiftCode),
                    _row('Bank Name',
                        instruction.intermediaryBankDetails.bankName),
                    _row(
                        'Address', instruction.intermediaryBankDetails.address),
                    _row('Location',
                        instruction.intermediaryBankDetails.location),
                    _row('Country',
                        instruction.intermediaryBankDetails.country.name),
                    _row('ABA/RTN',
                        instruction.intermediaryBankDetails.abaNumber),
                  ],
                ),
              _sectionTitle('Beneficiary Bank Details'),
              _subtitle(
                  'Please fund your account using the following bank instructions:'),
              _row('Swift / BIC', instruction.beneficiaryBankDetails.swiftCode),
              _row('Bank Name', instruction.beneficiaryBankDetails.bankName),
              _row('Address', instruction.beneficiaryBankDetails.address),
              _row('Location', instruction.beneficiaryBankDetails.location),
              _row('Country', instruction.beneficiaryBankDetails.country.name),
              _row('ABA/RTN', instruction.beneficiaryBankDetails.abaNumber),
              _sectionTitle('For Credit To'),
              _row('Account name', instruction.beneficiaryCustomer.accountName),
              _row('Address', instruction.beneficiaryCustomer.address),
              _row('Reference / Message', wallet.number),
              _subtitle(instruction.additionalInstructions),
              const SizedBox(height: 30),
              BlocBuilder<IwtCubit, IwtState>(
                builder: (context, state) => Button(
                  title: 'Save',
                  onPressed: state is IwtFileSaving
                      ? null
                      : () {
                          context.read<IwtCubit>().saveFile(
                                accountId: wallet.id,
                                iwtId: instruction.id,
                              );
                        },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _subtitle(String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 5,
        bottom: 15,
      ),
      child: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.blueGrey,
        ),
      ),
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 200.w,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.blueGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

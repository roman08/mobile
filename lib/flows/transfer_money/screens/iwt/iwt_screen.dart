import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../common/widgets/app_bars/base_app_bar.dart';
import '../../../../common/widgets/app_buttons/button.dart';
import '../../../../common/widgets/fab_utils.dart';
import '../../../../common/widgets/loader/progress_loader.dart';
import '../../../../resources/strings/app_strings.dart';
import '../../../dashboard_flow/bloc/dashboard_bloc.dart';
import '../../../dashboard_flow/entities/wallet_list_wrapper.dart';
import '../../cubit/iwt/iwt_cubit.dart';
import '../../enities/iwt/iwt_instruction_entity.dart';
import 'iwt_instructions_screen.dart';

class IWTScreen extends StatefulWidget {
  @override
  _IWTScreenState createState() => _IWTScreenState();
}

class _IWTScreenState extends State<IWTScreen> {
  final _form = GlobalKey<FormBuilderState>();
  IwtInstruction _currentInstruction;
  Wallet _currentWallet;

  void submit() {
    if (_form.currentState.validate()) {
      context.read<IwtCubit>().iwtLoadEvent();
      Get.to(IwtInstructionsScreen(
        instruction: _currentInstruction,
        wallet: _currentWallet,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final _dashboardBloc = Provider.of<DashboardBloc>(context);

    return BlocListener<IwtCubit, IwtState>(
      listener: (context, state) {
        if (state is IwtInstructionsLoadedState) {
          final instructions = context.bloc<IwtCubit>().instructions;

          if (instructions.length == 1) {
            setState(() {
              _currentInstruction = instructions.first;
            });
          }
        }
      },
      child: Scaffold(
        appBar: BaseAppBar(
          titleString: AppStrings.INCOMING_WIRE_TRANSFER.tr(),
        ),
        body: StreamBuilder<List<Wallet>>(
          stream: _dashboardBloc.iwtWalletListObservable,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return progressLoader();
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: FormBuilder(
                key: _form,
                child: Column(
                  children: [
                    FormBuilderDropdown(
                      attribute: 'wallet',
                      hint: Text(
                        AppStrings.SELECT_WALLET.tr(),
                        style: const TextStyle(color: Colors.blueGrey),
                      ),
                      onChanged: (value) {
                        context
                            .read<IwtCubit>()
                            .loadInstructions(accountId: value);
                        _currentWallet = snapshot.data.firstWhere(
                          (element) => element.id == value,
                          orElse: () => null,
                        );
                      },
                      items: snapshot.data
                          .map(
                            (e) => DropdownMenuItem(
                              value: e.id,
                              child: Text(
                                e.number +
                                    ' ' +
                                    NumberFormat.simpleCurrency(name: '')
                                        .format(
                                      double.parse(e.availableAmount),
                                    ) +
                                    ' ' +
                                    e.type.currencyCode,
                              ),
                            ),
                          )
                          .toList(),
                      validators: [
                        FormBuilderValidators.required(
                          errorText: ErrorStrings.FIELD_IS_REQUIRED.tr(),
                        ),
                      ],
                    ),
                    BlocBuilder<IwtCubit, IwtState>(
                      builder: (context, snapshot) {
                        if (context.bloc<IwtCubit>().instructions == null ||
                            context.bloc<IwtCubit>().instructions.length <= 1) {
                          return const SizedBox();
                        }

                        return FormBuilderDropdown(
                          attribute: 'bankAccount',
                          hint: Text(
                            AppStrings.BANK_ACCOUNT.tr(),
                            style: const TextStyle(color: Colors.blueGrey),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _currentInstruction = context
                                  .bloc<IwtCubit>()
                                  .instructions
                                  .firstWhere(
                                    (element) => element.id == value,
                                    orElse: () => null,
                                  );
                            });
                          },
                          items: context
                              .bloc<IwtCubit>()
                              .instructions
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e.id,
                                  child:
                                      Text(e.beneficiaryBankDetails.bankName),
                                ),
                              )
                              .toList(),
                          validators: [
                            FormBuilderValidators.required(
                              errorText: ErrorStrings.FIELD_IS_REQUIRED.tr(),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        floatingActionButton: BlocBuilder<IwtCubit, IwtState>(
          builder: (context, state) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.w),
            child: Button(
              title: AppStrings.CONTINUE.tr(),
              onPressed:
                  state is IwtInstructionsLoadedState ? () => submit() : null,
            ),
          ),
        ),
        floatingActionButtonLocation: const CenterBottomFabLocation(),
      ),
    );
  }
}

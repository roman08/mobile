import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../common/widgets/app_bars/base_app_bar.dart';
import '../../../../common/widgets/app_buttons/button.dart';
import '../../../../common/widgets/loader/loader_screen.dart';
import '../../../../resources/strings/app_strings.dart';
import '../../../dashboard_flow/bloc/dashboard_bloc.dart';
import '../../../dashboard_flow/entities/wallet_list_wrapper.dart';
import '../../cubit/owt/owt_cubit.dart';
import '../../enities/owt/owt_preview_request.dart';
import '../../enities/owt/owt_request.dart';
import 'owt_preview_screen.dart';

class OWTScreen extends StatefulWidget {
  const OWTScreen({Key key}) : super(key: key);

  @override
  _OWTScreenState createState() => _OWTScreenState();
}

class _OWTScreenState extends State<OWTScreen> {
  final _form = GlobalKey<FormBuilderState>();
  bool _specifyIntermediaryBank = false;
  Wallet currentWallet;

  @override
  Widget build(BuildContext context) {
    final _dashboardBloc = Provider.of<DashboardBloc>(context);

    return BlocConsumer<OwtCubit, OwtState>(
      listener: (context, state) {
        if (state is OwtPreviewLoaded) {
          final owtRequest = OwtRequest();

          final countries = context.read<OwtCubit>().countries;
          final currencies = context.read<OwtCubit>().currencies;

          final bankCountry = countries.firstWhere(
            (element) => element.code == _form.currentState.fields['country'].currentState.value,
            orElse: () => null,
          );

          final currency = currencies.firstWhere(
            (element) => element.code == _form.currentState.fields['currency'].currentState.value,
            orElse: () => null,
          );

          owtRequest.description = _form.currentState.fields['transfer_details'].currentState.value;
          owtRequest.outgoingAmount = _form.currentState.fields['amount'].currentState.value;
          owtRequest.confirmTotalOutgoingAmount = state.preview.totalOutgoingAmount;
          owtRequest.accountIdFrom = _form.currentState.fields['wallet'].currentState.value;
          owtRequest.bankAbaRtn = _form.currentState.fields['aba'].currentState.value;
          owtRequest.bankAddress = _form.currentState.fields['address'].currentState.value;
          owtRequest.bankCountry = bankCountry;
          owtRequest.bankLocation = _form.currentState.fields['location'].currentState.value;
          owtRequest.bankName = _form.currentState.fields['name'].currentState.value;
          owtRequest.bankSwiftBic = _form.currentState.fields['swift'].currentState.value;
          owtRequest.customerAccIban = _form.currentState.fields['bc_iban'].currentState.value;
          owtRequest.customerAddress = _form.currentState.fields['bc_address'].currentState.value;
          owtRequest.customerName = _form.currentState.fields['bc_name'].currentState.value;
          owtRequest.feeId = null;
          owtRequest.isIntermediaryBankRequired =
              _form.currentState.fields['intermediary_bank'].currentState.value ?? false;

          if (owtRequest.isIntermediaryBankRequired) {
            final intermediaryBankCountry = countries.firstWhere(
              (element) => element.code == _form.currentState.fields['ib_country'].currentState.value,
              orElse: () => null,
            );

            owtRequest.intermediaryBankAbaRtn = _form.currentState.fields['ib_aba'].currentState.value;
            owtRequest.intermediaryBankAccIban = _form.currentState.fields['ib_iban'].currentState.value;
            owtRequest.intermediaryBankAddress = _form.currentState.fields['ib_address'].currentState.value;
            owtRequest.intermediaryBankCountry = intermediaryBankCountry;
            owtRequest.intermediaryBankLocation = _form.currentState.fields['ib_location'].currentState.value;
            owtRequest.intermediaryBankName = _form.currentState.fields['ib_name'].currentState.value;
            owtRequest.intermediaryBankSwiftBic = _form.currentState.fields['ib_swift'].currentState.value;
          }

          owtRequest.referenceCurrency = currency;
          owtRequest.refMessage = _form.currentState.fields['message'].currentState.value;

          Get.to(OwtPreviewScreen(
            request: owtRequest,
            wallet: currentWallet,
            fee: state.preview.details.isNotEmpty ? state.preview.details.first : null,
          ));
        }
      },
      builder: (context, state) {
        if (state is OwtCountriesAndCurrenciesLoading) {
          return const LoaderScreen();
        } else {
          return Scaffold(
              appBar: BaseAppBar(
                titleString: AppStrings.OUTGOING_WIRE_TRANSFER.tr(),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent, accentColor: Colors.black),
                  child: Column(
                    children: <Widget>[
                      FormBuilder(
                        key: _form,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            StreamBuilder<List<Wallet>>(
                              stream: _dashboardBloc.walletListObservable,
                              builder: (context, snapshot) => snapshot.data != null
                                  ? FormBuilderDropdown(
                                      attribute: 'wallet',
                                      hint: Text(
                                        AppStrings.SELECT_WALLET.tr(),
                                        style: const TextStyle(color: Colors.blueGrey),
                                      ),
                                      onChanged: (value) => currentWallet = snapshot.data
                                          .firstWhere((element) => element.id == value, orElse: () => null),
                                      items: snapshot.data
                                          .map(
                                            (e) => DropdownMenuItem(
                                              value: e.id,
                                              child: Text(e.number +
                                                  ' ' +
                                                  NumberFormat.simpleCurrency(name: '')
                                                      .format(double.parse(e.availableAmount))),
                                            ),
                                          )
                                          .toList(),
                                      validators: [
                                        FormBuilderValidators.required(
                                          errorText: ErrorStrings.FIELD_IS_REQUIRED.tr(),
                                        ),
                                      ],
                                    )
                                  : const SizedBox(),
                            ),
                            _sectionTitle(AppStrings.SPECIFY_BENEFICIARY_BANK.tr()),
                            _formField('swift', AppStrings.SWIFT_BIC.tr()),
                            _formField('name', AppStrings.NAME.tr()),
                            _formField('address', AppStrings.ADDRESS.tr()),
                            _formField('location', AppStrings.LOCATION.tr()),
                            BlocBuilder<OwtCubit, OwtState>(
                              builder: (context, state) => FormBuilderDropdown(
                                attribute: 'country',
                                hint: Text(AppStrings.COUNTRY.tr() + ' *'),
                                items: context
                                    .bloc<OwtCubit>()
                                    .countries
                                    .map((e) => DropdownMenuItem(
                                          value: e.code,
                                          child: Text(
                                            e.name,
                                            style: const TextStyle(
                                              color: Colors.blueGrey,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                validators: [
                                  FormBuilderValidators.required(
                                    errorText: ErrorStrings.FIELD_IS_REQUIRED.tr(),
                                  ),
                                ],
                              ),
                            ),
                            _formField('aba', AppStrings.ABA_RTN.tr(), required: false),
                            _sectionTitle(AppStrings.SPECIFY_BENEFICIARY_CUSTOMER.tr()),
                            _formField('bc_name', AppStrings.NAME.tr()),
                            _formField('bc_address', AppStrings.ADDRESS.tr()),
                            _formField('bc_iban', AppStrings.IBAN.tr()),
                            _sectionTitle(AppStrings.ADDITIONAL_INFORMATION.tr()),
                            _formField('message', AppStrings.REF_MESSAGE.tr()),
                            const SizedBox(height: 20),
                            FormBuilderCheckbox(
                              onChanged: (value) => setState(() => _specifyIntermediaryBank = value),
                              attribute: 'intermediary_bank',
                              initialValue: false,
                              label: Text(
                                AppStrings.SPECIFY_INTERMEDIARY_BANK.tr(),
                                style: TextStyle(color: Colors.blueGrey, fontSize: 18.ssp),
                              ),
                            ),
                            if (_specifyIntermediaryBank)
                              Column(
                                children: [
                                  _formField('ib_swift', AppStrings.SWIFT_BIC.tr()),
                                  _formField('ib_name', AppStrings.NAME.tr()),
                                  _formField('ib_address', AppStrings.ADDRESS.tr()),
                                  _formField('ib_location', AppStrings.LOCATION.tr()),
                                  BlocBuilder<OwtCubit, OwtState>(
                                    builder: (context, state) => FormBuilderDropdown(
                                      attribute: 'ib_country',
                                      hint: Text(
                                        AppStrings.COUNTRY.tr() + ' *',
                                        style: const TextStyle(color: Colors.blueGrey),
                                      ),
                                      items: context
                                          .bloc<OwtCubit>()
                                          .countries
                                          .map(
                                            (e) => DropdownMenuItem(
                                              value: e.code,
                                              child: Text(
                                                e.name,
                                                style: const TextStyle(
                                                  color: Colors.blueGrey,
                                                ),
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
                                  ),
                                  _formField(
                                    'ib_aba',
                                    AppStrings.ABA_RTN.tr(),
                                    required: false,
                                  ),
                                  _formField('ib_iban', AppStrings.IBAN.tr()),
                                ],
                              ),
                            _sectionTitle(AppStrings.TRANSFER_DETAILS.tr()),
                            _formField('amount', AppStrings.AMOUNT.tr()),
                            BlocBuilder<OwtCubit, OwtState>(
                              builder: (context, state) => FormBuilderDropdown(
                                attribute: 'currency',
                                hint: Text(
                                  AppStrings.CURRENCY.tr() + ' *',
                                  style: const TextStyle(color: Colors.blueGrey),
                                ),
                                items: context
                                    .bloc<OwtCubit>()
                                    .currencies
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e.code,
                                        child: Text(
                                          e.code,
                                          style: const TextStyle(
                                            color: Colors.blueGrey,
                                          ),
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
                            ),
                            _formField('transfer_details', AppStrings.DESCRIPTION.tr(), maxLines: 3, required: false),
                            const SizedBox(height: 30),
                            BlocBuilder<OwtCubit, OwtState>(
                              builder: (context, state) => Button(
                                title: AppStrings.CONTINUE.tr(),
                                onPressed: state is OwtPreviewLoading ? null : () => submit(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ));
        }
      },
    );
  }

  Widget _formField(
    String attribute,
    String label, {
    bool required = true,
    int maxLines = 1,
  }) {
    return FormBuilderTextField(
      attribute: attribute,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label + '${required ? ' *' : ''}',
      ),
      validators: required
          ? [
              FormBuilderValidators.required(
                errorText: ErrorStrings.FIELD_IS_REQUIRED.tr(),
              ),
            ]
          : [],
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(
        top: 40.h,
      ),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.blueGrey,
          fontSize: 18.ssp,
        ),
      ),
    );
  }

  void submit() {
    if (_form.currentState.validate()) {
      context.read<OwtCubit>().owtPreview(OwtPreviewRequest(
            bankName: _form.currentState.fields['name'].currentState.value,
            referenceCurrencyCode: _form.currentState.fields['currency'].currentState.value,
            outgoingAmount: _form.currentState.fields['amount'].currentState.value,
            accountIdFrom: currentWallet.id,
          ));
    }
  }
}

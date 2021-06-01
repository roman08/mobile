import 'dart:math';

import 'package:Velmie/common/repository/currencies_repository.dart';
import 'package:Velmie/common/repository/user_repository.dart';
import 'package:Velmie/flows/dashboard_flow/entities/investment_account_conditions_entity.dart';
import 'package:Velmie/flows/dashboard_flow/repository/dashboard_repository.dart';
import 'package:Velmie/flows/kyc_flow/models/corporate_customer_profile.dart';
import 'package:Velmie/flows/kyc_flow/models/customer_profile.dart';
import 'package:Velmie/flows/kyc_flow/models/individual_customer_profile.dart';
import 'package:Velmie/flows/kyc_flow/repository/kyc_repository.dart';
import 'package:Velmie/flows/sign_in_flow/entities/user.dart';
import 'package:Velmie/flows/transfer_money/enities/common/currency_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:network_utils/resource.dart';

part 'investment_accounts_state.dart';

class InvestmentAccountsCubit extends Cubit<InvestmentAccountsState> {
  final DashboardRepository _dashboardRepository;
  final CurrenciesRepository _currenciesRepository;
  final KycRepository _kycRepository;
  final UserRepository _userRepository;

  InvestmentAccountsCubit({
    @required DashboardRepository dashboardRepository,
    @required CurrenciesRepository currenciesRepository,
    @required KycRepository kycRepository,
    @required UserRepository userRepository,
  })  : assert(dashboardRepository != null),
        assert(currenciesRepository != null),
        assert(kycRepository != null),
        assert(userRepository != null),
        _dashboardRepository = dashboardRepository,
        _currenciesRepository = currenciesRepository,
        _kycRepository = kycRepository,
        _userRepository = userRepository,
        super(const InvestmentAccountsState());

  void init() async {
    _loadCurrencies();
    await _loadConditions();
    _checkMinimumBalance();
  }

  void requestAccount({
    int optionId,
    String currency,
  }) async {

    print('%%%%&&&&&&&&&&&&&& HOLA HOLA %%%%&&&&&&&&&&&&&&');
    print(optionId);
    print(currency);
    emit(state.copyWith(loading: true, additionalKycRequired: false, accountRequested: false, acountEvolve: false, acountDinamyc: false, acountPerformance: false));

    // await _checkKyc();

    // if (state.additionalKycRequired) {
    //   return;
    // }

    await for (final resource in _dashboardRepository.requestInvestmentAccount(
      optionId: optionId,
      currency: currency,
    )) {
      if (resource.status == Status.success) {
        switch (optionId) {
          case 1:
            emit(state.copyWith(loading: false, accountRequested: true, acountEvolve: true, acountDinamyc: false, acountPerformance: false));
            break;
          case 2:
            emit(state.copyWith(loading: false, accountRequested: true, acountEvolve: false, acountDinamyc: true, acountPerformance: false));
            break;
          case 3:
            emit(state.copyWith(loading: false, accountRequested: true, acountEvolve: false, acountDinamyc: false, acountPerformance: true));
            break;
          default:
        }
        emit(state.copyWith(loading: false, accountRequested: true));
        break;
      } else if (resource.status == Status.error) {
        emit(state.copyWith(loading: false));
        break;
      }
    }
  }

  Future<void> _checkKyc() async {
    UserData user;

    await for (final resource in _userRepository.getUserData()) {
      if (resource.status == Status.success) {
        user = resource.data;
        break;
      } else if (resource.status == Status.error) {
        return;
      }
    }

    await for (final resource in _kycRepository.getTiers()) {
      if (resource.status == Status.success) {
        CustomerProfile profile;

        if (user.isCorporate) {
          profile = CorporateCustomerProfile.fromTier(resource.data.last);
        } else {
          profile = IndividualCustomerProfile.fromTier(resource.data.last);
        }

        final kycRequired = (user.isCorporate && profile.sourceOfFunds.isEmpty) ||
            profile.accountNumber.isEmpty ||
            profile.bankName.isEmpty ||
            profile.bankAddress.isEmpty ||
            profile.proofTaxId.isEmpty ||
            profile.proofIncomeStatement.isEmpty ||
            profile.lastBankAccountStatement.isEmpty;

        emit(state.copyWith(additionalKycRequired: kycRequired, loading: false));
        return;
      } else if (resource.status == Status.error) {
        emit(state.copyWith(loading: false));
        return;
      }
    }
  }

  void _checkMinimumBalance() async {
    await for (final resource in _dashboardRepository.getWallets()) {
      if (resource.status == Status.success) {
        final wallets = resource.data;

        final minBalance = state.conditions.map((balance) => balance.minFunds).reduce(min);

        emit(state.copyWith(
          accountsAvailable: wallets.isNotEmpty && double.parse(wallets.first.availableAmount) >= minBalance,
        ));
        return;
      } else if (resource.status == Status.error) {
        return;
      }
    }
  }

  Future<void> _loadConditions() async {
    await for (final resource in _dashboardRepository.getInvestmentAccountsConditions()) {
      if (resource.status == Status.success) {
        emit(state.copyWith(conditions: resource.data));
        return;
      } else if (resource.status == Status.error) {
        return;
      }
    }
  }

  Future<void> _loadCurrencies() async {
    await for (final resource in _currenciesRepository.getCurrencies()) {
      if (resource.status == Status.success) {
        print(resource.data);
        emit(state.copyWith(currencies: resource.data));
        return;
      } else if (resource.status == Status.error) {
        return;
      }
    }
  }
}

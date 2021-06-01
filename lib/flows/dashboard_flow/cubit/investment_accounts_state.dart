part of 'investment_accounts_cubit.dart';

@immutable
class InvestmentAccountsState {
  final bool loading;
  final List<InvestmentAccountConditionsEntity> conditions;
  final List<CurrencyEntity> currencies;
  final bool accountsAvailable;
  final bool additionalKycRequired;
  final bool accountRequested;
  final bool acountEvolve;
  final bool acountDinamyc;
  final bool acountPerformance;
  

  const InvestmentAccountsState({
    this.loading = false,
    this.conditions,
    this.currencies,
    this.accountsAvailable = false,
    this.additionalKycRequired,
    this.accountRequested,
    this.acountEvolve,
    this.acountDinamyc,
    this.acountPerformance,
  });

  InvestmentAccountsState copyWith({
    bool loading,
    List<InvestmentAccountConditionsEntity> conditions,
    List<CurrencyEntity> currencies,
    bool accountsAvailable,
    bool additionalKycRequired,
    bool accountRequested,
    bool acountEvolve,
    bool acountDinamyc,
    bool acountPerformance
  }) {
    return InvestmentAccountsState(
      loading: loading ?? this.loading,
      conditions: conditions ?? this.conditions,
      currencies: currencies ?? this.currencies,
      accountsAvailable: accountsAvailable ?? this.accountsAvailable,
      additionalKycRequired: additionalKycRequired ?? this.additionalKycRequired,
      accountRequested: accountRequested ?? this.accountRequested,
      acountEvolve: acountEvolve ?? this.acountEvolve,
      acountDinamyc: acountDinamyc ?? this.acountDinamyc,
      acountPerformance: acountPerformance ?? this.acountPerformance,
    );
  }
}

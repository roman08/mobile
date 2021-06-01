import 'package:Velmie/flows/dashboard_flow/entities/investment_account_conditions_entity.dart';
import 'package:api_error_parser/api_error_parser.dart';
import 'package:flutter/cupertino.dart';
import 'package:network_utils/network_bound_resource.dart';
import 'package:network_utils/resource.dart';

import '../../../app.dart';
import '../../../networking/api_providers/accounts_api_provider.dart';
import '../entities/transaction/request_entity.dart';
import '../entities/transaction/request_enum.dart';
import '../entities/wallet_list_wrapper.dart';

class DashboardRepository {
  final ApiParser<String> _apiParser;
  final AccountsApiProvider _apiProvider;

  DashboardRepository(this._apiParser, this._apiProvider);

  // TODO(dmitrykuzhelko): Need to refactor and remove, then change to "getWallets()" function.
  Future<List<Wallet>> loadWallets({bool forIwt = false}) async {
    return _apiProvider.getWalletsOLD(forIwt: forIwt);
  }

  Stream<Resource<List<Wallet>, String>> getWallets() {
    final networkClient = NetworkBoundResource<List<Wallet>, WalletListWrapper, String>(
      _apiParser,
      saveCallResult: (WalletListWrapper item) async => item.walletList,
      createCall: () => _apiProvider.getWallets(),
      loadFromCache: () => null,
      shouldFetch: (data) => true,
    );
    return networkClient.asStream();
  }

  Stream<Resource<List<RequestEntity>, String>> getRequests({
    @required DateTime from,
    @required DateTime to,
    @required int page,
    RequestCategory category,
    String query,
    RequestOperation operation,
  }) {
    final networkClient = NetworkBoundResource<List<RequestEntity>, List<RequestEntity>, String>(
      _apiParser,
      saveCallResult: (item) async {
        return item;
      },
      createCall: () {
        return _apiProvider.getRequests(
          from: from,
          to: to,
          page: page,
          category: category,
          query: query,
          operation: operation,
        );
      },
      loadFromCache: () {
        return null;
      },
      shouldFetch: (data) {
        return true;
      },
      paginationCall: (pagination) {
        logger.d("paggination = $pagination");
      },
    );
    return networkClient.asStream();
  }

  Stream<Resource<List<InvestmentAccountConditionsEntity>, String>> getInvestmentAccountsConditions() {
    final networkClient =
        NetworkBoundResource<List<InvestmentAccountConditionsEntity>, List<InvestmentAccountConditionsEntity>, String>(
      _apiParser,
      saveCallResult: (item) async => item,
      createCall: () => _apiProvider.getInvestmentAccountsConditions(),
      loadFromCache: () => null,
      shouldFetch: (data) => true,
    );
    return networkClient.asStream();
  }

  Stream<Resource<void, String>> requestInvestmentAccount({
    int optionId,
    String currency,
  }) {
    final networkClient =
        NetworkBoundResource<void, void, String>(
      _apiParser,
      saveCallResult: (item) async => item,
      createCall: () => _apiProvider.requestInvestmentAccount(
        optionId: optionId,
        currency: currency,
      ),
      loadFromCache: () => null,
      shouldFetch: (data) => true,
    );
    return networkClient.asStream();
  }
}

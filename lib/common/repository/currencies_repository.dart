import 'package:Velmie/flows/transfer_money/enities/common/currency_entity.dart';
import 'package:Velmie/networking/api_providers/accounts_api_provider.dart';
import 'package:api_error_parser/api_parser.dart';
import 'package:network_utils/network_bound_resource.dart';
import 'package:network_utils/resource.dart';

class CurrenciesRepository {
  final ApiParser<String> _apiParser;
  final AccountsApiProvider _apiProvider;

  CurrenciesRepository(this._apiParser, this._apiProvider);

  Stream<Resource<List<CurrencyEntity>, String>> getCurrencies({
    int accountIdFrom,
    String accountNumberTo,
    String outgoingAmount,
    String userName,
  }) {
    final networkClient = NetworkBoundResource<List<CurrencyEntity>,
        List<CurrencyEntity>, String>(
      _apiParser,
      saveCallResult: (List<CurrencyEntity> item) async => item,
      createCall: () => _apiProvider.getCurrencies(),
      loadFromCache: () => null,
      shouldFetch: (data) => true,
    );
    return networkClient.asStream();
  }
}
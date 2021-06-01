import 'package:api_error_parser/api_parser.dart';
import 'package:network_utils/network_bound_resource.dart';
import 'package:network_utils/resource.dart';

import '../../../networking/api_providers/accounts_api_provider.dart';
import '../enities/common/country_entity.dart';
import '../enities/common/currency_entity.dart';
import '../enities/owt/owt_preview_request.dart';
import '../enities/owt/owt_preview_response.dart';
import '../enities/owt/owt_request.dart';

class OwtRepository {
  final ApiParser<String> _apiParser;
  final AccountsApiProvider _apiProvider;

  OwtRepository(this._apiParser, this._apiProvider);

  Stream<Resource<List<CountryEntity>, String>> getCountries({
    int accountIdFrom,
    String accountNumberTo,
    String outgoingAmount,
    String userName,
  }) {
    final networkClient =
        NetworkBoundResource<List<CountryEntity>, List<CountryEntity>, String>(
      _apiParser,
      saveCallResult: (List<CountryEntity> item) async => item,
      createCall: () => _apiProvider.getCountries(),
      loadFromCache: () => null,
      shouldFetch: (data) => true,
    );
    return networkClient.asStream();
  }

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

  Stream<Resource<OwtPreviewResponse, String>> owtPreview({
    String bankName,
    int accountIdFrom,
    String outgoingAmount,
    String referenceCurrencyCode,
  }) {
    final networkClient =
        NetworkBoundResource<OwtPreviewResponse, OwtPreviewResponse, String>(
      _apiParser,
      saveCallResult: (OwtPreviewResponse item) async => item,
      createCall: () => _apiProvider.owtPreview(
        bankName: bankName,
        accountIdFrom: accountIdFrom,
        outgoingAmount: outgoingAmount,
        referenceCurrencyCode: referenceCurrencyCode,
      ),
      loadFromCache: () => null,
      shouldFetch: (data) => true,
    );
    return networkClient.asStream();
  }

  Stream<Resource<int, String>> owtPerformRequest({
    OwtRequest request,
  }) {
    final networkClient = NetworkBoundResource<int, int, String>(
      _apiParser,
      saveCallResult: (int item) async => item,
      createCall: () => _apiProvider.performOwtRequest(request: request),
      loadFromCache: () => null,
      shouldFetch: (data) => true,
    );
    return networkClient.asStream();
  }
}

import 'package:Velmie/flows/transfer_money/enities/common/country_entity.dart';
import 'package:Velmie/networking/api_providers/accounts_api_provider.dart';
import 'package:api_error_parser/api_parser.dart';
import 'package:network_utils/network_bound_resource.dart';
import 'package:network_utils/resource.dart';

class CountriesRepository {
  final ApiParser<String> _apiParser;
  final AccountsApiProvider _apiProvider;

  CountriesRepository(this._apiParser, this._apiProvider);

  Stream<Resource<List<CountryEntity>, String>> getCountries() {
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
}

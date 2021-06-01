import 'package:api_error_parser/api_error_parser.dart';
import 'package:network_utils/network_bound_resource.dart';
import 'package:network_utils/resource.dart';

import '../../../networking/api_providers/accounts_api_provider.dart';
import '../enities/common/common_preview_response.dart';
import '../enities/tbu_request/tbu_request_preview_request.dart';
import '../enities/tbu_request/tbu_request_request.dart';
import '../send/send_by_request/entities/request_transaction_response.dart';

class TbuRequestRepository {
  final ApiParser<String> _apiParser;
  final AccountsApiProvider _apiProvider;

  TbuRequestRepository(this._apiParser, this._apiProvider);

  Stream<Resource<CommonPreviewResponse, String>> tbuRequestPreview(
      TbuRequestPreviewRequest requestData) {
    final networkClient =
        NetworkBoundResource<CommonPreviewResponse, CommonPreviewResponse, String>(
      _apiParser,
      saveCallResult: (CommonPreviewResponse item) async => item,
      createCall: () => _apiProvider.tbuRequestPreview(requestData),
      loadFromCache: () => null,
      shouldFetch: (data) => true,
    );
    return networkClient.asStream();
  }

  Stream<Resource<RequestMoneyResponse, String>> tbuRequest(
      TbuRequestRequest requestData) {
    final networkClient = NetworkBoundResource<RequestMoneyResponse,
        RequestMoneyResponse, String>(
      _apiParser,
      saveCallResult: (RequestMoneyResponse item) async => item,
      createCall: () => _apiProvider.tbuRequest(requestData),
      loadFromCache: () => null,
      shouldFetch: (data) => true,
    );
    return networkClient.asStream();
  }
}

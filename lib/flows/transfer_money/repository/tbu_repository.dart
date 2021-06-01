import 'package:api_error_parser/api_error_parser.dart';
import 'package:network_utils/network_bound_resource.dart';
import 'package:network_utils/resource.dart';

import '../../../networking/api_providers/accounts_api_provider.dart';
import '../enities/tbu/tbu_preview_request.dart';
import '../enities/common/common_preview_response.dart';
import '../enities/tbu/tbu_request.dart';
import '../enities/tbu/tbu_response.dart';
import '../enities/tbu/tbu_tfa_request.dart';
import '../enities/tbu_request/request_from_contact.dart';
import '../request/entities/request_from_contact_response.dart';

class TbuRepository {
  final ApiParser<String> _apiParser;
  final AccountsApiProvider _apiProvider;

  TbuRepository(this._apiParser, this._apiProvider);

  Stream<Resource<CommonPreviewResponse, String>> tbuPreview(
      TbuPreviewRequest requestData) {
    final networkClient =
        NetworkBoundResource<CommonPreviewResponse, CommonPreviewResponse, String>(
      _apiParser,
      saveCallResult: (CommonPreviewResponse item) async => item,
      createCall: () => _apiProvider.tbuPreview(requestData),
      loadFromCache: () => null,
      shouldFetch: (data) => true,
    );
    return networkClient.asStream();
  }

  Stream<Resource<TbuResponse, String>> tbu(TbuRequest requestModel) {
    final networkClient =
        NetworkBoundResource<TbuResponse, TbuResponse, String>(_apiParser,
            saveCallResult: (TbuResponse item) async => item,
            createCall: () => _apiProvider.tbu(requestModel),
            loadFromCache: () => null,
            shouldFetch: (data) => true);
    return networkClient.asStream();
  }

  Stream<Resource<RequestFromContactResponse, String>> requestFromContact(
      RequestFromContact requestData) {
    final networkClient =
        NetworkBoundResource<RequestFromContactResponse, RequestFromContactResponse, String>(
      _apiParser,
      saveCallResult: (RequestFromContactResponse item) async => item,
      createCall: () => _apiProvider.requestFromContact(requestData),
      loadFromCache: () => null,
      shouldFetch: (data) => true,
    );
    return networkClient.asStream();
  }
}

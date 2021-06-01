import 'dart:ffi';
import 'dart:typed_data';

import 'package:Velmie/flows/transfer_money/enities/iwt/iwt_instruction_entity.dart';
import 'package:Velmie/networking/api_providers/accounts_api_provider.dart';
import 'package:api_error_parser/api_parser.dart';
import 'package:network_utils/network_bound_resource.dart';
import 'package:network_utils/resource.dart';

class IwtRepository {
  final ApiParser<String> _apiParser;
  final AccountsApiProvider _apiProvider;

  IwtRepository(this._apiParser, this._apiProvider);

  Stream<Resource<List<IwtInstruction>, String>> loadInstructions({
    int accountId,
  }) {
    final networkClient = NetworkBoundResource<List<IwtInstruction>,
        List<IwtInstruction>, String>(
      _apiParser,
      saveCallResult: (List<IwtInstruction> item) async => item,
      createCall: () => _apiProvider.getIwtInstructions(accountId: accountId),
      loadFromCache: () => null,
      shouldFetch: (data) => true,
    );
    return networkClient.asStream();
  }

  Stream<Resource<Uint8List, String>> downloadPdf({
    int accountId,
    int iwtId,
  }) {
    final networkClient = NetworkBoundResource<Uint8List, Uint8List, String>(
      _apiParser,
      saveCallResult: (Uint8List item) async => item,
      createCall: () => _apiProvider.getIwtPdfFile(
        accountId: accountId,
        iwtId: iwtId,
      ),
      loadFromCache: () => null,
      shouldFetch: (data) => true,
    );
    return networkClient.asStream();
  }
}

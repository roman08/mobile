import 'dart:io';
import 'dart:typed_data';

import 'package:Velmie/common/session/session_repository.dart';
import 'package:Velmie/networking/api_providers/auth_api_provider.dart';
import 'package:api_error_parser/api_error_parser.dart';
import 'package:network_utils/network_bound_resource.dart';
import 'package:network_utils/resource.dart';

import '../../../networking/api_providers/file_provider.dart';
import '../models/current_tier_result.dart';
import '../models/requirement_request.dart';
import '../models/tiers_result.dart';
import '../providers/kyc_provider.dart';
import '../../../app.dart';

class KycRepository {
  final KycProvider _apiProvider;
  final FileProvider _fileProvider;
  final ApiParser<String> _apiParser;
  final AuthApiProvider _authApiProvider;
  final SessionRepository _sessionRepository;

  KycRepository(
    this._apiParser,
    this._apiProvider,
    this._fileProvider,
    this._authApiProvider,
    this._sessionRepository,
  );

  factory KycRepository.create(
    ApiParser<String> _apiParser,
    KycProvider kycProvider,
    FileProvider fileProvider,
    AuthApiProvider authApiProvider,
    SessionRepository sessionRepository,
  ) {
    return KycRepository(_apiParser, kycProvider, fileProvider, authApiProvider, sessionRepository);
  }

  Stream<Resource<List<Tier>, String>> getTiers() {
    final networkClient =
        NetworkBoundResource<List<Tier>, List<Tier>, String>(_apiParser, saveCallResult: (List<Tier> items) async {
          
          print('%%%%%%%%%%%%%%%%%%%%%%%% holaaaaa');
          print(items);
      return items;
    }, createCall: () {
      return _apiProvider.getTiers();
    }, loadFromCache: () {
      return null;
    }, shouldFetch: (data) {
      return true;
    });
    return networkClient.asStream();
  }

  Stream<Resource<CurrentTier, String>> getCurrentTier() {
    final networkClient =
        NetworkBoundResource<CurrentTier, CurrentTier, String>(_apiParser, saveCallResult: (CurrentTier item) async {
          logger.d('aqui los datos de tier');
          logger.d(item);
      return item;
    }, createCall: () {
      return _apiProvider.getCurrentTier();
    }, loadFromCache: () {
      return null;
    }, shouldFetch: (data) {
      return true;
    });
    return networkClient.asStream();
  }

  Stream<Resource<void, String>> sendRequest({int id}) {
    final networkClient = NetworkBoundResource<void, void, String>(_apiParser, saveCallResult: (void item) async {
      return item;
    }, createCall: () {
      return _apiProvider.sendRequest(id: id);
    }, loadFromCache: () {
      return null;
    }, shouldFetch: (data) {
      return true;
    });
    return networkClient.asStream();
  }

  Stream<Resource<Tier, String>> getTier({int id}) {
    final networkClient = NetworkBoundResource<Tier, Tier, String>(_apiParser, saveCallResult: (Tier item) async {
      logger.d('VERIFICANDO TIER');
      print(item);
      for (var i = 0; i < item.requirements.length; i++) {
        final requirement = item.requirements[i];

        for (var j = 0; j < requirement.elements.length; j++) {
          final element = requirement.elements[j];
          if (element.index == ElementIndex.selfiePhoto ||
              element.index == ElementIndex.scannedIdentification ||
              element.index == ElementIndex.scanned) {
            if (element.value != 'null' && element.value.isNotEmpty) {
              final id = int.parse(element.value);

              final list = await _fileProvider.getBin(id: id);
              final bytes = Uint8List.fromList(list);

              element.bytes = bytes;

              item.requirements[i].elements[j] = element;
            }
          }
        }
      }

      return item;
    }, createCall: () {
      return _apiProvider.getTier(id: id);
    }, loadFromCache: () {
      return null;
    }, shouldFetch: (data) {
      return true;
    });
    return networkClient.asStream();
  }

  Stream<Resource<void, String>> updateRequirement({
    RequirementRequest requirement,
    int id,
  }) {
    final networkClient = NetworkBoundResource<void, void, String>(_apiParser, saveCallResult: (void item) async {
      return item;
    }, createCall: () async {
      String uid = _sessionRepository.uid;

      if (uid == null) {
        final user = await _authApiProvider.getUserUser();
        uid = user.data.uid;
      }
  print('********* REQUERIMIENTOS -- LENGTH************');
        print(requirement.values.length);
      for (var i = 0; i < requirement.values.length; i++) {
        print('********* REQUERIMIENTOS -- NULL ************');
        print(requirement.values[i].index);
        final value = requirement.values[i];
        if (value.value.isEmpty) {
          continue;
        }

        if (value.index == ElementIndex.idFront ||
            value.index == ElementIndex.idBack ||
            value.index == ElementIndex.selfiePhoto ||
            value.index == ElementIndex.proofPermanentAddress ||
            value.index == ElementIndex.beneficialOfficialId ||
            value.index == ElementIndex.beneficialProofPermanentAddress ||
            value.index == ElementIndex.articleIncorporation ||
            value.index == ElementIndex.proofTaxIdNumber ||
            value.index == ElementIndex.proofPermanentAddressRepresentative ||
            value.index == ElementIndex.proofPermanentAddressCompany ||
            value.index == ElementIndex.affidavitAccount ||
            value.index == ElementIndex.proofIncomeStatement ||
            value.index == ElementIndex.lastBankAccountStatement) {
          final file = File(value.value);

 print('********* REQUERIMIENTOS FILE************');
        print(file.isAbsolute);
          if (file.isAbsolute) {
            try {
              final info = await _fileProvider.uploadFile(path: value.value, uid: uid);
print('********* REQUERIMIENTOS INFO************');
        print(info.errors);
        print(info.data);
              /// If we get error while uploading
              if (info.data == null && info.errors.isNotEmpty) {
                throw info.errors.first.code;
              }

              requirement.values[i] = ElementValue(
                index: value.index,
                value: info.data.id.toString(),
              );
            } catch (errorCode) {
              /// Throw error and exit from the function
              return ApiResponseEntity(null, [ErrorMessageEntity(errorCode, null, null)]);
            }
          }
        }
      }
    
      return await _apiProvider.updateRequirement(
        id: id,
        requirement: requirement,
      );
    }, loadFromCache: () {
      return null;
    }, shouldFetch: (data) {
     
      return true;
    });
    return networkClient.asStream();
  }

  Stream<Resource<void, String>> generateNewPhoneCode() {
    final networkClient = NetworkBoundResource<void, void, String>(_apiParser, saveCallResult: (void item) async {
      return item;
    }, createCall: () async {
      return _apiProvider.generateNewPhoneCode();
    }, loadFromCache: () {
      return null;
    }, shouldFetch: (data) {
      return true;
    });
    return networkClient.asStream();
  }

  Stream<Resource<void, String>> generateNewEmailCode() {
    final networkClient = NetworkBoundResource<void, void, String>(_apiParser, saveCallResult: (void item) async {
      return item;
    }, createCall: () async {
      return _apiProvider.generateNewEmailCode();
    }, loadFromCache: () {
      return null;
    }, shouldFetch: (data) {
      return true;
    });
    return networkClient.asStream();
  }

  Stream<Resource<void, String>> checkEmailCode({
    String code,
  }) {
    final networkClient = NetworkBoundResource<void, void, String>(_apiParser, saveCallResult: (void item) async {
      return item;
    }, createCall: () async {
      return _apiProvider.checkEmailCode(code: code);
    }, loadFromCache: () {
      return null;
    }, shouldFetch: (data) {
      return true;
    });
    return networkClient.asStream();
  }

  Stream<Resource<void, String>> checkPhoneCode({
    String code,
  }) {
    final networkClient = NetworkBoundResource<void, void, String>(_apiParser, saveCallResult: (void item) async {
      return item;
    }, createCall: () async {
      return _apiProvider.checkPhoneCode(code: code);
    }, loadFromCache: () {
      return null;
    }, shouldFetch: (data) {
      return true;
    });
    return networkClient.asStream();
  }

  Stream<Resource<Uint8List, String>> getTermsAndConditionsDoc({String documentId}) {
    final networkClient = NetworkBoundResource<Uint8List, Uint8List, String>(
      _apiParser,
      saveCallResult: (item) async {
        return item;
      },
      createCall: () async {
        return _apiProvider.getTermsAndConditionsDoc(documentId: documentId);
      },
      loadFromCache: () {
        return null;
      },
      shouldFetch: (data) {
        return true;
      },
    );
    return networkClient.asStream();
  }

  Stream<Resource<String, String>> getSignatureLink({String language}) {
    final networkClient = NetworkBoundResource<String, String, String>(
      _apiParser,
      saveCallResult: (item) async {
        return item;
      },
      createCall: () async {
        return _apiProvider.getSignatureLink(language: language);
      },
      loadFromCache: () {
        return null;
      },
      shouldFetch: (data) {
        return true;
      },
    );
    return networkClient.asStream();
  }

  Future<Uint8List> getDocument({String id}) async {
    if (id != null) {
      final list = await _fileProvider.getBin(id: int.parse(id));
      return Uint8List.fromList(list);
    } else {
      return Uint8List(0);
    }
  }

  Future<bool> checkKycStatus() async {
    final tier = await _apiProvider.getCurrentTier();
    return tier.data.level != 0;
  }
}

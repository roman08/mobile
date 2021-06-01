import 'package:Velmie/flows/cards_flow/enums/card_status.dart';
import 'package:Velmie/networking/api_constants.dart';
import 'package:Velmie/networking/api_providers/file_provider.dart';
import 'package:Velmie/networking/network_client.dart';
import 'package:api_error_parser/entity/api_response/api_response_entity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../entities.dart';

class CardsApiProvider {
  final NetworkClient _networkClient;
  final FileProvider _fileProvider;

  CardsApiProvider({
    @required NetworkClient networkClient,
    @required FileProvider fileProvider,
  })  : assert(networkClient != null),
        assert(fileProvider != null),
        _fileProvider = fileProvider,
        _networkClient = networkClient;

  final ApiConstants _apiConstants = ApiConstants();

  Future<ApiResponseEntity<void>> requestCard() async {
    try {
      await _networkClient.dio.post(_apiConstants.cards.request);
      return ApiResponseEntity(null, null);
    } on DioError catch (error) {
      return ApiResponseEntity.fromJson(
        error.response.data as Map<String, dynamic>,
        null,
      );
    }
  }

  Future<ApiResponseEntity<CardStatus>> checkCardStatus() async {
    try {
      final response = await _networkClient.dio.get(_apiConstants.cards.activeRequest);

      final data = response.data['data'];
      CardStatus status;
      if (data != null) {
        status = CardStatus.values.firstWhere((status) => status == data['status'], orElse: () => CardStatus.unknown);
      } else {
        status = CardStatus.notRequested;
      }

      return ApiResponseEntity(status, null);
    } on DioError catch (error) {
      return ApiResponseEntity.fromJson(
        error.response.data as Map<String, dynamic>,
        null,
      );
    }
  }

  Future<ApiResponseEntity<CardDocuments>> getDocuments() async {
    try {
      final response = await _networkClient.dio.get(_apiConstants.cards.settings);

      final data = response.data['data'] as List<dynamic>;
      final termsAndConditions = data.firstWhere((element) => element['name'] == 'card_terms_and_conditions');
      final fees = data.firstWhere((element) => element['name'] == 'card_related_fees');

      final termsAndConditionsFile = _fileProvider.getBin(id: int.parse(termsAndConditions['value']));
      final fessFile = _fileProvider.getBin(id: int.parse(fees['value']));

      final files = await Future.wait([
        termsAndConditionsFile,
        fessFile,
      ]);

      return ApiResponseEntity(CardDocuments(
        termsAndConditions: files[0],
        fees: files[1],
      ), null);
    } on DioError catch (error) {
      return ApiResponseEntity.fromJson(
        error.response.data as Map<String, dynamic>,
        null,
      );
    } catch (error, stack) {
      print('Cards error');
      print(error);
      print(stack);
    }
  }
}

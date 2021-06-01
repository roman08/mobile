import 'package:Velmie/flows/cards_flow/entities.dart';
import 'package:Velmie/flows/cards_flow/enums/card_status.dart';
import 'package:Velmie/flows/cards_flow/providers/cards_api_provider.dart';
import 'package:api_error_parser/api_parser.dart';
import 'package:flutter/foundation.dart';
import 'package:network_utils/network_bound_resource.dart';
import 'package:network_utils/resource.dart';

class CardsRepository {
  final ApiParser<String> _apiParser;
  final CardsApiProvider _cardsApiProvider;

  const CardsRepository({
    @required ApiParser<String> apiParser,
    @required CardsApiProvider cardsApiProvider,
  })  : assert(apiParser != null),
        assert(cardsApiProvider != null),
        _apiParser = apiParser,
        _cardsApiProvider = cardsApiProvider;

  Stream<Resource<void, String>> requestCard() {
    final networkClient = NetworkBoundResource<void, void, String>(
      _apiParser,
      saveCallResult: (item) async => item,
      createCall: () => _cardsApiProvider.requestCard(),
      loadFromCache: () => null,
      shouldFetch: (data) => true,
    );
    return networkClient.asStream();
  }

  Stream<Resource<CardStatus, String>> checkCardStatus() {
    final networkClient = NetworkBoundResource<CardStatus, CardStatus, String>(
      _apiParser,
      saveCallResult: (item) async => item,
      createCall: () => _cardsApiProvider.checkCardStatus(),
      loadFromCache: () => null,
      shouldFetch: (data) => true,
    );
    return networkClient.asStream();
  }

  Stream<Resource<CardDocuments, String>> getDocuments() {
    final networkClient = NetworkBoundResource<CardDocuments, CardDocuments, String>(
      _apiParser,
      saveCallResult: (item) async => item,
      createCall: () => _cardsApiProvider.getDocuments(),
      loadFromCache: () => null,
      shouldFetch: (data) => true,
    );
    return networkClient.asStream();
  }
}

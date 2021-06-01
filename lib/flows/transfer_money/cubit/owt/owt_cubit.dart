import 'package:api_error_parser/entity/parser_response/parser_message_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:network_utils/resource.dart';

import '../../../../common/session/session_repository.dart';
import '../../enities/common/country_entity.dart';
import '../../enities/common/currency_entity.dart';
import '../../enities/owt/owt_preview_request.dart';
import '../../enities/owt/owt_preview_response.dart';
import '../../enities/owt/owt_request.dart';
import '../../repository/owt_repository.dart';

part 'owt_state.dart';

class OwtCubit extends Cubit<OwtState> {
  final OwtRepository _repository;
  final SessionRepository _sessionRepository;
  OwtPreviewResponse previewResponse;
  OwtPreviewRequest owtPreviewRequest;
  OwtRequest owtRequest;
  List<CurrencyEntity> currencies = [];
  List<CountryEntity> countries = [];

  OwtCubit(this._repository, this._sessionRepository) : super(OwtInitial());

  String getCurrentUserPhone() {
    return _sessionRepository.userData.value.phoneNumber;
  }

  void loadCountries() async {
    await for (final resource in _repository.getCountries()) {
      if (resource.status == Status.success) {
        countries = resource.data;
        emit(OwtCountriesLoaded());
        return;
      }
    }
  }

  void loadCurrencies() async {
    await for (final resource in _repository.getCurrencies()) {
      if (resource.status == Status.success) {
        currencies = resource.data;
        emit(OwtCurrenciesLoaded());
        return;
      }
    }
  }

  void loadCountriesAndCurrencies() async {
    emit(OwtCountriesAndCurrenciesLoading());

    await for (final resource in _repository.getCountries()) {
      if (resource.status == Status.success) {
        countries = resource.data;
        break;
      }
    }

    await for (final resource in _repository.getCurrencies()) {
      if (resource.status == Status.success) {
        currencies = resource.data;
        emit(OwtCountriesAndCurrenciesLoaded());
        return;
      }
    }
  }

  void owtPreview(OwtPreviewRequest requestData) async {
    emit(OwtPreviewLoading());
    this.owtPreviewRequest = requestData;
    await for (final resource in _repository.owtPreview(
      bankName: requestData.bankName,
      accountIdFrom: requestData.accountIdFrom,
      outgoingAmount: requestData.outgoingAmount,
      referenceCurrencyCode: requestData.referenceCurrencyCode,
    )) {
      if (resource.status == Status.success) {
        previewResponse = resource.data;
        emit(OwtPreviewLoaded(resource.data));
        return;
      } else if (resource.status == Status.error) {
        emit(OwtPreviewFailed(resource.errors));
        return;
      }
    }
  }

  void owtPerformRequest() async {
    emit(OwtRequestPerforming());
    await for (final resource
        in _repository.owtPerformRequest(request: owtRequest)) {
      if (resource.status == Status.success) {
        emit(OwtRequestPerformed(resource.data));
        _clearData();
        return;
      } else if (resource.status == Status.error) {
        emit(OwtRequestFailed(resource.errors));
        return;
      }
    }
  }

  void _clearData() {
    previewResponse = null;
    owtPreviewRequest = null;
    owtRequest = null;
  }
}

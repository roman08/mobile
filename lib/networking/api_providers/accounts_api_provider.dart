import 'dart:typed_data';

import 'package:Velmie/flows/dashboard_flow/entities/investment_account_conditions_entity.dart';
import 'package:api_error_parser/api_error_parser.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../../app.dart';
import '../../flows/dashboard_flow/entities/transaction/request_entity.dart';
import '../../flows/dashboard_flow/entities/transaction/request_enum.dart';
import '../../flows/dashboard_flow/entities/wallet_list_wrapper.dart';
import '../../flows/transfer_money/enities/common/common_preview_response.dart';
import '../../flows/transfer_money/enities/common/country_entity.dart';
import '../../flows/transfer_money/enities/common/currency_entity.dart';
import '../../flows/transfer_money/enities/common/wallet_entity.dart';
import '../../flows/transfer_money/enities/iwt/iwt_instruction_entity.dart';
import '../../flows/transfer_money/enities/owt/owt_preview_response.dart';
import '../../flows/transfer_money/enities/owt/owt_request.dart';
import '../../flows/transfer_money/enities/tbu/tbu_preview_request.dart';
import '../../flows/transfer_money/enities/tbu/tbu_request.dart';
import '../../flows/transfer_money/enities/tbu/tbu_response.dart';
import '../../flows/transfer_money/enities/tbu_request/request_from_contact.dart';
import '../../flows/transfer_money/enities/tbu_request/tbu_request_preview_request.dart';
import '../../flows/transfer_money/enities/tbu_request/tbu_request_request.dart';
import '../../flows/transfer_money/request/entities/request_from_contact_response.dart';
import '../../flows/transfer_money/send/send_by_contact/entities/contact_entity.dart';
import '../../flows/transfer_money/send/send_by_contact/entities/contact_request_entity.dart';
import '../../flows/transfer_money/send/send_by_request/entities/request_transaction_response.dart';
import '../api_constants.dart';
import '../network_client.dart';

class AccountsApiProvider {
  AccountsApiProvider(this._networkClient);

  final NetworkClient _networkClient;

  final ApiConstants _apiConstants = ApiConstants();

  Future<ContactEntity> findContacts(ContactRequestEntity requestModel) async {
    try {
      final Response response =
          await _networkClient.dio.post(_apiConstants.transferMoney.contactsPath, data: requestModel);

      if (response.statusCode == 200) {
        final ContactEntity parsedResponse = ContactEntity.fromJson(response.data as Map<String, dynamic>);
        return parsedResponse;
      } else {
        return Future.value(null);
      }
    } catch (error) {
      logger.e(error.toString());
      return Future.value(null);
    }
  }

  Future<List<WalletEntity>> getWalletsByUid(String uid) async {
    try {
      final Response response = await _networkClient.dio.get(
        _apiConstants.transferMoney.accountsPath(uid),
      );

      if (response.statusCode == 200) {
        final WalletAccountList parsedResponse = WalletAccountList.fromJson(response.data);
        return parsedResponse.accounts;
      } else {
        return Future.value(null);
      }
    } catch (error) {
      logger.e(error.toString());
      return Future.value(null);
    }
  }

  // TODO(dmitrykuzhelko): Need to refactor and remove, then change to "getWallets()" function.
  Future<List<Wallet>> getWalletsOLD({
    bool forIwt = false,
  }) async {
    try {
      final Response response = await _networkClient.dio.get(
        _apiConstants.transferMoney.walletsPath,
        queryParameters: {
          "include": "type",
          if (forIwt) "filter[isIwtInstructionsAvailable]": true,
          if (forIwt) "filter[isActive]": true,
        },
      );

      if (response.statusCode == 200) {
        final WalletListWrapper parsedResponse = WalletListWrapper.fromJson(response.data);
        return parsedResponse.walletList;
      } else {
        return Future.value(null);
      }
    } catch (error) {
      logger.e(error.toString());
      return Future.value(null);
    }
  }

  Future<ApiResponseEntity<WalletListWrapper>> getWallets() async {
    try {
      final Response response = await _networkClient.dio.get(_apiConstants.transferMoney.walletsPath);
      return ApiResponseEntity<WalletListWrapper>(
        WalletListWrapper.fromJson(response.data),
        null,
      );
    } on DioError catch (error) {
      logger.e(error.toString());
      return ApiResponseEntity<WalletListWrapper>.fromJson(
        error.response.data as Map<String, dynamic>,
        null,
      );
    }
  }

  Future<ApiResponseEntity<CommonPreviewResponse>> tbuPreview(
    TbuPreviewRequest requestData,
  ) async {
    try {
      final Response response =
          await _networkClient.dio.post(_apiConstants.transferMoney.tbuPreview, data: requestData);
      return ApiResponseEntity<CommonPreviewResponse>.fromJson(
          response.data as Map<String, dynamic>, CommonPreviewResponse.fromJson);
    } on DioError catch (error) {
      logger.e(error.toString());
      return ApiResponseEntity<CommonPreviewResponse>.fromJson(error.response.data as Map<String, dynamic>, null);
    }
  }

  Future<ApiResponseEntity<TbuResponse>> tbu(TbuRequest requestData) async {
    try {
      final Response response = await _networkClient.dio.post(_apiConstants.transferMoney.tbu, data: requestData);
      return ApiResponseEntity<TbuResponse>.fromJson(response.data as Map<String, dynamic>, TbuResponse.fromJson);
    } on DioError catch (error) {
      logger.e(error.toString());
      return ApiResponseEntity<TbuResponse>.fromJson(error.response.data as Map<String, dynamic>, null);
    }
  }

  Future<ApiResponseEntity<CommonPreviewResponse>> tbuRequestPreview(TbuRequestPreviewRequest requestData) async {
    try {
      final Response response =
          await _networkClient.dio.post(_apiConstants.transferMoney.tbuRequestPreview, data: requestData);
      return ApiResponseEntity<CommonPreviewResponse>.fromJson(
          response.data as Map<String, dynamic>, CommonPreviewResponse.fromJson);
    } on DioError catch (error) {
      logger.e(error.toString());
      return ApiResponseEntity<CommonPreviewResponse>.fromJson(error.response.data as Map<String, dynamic>, null);
    }
  }

  Future<ApiResponseEntity<RequestMoneyResponse>> tbuRequest(TbuRequestRequest requestData) async {
    try {
      final Response response =
          await _networkClient.dio.post(_apiConstants.transferMoney.tbuRequest, data: requestData);

      return ApiResponseEntity<RequestMoneyResponse>.fromJson(
          response.data as Map<String, dynamic>, RequestMoneyResponse.fromJson);
    } on DioError catch (error) {
      logger.e(error.toString());
      return ApiResponseEntity<RequestMoneyResponse>.fromJson(error.response.data as Map<String, dynamic>, null);
    }
  }

  Future<ApiResponseEntity<RequestFromContactResponse>> requestFromContact(RequestFromContact requestData) async {
    try {
      final Response response =
          await _networkClient.dio.post(_apiConstants.transferMoney.moneyRequestPath, data: requestData);
      return ApiResponseEntity<RequestFromContactResponse>.fromJson(
          response.data as Map<String, dynamic>, RequestFromContactResponse.fromJson);
    } on DioError catch (error) {
      logger.e(error.toString());
      return ApiResponseEntity<RequestFromContactResponse>.fromJson(error.response.data as Map<String, dynamic>, null);
    }
  }

  Future<ApiResponsePaginationEntity<RequestEntity>> getRequests({
    @required DateTime from,
    @required DateTime to,
    @required int page,
    RequestCategory category,
    String query,
    RequestOperation operation,
  }) async {
    try {
      final Map<String, dynamic> queryParameters = {};
      queryParameters.putIfAbsent("sort", () => "-createdAt");
      queryParameters.putIfAbsent("filter[createdAtFrom]", () => DateFormat("y-M-dd", 'en').format(from));
      queryParameters.putIfAbsent("filter[createdAtTo]", () => DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'", 'en').format(to));
      if (query != null && query.isNotEmpty) {
        queryParameters.putIfAbsent("filter[q]", () => query);
      }
      if (page != null) {
        queryParameters.putIfAbsent("page[number]", () => page);
      }
      if (operation != null) {
        queryParameters.putIfAbsent(
          "filter[operation]",
          () => RequestEnums.requestOperationToString(operation),
        );
      }
      final response = await _networkClient.dio.get(
        _apiConstants.transferMoney.transactionHistory,
        queryParameters: queryParameters,
      );

      return ApiResponsePaginationEntity<RequestEntity>.fromJson(
        response.data as Map<String, dynamic>,
        RequestEntity.fromJson,
      );
    } on DioError catch (error) {
      logger.e(error.toString());
      return ApiResponsePaginationEntity<RequestEntity>.fromJson(error.response.data as Map<String, dynamic>, null);
    }
  }

  Future<ApiResponseEntity<List<CurrencyEntity>>> getCurrencies() async {
    try {
      final Response response = await _networkClient.dio.get(
        _apiConstants.currency.currencies,
        queryParameters: {
          'filter[active]': true,
        }
      );

      final List<dynamic> currenciesData = response.data['data'];
      final List<CurrencyEntity> currencies = currenciesData.map((e) => CurrencyEntity.fromJson(e)).toList();

      return ApiResponseEntity<List<CurrencyEntity>>(currencies, null);
    } on DioError catch (error) {
      logger.e(error.toString());
      return ApiResponseEntity<List<CurrencyEntity>>.fromJson(error.response.data as Map<String, dynamic>, null);
    }
  }

  Future<ApiResponseEntity<List<CountryEntity>>> getCountries() async {
    try {
      final Response response = await _networkClient.dio.get(
        _apiConstants.country.countries,
      );

      final List<dynamic> countriesData = response.data['data'];
      final List<CountryEntity> countries = countriesData.map((e) => CountryEntity.fromJson(e)).toList();

      return ApiResponseEntity<List<CountryEntity>>(countries, null);
    } on DioError catch (error) {
      logger.e(error.toString());
      return ApiResponseEntity<List<CountryEntity>>.fromJson(error.response.data as Map<String, dynamic>, null);
    }
  }

  Future<ApiResponseEntity<OwtPreviewResponse>> owtPreview({
    String bankName,
    int accountIdFrom,
    String outgoingAmount,
    String referenceCurrencyCode,
  }) async {
    try {
      final Response response = await _networkClient.dio.post(_apiConstants.transferMoney.owtPreview, data: {
        'bankName': bankName,
        'accountIdFrom': accountIdFrom,
        'outgoingAmount': outgoingAmount,
        'referenceCurrencyCode': referenceCurrencyCode,
      });

      return ApiResponseEntity<OwtPreviewResponse>(OwtPreviewResponse.fromJson(response.data['data']), null);
    } on DioError catch (error) {
      logger.e(error.toString());
      return ApiResponseEntity<OwtPreviewResponse>.fromJson(error.response.data as Map<String, dynamic>, null);
    }
  }

  Future<ApiResponseEntity<int>> performOwtRequest({
    OwtRequest request,
  }) async {
    try {
      final response = await _networkClient.dio.post(_apiConstants.transferMoney.owtRequest, data: {
        'accountIdFrom': request.accountIdFrom,
        'bankAbaRtn': request.bankAbaRtn,
        'bankAddress': request.bankAddress,
        'bankCountryId': request.bankCountry.id,
        'bankLocation': request.bankLocation,
        'bankName': request.bankName,
        'bankSwiftBic': request.bankSwiftBic,
        'confirmTotalOutgoingAmount': request.confirmTotalOutgoingAmount,
        'customerAccIban': request.customerAccIban,
        'customerAddress': request.customerAddress,
        'customerName': request.customerName,
        'description': request.description,
        'feeId': request.feeId,
        'intermediaryBankAbaRtn': request.intermediaryBankAbaRtn ?? '',
        'intermediaryBankAddress': request.intermediaryBankAddress ?? '',
        'intermediaryBankCountryId': request.intermediaryBankCountry?.id,
        'intermediaryBankLocation': request.intermediaryBankLocation ?? '',
        'intermediaryBankName': request.intermediaryBankName ?? '',
        'intermediaryBankSwiftBic': request.intermediaryBankSwiftBic ?? '',
        'isIntermediaryBankRequired': request.isIntermediaryBankRequired ?? '',
        'intermediaryBankAccIban': request.intermediaryBankAccIban ?? '',
        'outgoingAmount': request.outgoingAmount,
        'refMessage': request.refMessage,
        'referenceCurrencyCode': request.referenceCurrency.code,
        'saveAsTemplate': false,
        'templateName': '',
      });

      final int requestId = response.data['data']['id'];

      return ApiResponseEntity<int>(requestId, null);
    } on DioError catch (error) {
      logger.e(error.toString());

      final List<ErrorMessageEntity> errors = (error.response.data['errors'] as List).map((e) {
        return ErrorMessageEntity(e['code'], e['target'], e['title'], source: ErrorSourceEntity(e['source']));
      }).toList();

      final entity = ApiResponseEntity<int>(null, errors);

      return entity;
    }
  }

  Future<ApiResponseEntity<List<IwtInstruction>>> getIwtInstructions({
    int accountId,
  }) async {
    try {
      final Response response = await _networkClient.dio.get(_apiConstants.transferMoney.iwtInstructions(accountId));

      final List<dynamic> list = response.data['data'];
      final instructions = list.map((e) => IwtInstruction.fromJson(e)).toList();

      return ApiResponseEntity<List<IwtInstruction>>(instructions, null);
    } on DioError catch (error) {
      logger.e(error.toString());
      return ApiResponseEntity<void>.fromJson(error.response.data as Map<String, dynamic>, null);
    }
  }

  Future<ApiResponseEntity<Uint8List>> getIwtPdfFile({
    int accountId,
    int iwtId,
  }) async {
    try {
      final Response response = await _networkClient.dio.get(
        _apiConstants.transferMoney.iwtPdf(accountId: accountId, iwtId: iwtId),
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );

      return ApiResponseEntity<Uint8List>(response.data, null);
    } on DioError catch (error) {
      logger.e(error.toString());
      return ApiResponseEntity<Uint8List>.fromJson(error.response.data as Map<String, dynamic>, null);
    }
  }

  Future<ApiResponseEntity<List<InvestmentAccountConditionsEntity>>> getInvestmentAccountsConditions() async {
    try {
      final Response response =
          await _networkClient.dio.get(_apiConstants.transferMoney.getInvestmentAccountConditions);

      final conditionsJson = response.data['data'] as List<dynamic>;
      final conditions = conditionsJson.map((e) => InvestmentAccountConditionsEntity.fromJson(e)).toList();

      return ApiResponseEntity<List<InvestmentAccountConditionsEntity>>(conditions, null);
    } on DioError catch (error) {
      logger.e(error.toString());
      return ApiResponseEntity<List<InvestmentAccountConditionsEntity>>.fromJson(
        error.response.data as Map<String, dynamic>,
        null,
      );
    }
  }

  Future<ApiResponseEntity<void>> requestInvestmentAccount({
    int optionId,
    String currency,
  }) async {
    try {
      await _networkClient.dio.post(_apiConstants.transferMoney.requestInvestmentAccount, data: {
        'optionId': optionId,
        'currency': currency,
      });

      return ApiResponseEntity(null, null);
    } on DioError catch (error) {
      logger.e(error.toString());
      return ApiResponseEntity.fromJson(
        error.response.data as Map<String, dynamic>,
        null,
      );
    }
  }
}

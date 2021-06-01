import 'package:api_error_parser/api_error_parser.dart';

import '../../enities/common/common_preview_response.dart';
import '../../send/send_by_request/entities/request_transaction_response.dart';

abstract class TbuRequestState {}

class TbuRequestInitState extends TbuRequestState {}

/// Preview request
class TbuRequestPreviewState extends TbuRequestState {}

class TbuRequestPreviewLoadingState extends TbuRequestPreviewState {}

class TbuRequestPreviewSuccessState extends TbuRequestPreviewState {
  final CommonPreviewResponse data;

  TbuRequestPreviewSuccessState(this.data);
}

class TbuRequestPreviewErrorState extends TbuRequestPreviewState {
  final List<ParserMessageEntity> errors;

  TbuRequestPreviewErrorState(this.errors);
}

/// Request
class TbuRequestTransferState extends TbuRequestState {}

class TbuRequestLoadingState extends TbuRequestTransferState {}

class TbuRequestSuccessState extends TbuRequestTransferState {
  final RequestMoneyResponse data;

  TbuRequestSuccessState(this.data);
}

class TbuRequestErrorState extends TbuRequestTransferState {
  final List<ParserMessageEntity> errors;

  TbuRequestErrorState(this.errors);
}
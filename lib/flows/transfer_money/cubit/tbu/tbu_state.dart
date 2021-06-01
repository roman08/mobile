import 'package:Velmie/flows/transfer_money/enities/common/common_preview_response.dart';
import 'package:api_error_parser/api_error_parser.dart';

abstract class TbuState {}

class TbuInitState extends TbuState {}

/// TBU preview
class TbuPreviewState extends TbuState {}

class TbuPreviewLoadingState extends TbuPreviewState {}

class TbuPreviewSuccessState extends TbuPreviewState {
  final CommonPreviewResponse data;

  TbuPreviewSuccessState(this.data);
}

class TbuPreviewErrorState extends TbuState {
  final List<ParserMessageEntity> errors;

  TbuPreviewErrorState(this.errors);
}

/// TBU
class TbuTransferState extends TbuState {}

class TbuLoadingState extends TbuTransferState {}

class TbuSuccessState extends TbuTransferState {}

class TbuErrorState extends TbuState {
  final List<ParserMessageEntity> errors;

  TbuErrorState(this.errors);
}

/// Request from contact
class RequestFromContactState extends TbuState {}

class RequestFromContactLoadingState extends RequestFromContactState {}

class RequestFromContactSuccessState extends RequestFromContactState {}

class RequestFromContactErrorState extends RequestFromContactState {
  final List<ParserMessageEntity> errors;

  RequestFromContactErrorState(this.errors);
}

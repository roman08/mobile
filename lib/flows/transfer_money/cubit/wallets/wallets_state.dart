import 'package:api_error_parser/api_error_parser.dart';

import '../../../dashboard_flow/entities/wallet_list_wrapper.dart';

abstract class WalletsState {}

class WalletsInitialState extends WalletsState {}

class WalletsLoadingState extends WalletsState {}

class WalletsSuccessLoadedState extends WalletsState {
  final List<Wallet> wallets;

  WalletsSuccessLoadedState(this.wallets);
}

class WalletsErrorState extends WalletsState {
  final List<ParserMessageEntity> errors;

  WalletsErrorState(this.errors);
}

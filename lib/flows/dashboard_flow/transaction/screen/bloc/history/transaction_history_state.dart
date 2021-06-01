import 'package:equatable/equatable.dart';

abstract class TransactionHistoryState extends Equatable {
  @override
  List<Object> get props => [];
}

class TransactionHistoryInitState extends TransactionHistoryState {}

class TransactionHistoryLoadingState extends TransactionHistoryState {}

class TransactionHistoryRefreshingState extends TransactionHistoryState {}

class TransactionHistoryList extends TransactionHistoryState {
  TransactionHistoryList(this.requests);

  final List<dynamic> requests;

  @override
  List<Object> get props => [requests];
}

class TransactionHistoryErrorState extends TransactionHistoryState {
  TransactionHistoryErrorState(this.errorMessage);

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}

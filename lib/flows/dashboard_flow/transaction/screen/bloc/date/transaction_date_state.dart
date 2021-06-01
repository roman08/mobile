import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class TransactionDateState extends Equatable {
  const TransactionDateState({
    @required this.isFrom,
    @required this.dateFrom,
    @required this.dateTo,
  });

  final bool isFrom;
  final DateTime dateFrom;
  final DateTime dateTo;

  @override
  List<Object> get props => [isFrom, dateTo, dateFrom];

  TransactionDateState showPicker({bool isFrom}) {
    return TransactionDateState(
      isFrom: isFrom,
      dateFrom: this.dateFrom,
      dateTo: this.dateTo,
    );
  }

  TransactionDateState donePicker({DateTime dateFrom, DateTime dateTo}) {
    return TransactionDateState(
      isFrom: null,
      dateFrom: dateFrom,
      dateTo: dateTo,
    );
  }

  TransactionDateState closePicker() {
    return TransactionDateState(
      isFrom: null,
      dateFrom: this.dateFrom,
      dateTo: this.dateTo,
    );
  }
}

class SuccessTransactionDateState extends TransactionDateState {
  @override
  final DateTime dateFrom;
  @override
  final DateTime dateTo;

  const SuccessTransactionDateState({
    @required this.dateFrom,
    @required this.dateTo,
  });
}

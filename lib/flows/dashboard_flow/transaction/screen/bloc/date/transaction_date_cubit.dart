import 'package:flutter_bloc/flutter_bloc.dart';

import 'transaction_date_state.dart';

class TransactionDateCubit extends Cubit<TransactionDateState> {
  TransactionDateCubit(this._from, this._to)
      : super(TransactionDateState(isFrom: null, dateFrom: _from, dateTo: _to));

  DateTime _from;
  DateTime _to;
  DateTime _dateTimeFrom;
  DateTime _dateTimeTo;

  void showDatePicker(bool isFrom, DateTime date) async {
    emit(state.closePicker());
    await Future.delayed(const Duration(milliseconds: 100));
    emit(state.showPicker(isFrom: isFrom));
  }

  void closeDatePicker() {
    _dateTimeFrom = _from;
    _dateTimeTo = _to;
    emit(state.closePicker());
  }

  void doneDatePicker(bool isFrom) {
    if (isFrom) {
      _from = _dateTimeFrom;
      if (_from.isAfter(_to)) {
        _to = DateTime(_from.year, _from.month + 1, _from.day);
      }
    } else {
      _to = _dateTimeTo;
    }
    emit(state.donePicker(dateFrom: _from, dateTo: _to));
  }

  void done() {
    emit(SuccessTransactionDateState(dateFrom: _from, dateTo: _to));
  }

  void changeDate(bool isFrom, DateTime date) {
    if (isFrom) {
      _dateTimeFrom = date;
    } else {
      _dateTimeTo = date;
    }
  }
}

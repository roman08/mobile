import 'package:equatable/equatable.dart';

class DateSelectedEntity extends Equatable {
  final DateTime dateFrom;
  final DateTime dateTo;

  const DateSelectedEntity({this.dateFrom, this.dateTo});

  @override
  String toString() {
    return "dateFrom = $dateFrom dateTo = $dateTo";
  }

  @override
  List<Object> get props => [dateFrom, dateTo];
}

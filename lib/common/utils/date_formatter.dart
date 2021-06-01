import 'package:easy_localization/easy_localization.dart';

DateTime getTodayDate() {
  return DateTime.now();
}

DateTime getYesterdayDate({String patten}) {
  final today = getTodayDate();
  return DateTime(today.year, today.month, today.day - 1);
}

String dateFormat({String datePattern, DateTime date}) {
    if (date == null) {
        return "";
    } else {
        return DateFormat(datePattern, 'en').format(date);
    }
}

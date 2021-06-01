import 'package:intl/intl.dart';

const String _SERVER_DATE_PATTERN = "yyyy-MM-dd'T'HH:mm:ss'Z'";
const String _APP_DATE_PATTERN = 'MMMM, d';
final DateTime _currentDate = DateTime.now();
final String _yesterdayString = DateFormat(_APP_DATE_PATTERN, 'en').format(DateTime(_currentDate.year, _currentDate.month, _currentDate.day - 1));
final String _todayString = DateFormat(_APP_DATE_PATTERN, 'en').format(_currentDate);

class SentNotification {
    String createdAt;

    // Used to sort list by user readable date
    String createdDate;
    int id;
    Payload payload;
    String type;

    SentNotification({this.createdAt, this.id, this.payload, this.type}) {
        final DateFormat dateFormat = DateFormat(_SERVER_DATE_PATTERN, 'en');
        final DateTime dateTime = dateFormat.parse(this.createdAt);

        final formattedDate = DateFormat(_APP_DATE_PATTERN, 'en').format(dateTime);
        if (formattedDate == _todayString) {
            this.createdDate = 'Today';
        } else if (formattedDate == _yesterdayString) {
            this.createdDate = 'Yesterday';
        } else {
            this.createdDate = formattedDate;
        }
    }

    static SentNotification fromJson(Map<String, dynamic> json) {
        return SentNotification(
            createdAt: json['createdAt'],
            id: json['id'],
            payload: json['payload'] != null ? Payload.fromJson(json['payload']) : null,
            type: json['type'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data['createdAt'] = this.createdAt;
        data['id'] = this.id;
        data['type'] = this.type;
        if (this.payload != null) {
            data['payload'] = this.payload.toJson();
        }
        return data;
    }

    @override
    String toString() {
        return 'SentNotification{createdAt: $createdAt, id: $id, payload: $payload, type: $type}';
    }
}

class Payload {
    String amount;
    String currency;
    String senderFirstName;
    String senderLastName;
    int walletId;
    String walletNumber;

    Payload({this.amount, this.currency, this.senderFirstName, this.senderLastName, this.walletId, this.walletNumber});

    factory Payload.fromJson(Map<String, dynamic> json) {
        return Payload(
            amount: json['amount'],
            currency: json['currency'],
            senderFirstName: json['senderFirstName'],
            senderLastName: json['senderLastName'],
            walletId: json['walletId'],
            walletNumber: json['walletNumber'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data['amount'] = this.amount;
        data['currency'] = this.currency;
        data['senderFirstName'] = this.senderFirstName;
        data['senderLastName'] = this.senderLastName;
        data['walletId'] = this.walletId;
        data['walletNumber'] = this.walletNumber;
        return data;
    }

    @override
    String toString() {
        return 'Payload{amount: $amount, currency: $currency, senderFirstName: $senderFirstName, senderLastName: $senderLastName, walletId: $walletId, walletNumber: $walletNumber}';
    }

    String getUsername() => '$senderFirstName $senderLastName';

    String getLastFourNumberString() => '${walletNumber.substring(walletNumber.length - 4, walletNumber.length)}';
}

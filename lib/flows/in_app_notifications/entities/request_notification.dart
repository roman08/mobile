import 'dart:typed_data';

class RequestNotificationEntity {
  String createdAt;
  int id;
  String amount;
  String username;
  String currency;
  String targetUID;
  String phoneNumber;
  String description;
  Uint8List avatar;

  RequestNotificationEntity.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    id = json['id'];
    amount = json['amount'];
    username = json['recipient']['firstName'] + ' ' + json['recipient']['lastName'];
    currency = json['currencyCode'];
    description = json['description'];
    targetUID = json['targetUID'];
    phoneNumber = json['recipient']['phoneNumber'];
  }
}

class RequestNotificationDetails {
    int id;
    String targetUID;
    Recipient recipient;
    int recipientAccountId;
    String amount;
    String description;
    String createdAt;
    String updatedAt;

    RequestNotificationDetails({this.id, this.targetUID, this.recipient, this.recipientAccountId, this.amount, this.description, this.createdAt, this.updatedAt});

    static RequestNotificationDetails fromJson(Map<String, dynamic> json) {
        return RequestNotificationDetails(
            id: json['id'],
            targetUID: json['targetUID'],
            recipient: json['recipient'] != null ? Recipient.fromJson(json['recipient']) : null,
            recipientAccountId: json['recipientAccountId'],
            amount: json['amount'],
            description: json['description'],
            createdAt: json['createdAt'],
            updatedAt: json['updatedAt'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data['id'] = this.id;
        data['targetUID'] = this.targetUID;
        if (this.recipient != null) {
            data['recipient'] = this.recipient.toJson();
        }
        data['recipientAccountId'] = this.recipientAccountId;
        data['amount'] = this.amount;
        data['description'] = this.description;
        data['createdAt'] = this.createdAt;
        data['updatedAt'] = this.updatedAt;
        return data;
    }

    @override
    String toString() {
        return 'RequestNotificationDetails{id: $id, targetUID: $targetUID, recipient: $recipient, recipientAccountId: $recipientAccountId, amount: $amount, description: $description, createdAt: $createdAt, updatedAt: $updatedAt}';
    }
}

class Recipient {
    String firstName;
    String lastName;
    String phoneNumber;

    Recipient({this.firstName, this.lastName, this.phoneNumber});

    factory Recipient.fromJson(Map<String, dynamic> json) {
        return Recipient(
            firstName: json['firstName'],
            lastName: json['lastName'],
            phoneNumber: json['phoneNumber'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data['firstName'] = this.firstName;
        data['lastName'] = this.lastName;
        data['phoneNumber'] = this.phoneNumber;
        return data;
    }

    @override
    String toString() {
        return 'Recipient{firstName: $firstName, lastName: $lastName, phoneNumber: $phoneNumber}';
    }

    String getUsername() => '$firstName $lastName';
}

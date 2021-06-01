class RequestFromContact {
  String amount;
  String description;
  int recipientAccountId;
  String targetUID;

  RequestFromContact(
      {this.amount, this.description, this.recipientAccountId, this.targetUID});

  factory RequestFromContact.fromJson(Map<String, dynamic> json) {
    return RequestFromContact(
      amount: json['amount'],
      description: json['description'],
      recipientAccountId: json['recipientAccountId'],
      targetUID: json['targetUID'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = this.amount.replaceFirst(RegExp(','), '.');
    data['description'] = this.description;
    data['recipientAccountId'] = this.recipientAccountId;
    data['targetUID'] = this.targetUID;
    return data;
  }

  @override
  String toString() {
    return 'RequestFromContact{amount: $amount, description: $description, recipientAccountId: $recipientAccountId, targetUID: $targetUID}';
  }
}

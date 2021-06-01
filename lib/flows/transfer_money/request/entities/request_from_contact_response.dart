class RequestFromContactResponse {
  Data data;

  RequestFromContactResponse({this.data});

  static RequestFromContactResponse fromJson(Map<String, dynamic> json) {
    return RequestFromContactResponse(
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String amount;
  String createdAt;
  String description;
  int id;
  int recipientAccountId;
  String targetUID;
  String updatedAt;

  Data(
      {this.amount,
      this.createdAt,
      this.description,
      this.id,
      this.recipientAccountId,
      this.targetUID,
      this.updatedAt});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      amount: json['amount'],
      createdAt: json['createdAt'],
      description: json['description'],
      id: json['id'],
      recipientAccountId: json['recipientAccountId'],
      targetUID: json['targetUID'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['createdAt'] = this.createdAt;
    data['description'] = this.description;
    data['id'] = this.id;
    data['recipientAccountId'] = this.recipientAccountId;
    data['targetUID'] = this.targetUID;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

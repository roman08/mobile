class OwtPreviewResponse {
  List<Detail> details;
  String totalOutgoingAmount;

  OwtPreviewResponse(
      {this.details, this.totalOutgoingAmount});

  factory OwtPreviewResponse.fromJson(Map<String, dynamic> json) {
    return OwtPreviewResponse(
      details: json['details'] != null
          ? (json['details'] as List).map((i) => Detail.fromJson(i)).toList()
          : null,
      totalOutgoingAmount: json['totalOutgoingAmount'],
    );
  }

  @override
  String toString() {
    return 'OwtPreviewResponse{details: $details, totalOutgoingAmount: $totalOutgoingAmount}';
  }
}

class Detail {
  String amount;
  String currencyCode;
  String purpose;

  Detail({this.amount, this.currencyCode, this.purpose});

  factory Detail.fromJson(Map<String, dynamic> json) {
    return Detail(
      amount: json['amount'],
      currencyCode: json['currencyCode'],
      purpose: json['purpose'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = this.amount;
    data['currencyCode'] = this.currencyCode;
    data['purpose'] = this.purpose;
    return data;
  }

  @override
  String toString() {
    return 'Detail{amount: $amount, currencyCode: $currencyCode, purpose: $purpose}';
  }
}

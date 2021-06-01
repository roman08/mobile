class CommonPreviewResponse {
  List<Detail> details;
  String incomingAmount;
  String incomingCurrencyCode;
  bool tfaRequired;

  CommonPreviewResponse({
    this.details,
    this.incomingAmount,
    this.incomingCurrencyCode,
    this.tfaRequired,
  });

  static CommonPreviewResponse fromJson(Map<String, dynamic> json) {
    return CommonPreviewResponse(
      details: json['details'] != null
          ? (json['details'] as List).map((i) => Detail.fromJson(i)).toList()
          : null,
      incomingAmount: json['incomingAmount'],
      incomingCurrencyCode: json['incomingCurrencyCode'],
      tfaRequired: json['tfaRequired'],
    );
  }

  @override
  String toString() {
    return 'CommonPreviewResponse{details: $details, incomingAmount: $incomingAmount, incomingCurrencyCode: $incomingCurrencyCode, tfaRequired: $tfaRequired}';
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

  @override
  String toString() {
    return 'Detail{amount: $amount, currencyCode: $currencyCode, purpose: $purpose}';
  }
}

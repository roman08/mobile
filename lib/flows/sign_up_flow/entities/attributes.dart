class Attributes {
  final String businessName;
  final String merchantType;

  Attributes({this.businessName, this.merchantType});

  factory Attributes.fromJson(Map<String, dynamic> json) {
    return Attributes(
      businessName: json['businessName'],
      merchantType: json['merchantType'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['businessName'] = this.businessName;
    data['merchantType'] = this.merchantType;
    return data;
  }

  @override
  String toString() {
    return 'Attributes{businessName: $businessName, merchantType: $merchantType}';
  }
}

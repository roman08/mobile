class AccountEntity {
  AccountEntity({
    this.currencyCode,
    this.number,
    this.typeName,
  });

  String currencyCode;
  String number;
  String typeName;

  factory AccountEntity.fromJson(Map<String, dynamic> json) => AccountEntity(
        currencyCode: json["currencyCode"],
        number: json["number"],
        typeName: json["typeName"],
      );

  @override
  String toString() {
    return "AccountEntity { currencyCode = $currencyCode, number = $number, typeName = $typeName }";
  }
}

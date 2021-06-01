class WalletEntity {
  int id;
  String number;
  Type type;

  WalletEntity({this.id, this.number, this.type});

  factory WalletEntity.fromJson(Map<String, dynamic> json) {
    return WalletEntity(
      id: json["id"],
      number: json["number"],
      type: json["type"] != null ? Type.fromJson(json["type"]) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = this.id;
    data["number"] = this.number;
    if (this.type != null) {
      data["type"] = this.type.toJson();
    }
    return data;
  }

  String toSelectedItemString() =>
      '${type.currencyCode} ${type.name} *${number.substring(number.length - 4, number.length)}';

  // *1234
  String getLastFourNumberString() =>
      '*${number.substring(number.length - 4, number.length)}';

  @override
  String toString() {
    return 'WalletEntity{id: $id, number: $number, type: $type}';
  }
}

class Type {
  String currencyCode;
  String name;

  Type({this.currencyCode, this.name});

  factory Type.fromJson(Map<String, dynamic> json) {
    return Type(
      currencyCode: json["currencyCode"],
      name: json["name"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["currencyCode"] = this.currencyCode;
    data["name"] = this.name;
    return data;
  }

  @override
  String toString() {
    return 'Type{currencyCode: $currencyCode, name: $name}';
  }
}

class WalletAccountList {
  final List<WalletEntity> accounts;

  WalletAccountList({this.accounts});

  factory WalletAccountList.fromJson(List<dynamic> parsedJson) {
    List<WalletEntity> accounts = <WalletEntity>[];
    accounts = parsedJson.map((i) => WalletEntity.fromJson(i)).toList();

    return WalletAccountList(accounts: accounts);
  }

  @override
  String toString() {
    return 'WalletAccountList{accounts: $accounts}';
  }
}

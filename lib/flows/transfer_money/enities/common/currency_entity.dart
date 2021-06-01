class CurrencyEntity {
  String code;
  int decimalPlaces;
  String feed;
  int id;
  String name;
  String type;

  CurrencyEntity.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    decimalPlaces = json['decimalPlaces'];
    feed = json['feed'];
    id = json['id'];
    name = json['name'];
    type = json['type'];
  }

  @override
  String toString() {
    return 'CurrencyEntity{code: $code, decimalPlaces: $decimalPlaces, feed: $feed, id: $id, name: $name, type: $type}';
  }
}

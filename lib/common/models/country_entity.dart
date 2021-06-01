class CountryEntity {
  String code;
  String dialCode;
  String name;

  CountryEntity({this.code, this.dialCode, this.name});

  static List<CountryEntity> listFromJson(List<dynamic> list) =>
      list.map((json) => CountryEntity.fromJson(json)).toList();

  factory CountryEntity.fromJson(Map<String, dynamic> json) {
    return CountryEntity(
      code: json['code'],
      dialCode: json['dial_code'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = this.code;
    data['dialCode'] = this.dialCode;
    data['name'] = this.name;
    return data;
  }

  @override
  String toString() =>
      'CountryEntity{code: $code, dialCode: $dialCode, name: $name}';
}

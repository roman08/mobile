class CountryEntity {
  String code;
  String code3;
  String codeNumeric;
  String name;
  int id;

  CountryEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    code3 = json['code3'];
    codeNumeric = json['codeNumeric'];
    name = json['name'];
  }

  @override
  String toString() {
    return 'CountryEntity{code: $code, code3: $code3, codeNumeric: $codeNumeric, name: $name, id: $id}';
  }
}

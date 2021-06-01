import 'dart:convert';

class CurrentTier {
  CurrentTier({
    this.id,
    this.level,
    this.limitations,
    this.name,
  });

  int id;
  int level;
  List<Limitation> limitations;
  String name;

  factory CurrentTier.fromRawJson(String str) =>
      CurrentTier.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  static CurrentTier fromJson(Map<String, dynamic> json) => CurrentTier(
        id: json["id"] == null ? null : json["id"],
        level: json["level"] == null ? null : json["level"],
        limitations: json["limitations"] == null
            ? null
            : List<Limitation>.from(
                json["limitations"].map((x) => Limitation.fromJson(x))),
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "level": level == null ? null : level,
        "limitations": limitations == null
            ? null
            : List<dynamic>.from(limitations.map((x) => x.toJson())),
        "name": name == null ? null : name,
      };
}

class Limitation {
  Limitation({
    this.name,
    this.value,
  });

  String name;
  String value;

  factory Limitation.fromRawJson(String str) =>
      Limitation.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Limitation.fromJson(Map<String, dynamic> json) => Limitation(
        name: json["name"] == null ? null : json["name"],
        value: json["value"] == null ? null : json["value"],
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "value": value == null ? null : value,
      };
}

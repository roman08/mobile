import 'dart:convert';

import 'tiers_result.dart';

class RequirementRequest {
  RequirementRequest({
    this.values,
    this.id,
  });

  List<ElementValue> values;
  int id;

  factory RequirementRequest.fromRawJson(String str) => RequirementRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RequirementRequest.fromJson(Map<String, dynamic> json) => RequirementRequest(
        values: json["values"] == null
            ? null
            : List<ElementValue>.from(json["values"].map((x) => ElementValue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "values": values == null ? null : List<dynamic>.from(values.map((x) => x.toJson())),
      };
}

class ElementValue {
  ElementValue({
    this.index,
    this.value,
  });

  ElementIndex index;
  String value;

  factory ElementValue.fromRawJson(String str) => ElementValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ElementValue.fromJson(Map<String, dynamic> json) => ElementValue(
        index: json["index"] == null ? null : elementIndexs[json["index"]],
        value: json["value"] == null ? null : json["value"],
      );

  Map<String, dynamic> toJson() => {
        "index": index == null
            ? null
            : elementIndexs.keys.firstWhere(
                (k) => elementIndexs[k] == index,
                orElse: () => null,
              ),
        "value": value == null ? null : value,
      };
}

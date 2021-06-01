import 'dart:convert';

class FileInfo {
  FileInfo({
    this.id,
    this.path,
  });

  int id;
  String path;

  factory FileInfo.fromRawJson(String str) =>
      FileInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  static FileInfo fromJson(Map<String, dynamic> json) => FileInfo(
        id: json["id"] == null ? null : json["id"],
        path: json["path"] == null ? null : json["path"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "path": path == null ? null : path,
      };
}

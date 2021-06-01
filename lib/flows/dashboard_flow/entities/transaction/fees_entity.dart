class FeesEntity {
  FeesEntity({
    this.list,
    this.total,
  });

  List<dynamic> list;
  String total;

  factory FeesEntity.fromJson(Map<String, dynamic> json) => FeesEntity(
        list: List<dynamic>.from(json["list"].map((x) => x)),
        total: json["total"],
      );

  @override
  String toString() {
    return "ProfileEntity { list = $list, total = $total }";
  }
}

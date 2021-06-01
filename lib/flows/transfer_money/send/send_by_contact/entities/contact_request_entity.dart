class ContactRequestEntity {
  List<String> phoneNumbers;

  ContactRequestEntity({this.phoneNumbers});

  factory ContactRequestEntity.fromJson(Map<String, dynamic> json) {
    return ContactRequestEntity(
      phoneNumbers: json['phoneNumbers'] != null
          ? List<String>.from(json['phoneNumbers'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.phoneNumbers != null) {
      data['phoneNumbers'] = this.phoneNumbers;
    }
    return data;
  }

  @override
  String toString() {
    return 'ContactRequestEntity{phoneNumbers: $phoneNumbers}';
  }
}

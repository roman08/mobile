/// Server response entity
class ContactEntity {
  List<_Data> data;
  int status;

  ContactEntity({this.data, this.status});

  factory ContactEntity.fromJson(Map<String, dynamic> json) {
    return ContactEntity(
      data: json['data'] != null
          ? (json['data'] as List).map((i) => _Data.fromJson(i)).toList()
          : null,
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'AppContactEntity{data: $data, status: $status}';
  }
}

class _Data {
  String phoneNumber;
  String uid;

  _Data({this.phoneNumber, this.uid});

  factory _Data.fromJson(Map<String, dynamic> json) {
    return _Data(
      phoneNumber: json['phoneNumber'],
      uid: json['uid'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phoneNumber'] = this.phoneNumber;
    data['uid'] = this.uid;
    return data;
  }

  @override
  String toString() {
    return '_Data{phoneNumber: $phoneNumber, uid: $uid}';
  }
}

class ProfileEntity {
  ProfileEntity({
    this.companyName,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.avatar,
  });

  String companyName;
  String firstName;
  String lastName;
  String phoneNumber;
  String avatar;

  factory ProfileEntity.fromJson(Map<String, dynamic> json) => ProfileEntity(
        companyName: json["companyName"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        phoneNumber: json["phoneNumber"],
        avatar: json["avatar"],
      );

  @override
  String toString() {
    return "ProfileEntity { companyName = $companyName, firstName = $firstName, lastName = $lastName, phoneNumber = $phoneNumber, avatar = $avatar }";
  }
}

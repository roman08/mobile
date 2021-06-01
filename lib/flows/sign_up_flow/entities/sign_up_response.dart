import 'attributes.dart';
import 'physical_address.dart';

class SignUpResponse {
  String uid;
  String email;
  String username;
  String firstName;
  String lastName;
  String middleName;
  String nickname;
  String phoneNumber;
  String smsPhoneNumber;
  bool isCorporate;
  String roleName;
  String parentId;
  String status;
  String creditRating;
  UserGroup userGroup;
  String userGroupId;
  String createdAt;
  String updatedAt;
  String lastLoginAt;
  String lastLoginIp;
  String challengeName;
  bool isPhoneConfirmed;
  bool isEmailConfirmed;
  CompanyDetails companyDetails;
  String companyID;
  List<PhysicalAddress> physicalAddresses;
  List<MailingAddresses> mailingAddresses;
  Attributes attributes;
  int classId;
  String countryOfResidenceIsoTwo;
  String countryOfCitizenshipIsoTwo;
  String dateOfBirth;
  String documentType;
  String documentPersonalId;
  String fax;
  String homePhoneNumber;
  String internalNotes;
  String officePhoneNumber;

  SignUpResponse({
    this.uid,
    this.email,
    this.username,
    this.firstName,
    this.lastName,
    this.middleName,
    this.nickname,
    this.phoneNumber,
    this.smsPhoneNumber,
    this.isCorporate,
    this.roleName,
    this.parentId,
    this.status,
    this.creditRating,
    this.userGroup,
    this.userGroupId,
    this.createdAt,
    this.updatedAt,
    this.lastLoginAt,
    this.lastLoginIp,
    this.challengeName,
    this.isPhoneConfirmed,
    this.isEmailConfirmed,
    this.companyDetails,
    this.companyID,
    this.physicalAddresses,
    this.mailingAddresses,
    this.attributes,
    this.classId,
    this.countryOfResidenceIsoTwo,
    this.countryOfCitizenshipIsoTwo,
    this.dateOfBirth,
    this.documentType,
    this.documentPersonalId,
    this.fax,
    this.homePhoneNumber,
    this.internalNotes,
    this.officePhoneNumber,
  });

  static SignUpResponse fromJson(Map<String, dynamic> json) {
    return SignUpResponse(
      uid: json['uid'],
      email: json['email'],
      username: json['username'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      middleName: json['middleName'],
      nickname: json['nickname'],
      phoneNumber: json['phoneNumber'],
      smsPhoneNumber: json['smsPhoneNumber'],
      isCorporate: json['isCorporate'],
      roleName: json['roleName'],
      parentId: json['parentId'],
      status: json['status'],
      creditRating: json['creditRating'],
      userGroup: json['userGroup'] != null
          ? UserGroup.fromJson(json['userGroup'])
          : null,
      userGroupId: json['userGroupId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      lastLoginAt: json['lastLoginAt'],
      lastLoginIp: json['lastLoginIp'],
      challengeName: json['challengeName'],
      isPhoneConfirmed: json['isPhoneConfirmed'],
      isEmailConfirmed: json['isEmailConfirmed'],
      companyDetails: json['companyDetails'] != null
          ? CompanyDetails.fromJson(json['companyDetails'])
          : null,
      companyID: json['companyID'],
      physicalAddresses: json['physicalAddresses'] != null
          ? json['physicalAddresses']
              .map((i) => PhysicalAddress.fromJson(i))
              .toList()
          : null,
      mailingAddresses: json['mailingAddresses'] != null
          ? json['mailingAddresses']
              .map((i) => MailingAddresses.fromJson(i))
              .toList()
          : null,
      attributes: json['attributes'] != null
          ? Attributes.fromJson(json['attributes'])
          : [],
      classId: json['classId'],
      countryOfResidenceIsoTwo: json['countryOfResidenceIsoTwo'],
      countryOfCitizenshipIsoTwo: json['countryOfCitizenshipIsoTwo'],
      dateOfBirth: json['dateOfBirth'],
      documentType: json['documentType'],
      documentPersonalId: json['documentPersonalId'],
      fax: json['fax'],
      homePhoneNumber: json['homePhoneNumber'],
      internalNotes: json['internalNotes'],
      officePhoneNumber: json['officePhoneNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['uid'] = this.uid;
    data['email'] = this.email;
    data['username'] = this.username;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['middleName'] = this.middleName;
    data['nickname'] = this.nickname;
    data['phoneNumber'] = this.phoneNumber;
    data['smsPhoneNumber'] = this.smsPhoneNumber;
    data['isCorporate'] = this.isCorporate;
    data['roleName'] = this.roleName;
    data['parentId'] = this.parentId;
    data['status'] = this.status;
    data['creditRating'] = this.creditRating;
    data['userGroupId'] = this.userGroupId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['lastLoginAt'] = this.lastLoginAt;
    data['lastLoginIp'] = this.lastLoginIp;
    data['challengeName'] = this.challengeName;
    data['isPhoneConfirmed'] = this.isPhoneConfirmed;
    data['isEmailConfirmed'] = this.isEmailConfirmed;
    data['classId'] = this.classId;
    data['countryOfResidenceIsoTwo'] = this.countryOfResidenceIsoTwo;
    data['countryOfCitizenshipIsoTwo'] = this.countryOfCitizenshipIsoTwo;
    data['dateOfBirth'] = this.dateOfBirth;
    data['documentType'] = this.documentType;
    data['documentPersonalId'] = this.documentPersonalId;
    data['fax'] = this.fax;
    data['homePhoneNumber'] = this.homePhoneNumber;
    data['internalNotes'] = this.internalNotes;
    data['officePhoneNumber'] = this.officePhoneNumber;
    if (this.userGroup != null) {
      data['userGroup'] = this.userGroup.toJson();
    }
    if (this.companyDetails != null) {
      data['companyDetails'] = this.companyDetails.toJson();
    }
    if (this.physicalAddresses != null) {
      data['physicalAddresses'] =
          this.physicalAddresses.map((v) => v.toJson()).toList();
    }
    if (this.mailingAddresses != null) {
      data['mailingAddresses'] =
          this.mailingAddresses.map((v) => v.toJson()).toList();
    }
    if (this.attributes != null) {
      data['attributes'] = this.attributes.toJson();
    }
    print('**********///////// holaaaaaa');
    return data;
  }

  @override
  String toString() {
    return 'SignUpResponse{uid: $uid, email: $email, username: $username, firstName: $firstName, lastName: $lastName, middleName: $middleName, nickname: $nickname, phoneNumber: $phoneNumber, smsPhoneNumber: $smsPhoneNumber, isCorporate: $isCorporate, roleName: $roleName, parentId: $parentId, status: $status, creditRating: $creditRating, userGroup: $userGroup, userGroupId: $userGroupId, createdAt: $createdAt, updatedAt: $updatedAt, lastLoginAt: $lastLoginAt, lastLoginIp: $lastLoginIp, challengeName: $challengeName, isPhoneConfirmed: $isPhoneConfirmed, isEmailConfirmed: $isEmailConfirmed, companyDetails: $companyDetails, companyID: $companyID, physicalAddresses: $physicalAddresses, mailingAddresses: $mailingAddresses, attributes: $attributes, classId: $classId, countryOfResidenceIsoTwo: $countryOfResidenceIsoTwo, countryOfCitizenshipIsoTwo: $countryOfCitizenshipIsoTwo, dateOfBirth: $dateOfBirth, documentType: $documentType, documentPersonalId: $documentPersonalId, fax: $fax, homePhoneNumber: $homePhoneNumber, internalNotes: $internalNotes, officePhoneNumber: $officePhoneNumber}';
  }
}

class UserGroup {
  String createdAt;
  String description;
  int id;
  String name;
  String updatedAt;

  UserGroup(
      {this.createdAt, this.description, this.id, this.name, this.updatedAt});

  factory UserGroup.fromJson(Map<String, dynamic> json) {
    return UserGroup(
      createdAt: json['createdAt'],
      description: json['description'],
      id: json['id'],
      name: json['name'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['description'] = this.description;
    data['id'] = this.id;
    data['name'] = this.name;
    data['updatedAt'] = this.updatedAt;
    return data;
  }

  @override
  String toString() {
    return 'UserGroup{createdAt: $createdAt, description: $description, id: $id, name: $name, updatedAt: $updatedAt}';
  }
}

class CompanyDetails {
  String companyName;
  String companyRole;
  String companyType;
  String directorFirstName;
  String directorLastName;
  int id;
  String maskName;

  CompanyDetails({
    this.companyName,
    this.companyRole,
    this.companyType,
    this.directorFirstName,
    this.directorLastName,
    this.id,
    this.maskName,
  });

  factory CompanyDetails.fromJson(Map<String, dynamic> json) {
    return CompanyDetails(
      companyName: json['companyName'],
      companyRole: json['companyRole'],
      companyType: json['companyType'],
      directorFirstName: json['directorFirstName'],
      directorLastName: json['directorLastName'],
      id: json['id'],
      maskName: json['maskName'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['companyName'] = this.companyName;
    data['companyRole'] = this.companyRole;
    data['companyType'] = this.companyType;
    data['directorFirstName'] = this.directorFirstName;
    data['directorLastName'] = this.directorLastName;
    data['id'] = this.id;
    data['maskName'] = this.maskName;
    return data;
  }

  @override
  String toString() {
    return 'CompanyDetails{companyName: $companyName, companyRole: $companyRole, companyType: $companyType, directorFirstName: $directorFirstName, directorLastName: $directorLastName, id: $id, maskName: $maskName}';
  }
}

class MailingAddresses {
  String address;
  String addressSecondLine;
  String city;
  String countryIsoTwo;
  String description;
  int id;
  int latitude;
  int longitude;
  String region;
  String zipCode;

  MailingAddresses({
    this.address,
    this.addressSecondLine,
    this.city,
    this.countryIsoTwo,
    this.description,
    this.id,
    this.latitude,
    this.longitude,
    this.region,
    this.zipCode,
  });

  factory MailingAddresses.fromJson(Map<String, dynamic> json) {
    return MailingAddresses(
      address: json['address'],
      addressSecondLine: json['addressSecondLine'],
      city: json['city'],
      countryIsoTwo: json['countryIsoTwo'],
      description: json['description'],
      id: json['id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      region: json['region'],
      zipCode: json['zipCode'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['address'] = this.address;
    data['addressSecondLine'] = this.addressSecondLine;
    data['city'] = this.city;
    data['countryIsoTwo'] = this.countryIsoTwo;
    data['description'] = this.description;
    data['id'] = this.id;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['region'] = this.region;
    data['zipCode'] = this.zipCode;
    return data;
  }

  @override
  String toString() {
    return 'MailingAddresse{address: $address, addressSecondLine: $addressSecondLine, city: $city, countryIsoTwo: $countryIsoTwo, description: $description, id: $id, latitude: $latitude, longitude: $longitude, region: $region, zipCode: $zipCode}';
  }
}

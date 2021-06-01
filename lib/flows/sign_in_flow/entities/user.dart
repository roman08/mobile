class CompanyDetails {
  String companyName;
  String companyRole;
  String companyType;
  String directorFirstName;
  String directorLastName;
  int id;
  String maskName;

  CompanyDetails(
      {this.companyName,
      this.companyRole,
      this.companyType,
      this.directorFirstName,
      this.directorLastName,
      this.id,
      this.maskName});

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
    final Map<String, dynamic> data = <String, dynamic>{};
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
    final Map<String, dynamic> data = <String, dynamic>{};
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

class UserData {
  int profileImageId;
  Object blockedUntil;
  String boAddress;
  int boDateOfBirthDay;
  int boDateOfBirthMonth;
  int boDateOfBirthYear;
  String boDocumentPersonalId;
  Object boDocumentType;
  String boFullName;
  String boPhoneNumber;
  String boRelationship;
  Object challengeName;
  int classId;
  CompanyDetails companyDetails;
  Object companyID;
  String countryOfCitizenshipISO2;
  String countryOfResidenceISO2;
  String createdAt;
  String creditRating;
  int dateOfBirthDay;
  int dateOfBirthMonth;
  int dateOfBirthYear;
  String documentPersonalId;
  Object documentType;
  String email;
  String fax;
  String firstName;
  String homePhoneNumber;
  String internalNotes;
  bool isCorporate;
  bool is_email_confirmed;
  bool is_phone_confirmed;
  String lastActedAct;
  String lastLoginAt;
  String lastLoginIp;
  String lastName;
  String maAddress;
  String maAddress2ndLine;
  bool maAsPhysical;
  String maCity;
  String maCountryISO2;
  String maName;
  String maPhoneNumber;
  String maStateProvRegion;
  String maZipPostalCode;
  String middleName;
  String nickname;
  String officePhoneNumber;
  String paAddress;
  String paAddress2ndLine;
  String paCity;
  String paCountryISO2;
  String paStateProvRegion;
  String paZipPostalCode;
  String parentId;
  String phoneNumber;
  String position;
  String roleName;
  Object smsPhoneNumber;
  String status;
  String uid;
  String updatedAt;
  UserGroup userGroup;
  int userGroupId;
  String username;

  UserData(
      {this.profileImageId,
      this.blockedUntil,
      this.boAddress,
      this.boDateOfBirthDay,
      this.boDateOfBirthMonth,
      this.boDateOfBirthYear,
      this.boDocumentPersonalId,
      this.boDocumentType,
      this.boFullName,
      this.boPhoneNumber,
      this.boRelationship,
      this.challengeName,
      this.classId,
      this.companyDetails,
      this.companyID,
      this.countryOfCitizenshipISO2,
      this.countryOfResidenceISO2,
      this.createdAt,
      this.creditRating,
      this.dateOfBirthDay,
      this.dateOfBirthMonth,
      this.dateOfBirthYear,
      this.documentPersonalId,
      this.documentType,
      this.email,
      this.fax,
      this.firstName,
      this.homePhoneNumber,
      this.internalNotes,
      this.isCorporate,
      this.is_email_confirmed,
      this.is_phone_confirmed,
      this.lastActedAct,
      this.lastLoginAt,
      this.lastLoginIp,
      this.lastName,
      this.maAddress,
      this.maAddress2ndLine,
      this.maAsPhysical,
      this.maCity,
      this.maCountryISO2,
      this.maName,
      this.maPhoneNumber,
      this.maStateProvRegion,
      this.maZipPostalCode,
      this.middleName,
      this.nickname,
      this.officePhoneNumber,
      this.paAddress,
      this.paAddress2ndLine,
      this.paCity,
      this.paCountryISO2,
      this.paStateProvRegion,
      this.paZipPostalCode,
      this.parentId,
      this.phoneNumber,
      this.position,
      this.roleName,
      this.smsPhoneNumber,
      this.status,
      this.uid,
      this.updatedAt,
      this.userGroup,
      this.userGroupId,
      this.username});

  String get fullName => '$firstName $lastName';

  static UserData fromJson(Map<String, dynamic> json) {
    return UserData(
      profileImageId: json['profileImageId'] ?? null,
      blockedUntil: json['blockedUntil'] ?? null,
      boAddress: json['boAddress'],
      boDateOfBirthDay: json['boDateOfBirthDay'],
      boDateOfBirthMonth: json['boDateOfBirthMonth'],
      boDateOfBirthYear: json['boDateOfBirthYear'],
      boDocumentPersonalId: json['boDocumentPersonalId'],
      boDocumentType: json['boDocumentType'] ?? null,
      boFullName: json['boFullName'],
      boPhoneNumber: json['boPhoneNumber'],
      boRelationship: json['boRelationship'],
      challengeName: json['challengeName'] ?? null,
      classId: json['classId'],
      companyDetails: json['companyDetails'] != null
          ? CompanyDetails.fromJson(json['companyDetails'])
          : null,
      companyID: json['companyID'] ?? null,
      countryOfCitizenshipISO2: json['countryOfCitizenshipISO2'],
      countryOfResidenceISO2: json['countryOfResidenceISO2'],
      createdAt: json['createdAt'],
      creditRating: json['creditRating'],
      dateOfBirthDay: json['dateOfBirthDay'],
      dateOfBirthMonth: json['dateOfBirthMonth'],
      dateOfBirthYear: json['dateOfBirthYear'],
      documentPersonalId: json['documentPersonalId'],
      documentType: json['documentType'] ?? null,
      email: json['email'],
      fax: json['fax'],
      firstName: json['firstName'],
      homePhoneNumber: json['homePhoneNumber'],
      internalNotes: json['internalNotes'],
      isCorporate: json['isCorporate'],
      is_email_confirmed: json['is_email_confirmed'],
      is_phone_confirmed: json['is_phone_confirmed'],
      lastActedAct: json['lastActedAct'],
      lastLoginAt: json['lastLoginAt'],
      lastLoginIp: json['lastLoginIp'],
      lastName: json['lastName'],
      maAddress: json['maAddress'],
      maAddress2ndLine: json['maAddress2ndLine'],
      maAsPhysical: json['maAsPhysical'],
      maCity: json['maCity'],
      maCountryISO2: json['maCountryISO2'],
      maName: json['maName'],
      maPhoneNumber: json['maPhoneNumber'],
      maStateProvRegion: json['maStateProvRegion'],
      maZipPostalCode: json['maZipPostalCode'],
      middleName: json['middleName'],
      nickname: json['nickname'],
      officePhoneNumber: json['officePhoneNumber'],
      paAddress: json['paAddress'],
      paAddress2ndLine: json['paAddress2ndLine'],
      paCity: json['paCity'],
      paCountryISO2: json['paCountryISO2'],
      paStateProvRegion: json['paStateProvRegion'],
      paZipPostalCode: json['paZipPostalCode'],
      parentId: json['parentId'],
      phoneNumber: json['phoneNumber'],
      position: json['position'],
      roleName: json['roleName'],
      smsPhoneNumber: json['smsPhoneNumber'] ?? null,
      status: json['status'],
      uid: json['uid'],
      updatedAt: json['updatedAt'],
      userGroup: json['userGroup'] != null
          ? UserGroup.fromJson(json['userGroup'])
          : null,
      userGroupId: json['userGroupId'],
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['profileImageId'] = this.profileImageId;
    data['boAddress'] = this.boAddress;
    data['boDateOfBirthDay'] = this.boDateOfBirthDay;
    data['boDateOfBirthMonth'] = this.boDateOfBirthMonth;
    data['boDateOfBirthYear'] = this.boDateOfBirthYear;
    data['boDocumentPersonalId'] = this.boDocumentPersonalId;
    data['boFullName'] = this.boFullName;
    data['boPhoneNumber'] = this.boPhoneNumber;
    data['boRelationship'] = this.boRelationship;
    data['classId'] = this.classId;
    data['countryOfCitizenshipISO2'] = this.countryOfCitizenshipISO2;
    data['countryOfResidenceISO2'] = this.countryOfResidenceISO2;
    data['createdAt'] = this.createdAt;
    data['creditRating'] = this.creditRating;
    data['dateOfBirthDay'] = this.dateOfBirthDay;
    data['dateOfBirthMonth'] = this.dateOfBirthMonth;
    data['dateOfBirthYear'] = this.dateOfBirthYear;
    data['documentPersonalId'] = this.documentPersonalId;
    data['email'] = this.email;
    data['fax'] = this.fax;
    data['firstName'] = this.firstName;
    data['homePhoneNumber'] = this.homePhoneNumber;
    data['internalNotes'] = this.internalNotes;
    data['isCorporate'] = this.isCorporate;
    data['is_email_confirmed'] = this.is_email_confirmed;
    data['is_phone_confirmed'] = this.is_phone_confirmed;
    data['lastActedAct'] = this.lastActedAct;
    data['lastLoginAt'] = this.lastLoginAt;
    data['lastLoginIp'] = this.lastLoginIp;
    data['lastName'] = this.lastName;
    data['maAddress'] = this.maAddress;
    data['maAddress2ndLine'] = this.maAddress2ndLine;
    data['maAsPhysical'] = this.maAsPhysical;
    data['maCity'] = this.maCity;
    data['maCountryISO2'] = this.maCountryISO2;
    data['maName'] = this.maName;
    data['maPhoneNumber'] = this.maPhoneNumber;
    data['maStateProvRegion'] = this.maStateProvRegion;
    data['maZipPostalCode'] = this.maZipPostalCode;
    data['middleName'] = this.middleName;
    data['nickname'] = this.nickname;
    data['officePhoneNumber'] = this.officePhoneNumber;
    data['paAddress'] = this.paAddress;
    data['paAddress2ndLine'] = this.paAddress2ndLine;
    data['paCity'] = this.paCity;
    data['paCountryISO2'] = this.paCountryISO2;
    data['paStateProvRegion'] = this.paStateProvRegion;
    data['paZipPostalCode'] = this.paZipPostalCode;
    data['parentId'] = this.parentId;
    data['phoneNumber'] = this.phoneNumber;
    data['position'] = this.position;
    data['roleName'] = this.roleName;
    data['status'] = this.status;
    data['uid'] = this.uid;
    data['updatedAt'] = this.updatedAt;
    data['userGroupId'] = this.userGroupId;
    data['username'] = this.username;
    if (this.blockedUntil != null) {
      data['blockedUntil'] = this.blockedUntil;
    }
    if (this.boDocumentType != null) {
      data['boDocumentType'] = this.boDocumentType;
    }
    if (this.challengeName != null) {
      data['challengeName'] = this.challengeName;
    }
    if (this.companyDetails != null) {
      data['companyDetails'] = this.companyDetails.toJson();
    }
    if (this.companyID != null) {
      data['companyID'] = this.companyID;
    }
    if (this.documentType != null) {
      data['documentType'] = this.documentType;
    }
    if (this.smsPhoneNumber != null) {
      data['smsPhoneNumber'] = this.smsPhoneNumber;
    }
    if (this.userGroup != null) {
      data['userGroup'] = this.userGroup.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return 'Data{blockedUntil: $blockedUntil, boAddress: $boAddress, boDateOfBirthDay: $boDateOfBirthDay, boDateOfBirthMonth: $boDateOfBirthMonth, boDateOfBirthYear: $boDateOfBirthYear, boDocumentPersonalId: $boDocumentPersonalId, boDocumentType: $boDocumentType, boFullName: $boFullName, boPhoneNumber: $boPhoneNumber, boRelationship: $boRelationship, challengeName: $challengeName, classId: $classId, companyDetails: $companyDetails, companyID: $companyID, countryOfCitizenshipISO2: $countryOfCitizenshipISO2, countryOfResidenceISO2: $countryOfResidenceISO2, createdAt: $createdAt, creditRating: $creditRating, dateOfBirthDay: $dateOfBirthDay, dateOfBirthMonth: $dateOfBirthMonth, dateOfBirthYear: $dateOfBirthYear, documentPersonalId: $documentPersonalId, documentType: $documentType, email: $email, fax: $fax, firstName: $firstName, homePhoneNumber: $homePhoneNumber, internalNotes: $internalNotes, isCorporate: $isCorporate, is_email_confirmed: $is_email_confirmed, is_phone_confirmed: $is_phone_confirmed, lastActedAct: $lastActedAct, lastLoginAt: $lastLoginAt, lastLoginIp: $lastLoginIp, lastName: $lastName, maAddress: $maAddress, maAddress2ndLine: $maAddress2ndLine, maAsPhysical: $maAsPhysical, maCity: $maCity, maCountryISO2: $maCountryISO2, maName: $maName, maPhoneNumber: $maPhoneNumber, maStateProvRegion: $maStateProvRegion, maZipPostalCode: $maZipPostalCode, middleName: $middleName, nickname: $nickname, officePhoneNumber: $officePhoneNumber, paAddress: $paAddress, paAddress2ndLine: $paAddress2ndLine, paCity: $paCity, paCountryISO2: $paCountryISO2, paStateProvRegion: $paStateProvRegion, paZipPostalCode: $paZipPostalCode, parentId: $parentId, phoneNumber: $phoneNumber, position: $position, roleName: $roleName, smsPhoneNumber: $smsPhoneNumber, status: $status, uid: $uid, updatedAt: $updatedAt, userGroup: $userGroup, userGroupId: $userGroupId, username: $username}';
  }
}

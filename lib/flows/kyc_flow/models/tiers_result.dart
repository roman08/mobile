import 'dart:convert';
import 'dart:typed_data';

class Tier {
  Tier({
    this.id,
    this.level,
    this.name,
    this.status,
    this.requirements,
  });

  int id;
  int level;
  String name;
  RequirementStatus status;
  List<Requirement> requirements;

  factory Tier.fromRawJson(String str) => Tier.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  static List<Tier> listFromJson(List<dynamic> list) => list.map((json) => Tier.fromJson(json)).toList();

  static Tier fromJson(Map<String, dynamic> json) => Tier(
        id: json["id"] == null ? null : json["id"],
        level: json["level"] == null ? null : json["level"],
        name: json["name"] == null ? null : json["name"],
        status: json["status"] == null ? null : requirementStatus[json["status"]],
        requirements: json["requirements"] == null
            ? null
            : List<Requirement>.from(json["requirements"].map((x) => Requirement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "level": level == null ? null : level,
        "name": name == null ? null : name,
        "status": status == null ? null : requirementStatus.keys.firstWhere((k) => requirementStatus[k] == status),
        "requirements": requirements == null ? null : List<dynamic>.from(requirements.map((x) => x.toJson())),
      };

  int getRequirementIdByElementIndex(ElementIndex index) {
    return requirements.firstWhere(
      (requirement) {
        final elements = requirement.elements;

        return elements.any((element) => element.index == index);
      },
      orElse: () => null,
    )?.id;
  }
}

enum RequirementStatus {
  notFilled,
  approved,
  notAvailable,
  canceled,
  waiting,
  pending,
}

final Map<String, RequirementStatus> requirementStatus = {
  'not-filled': RequirementStatus.notFilled,
  'approved': RequirementStatus.approved,
  'not-available': RequirementStatus.notAvailable,
  'canceled': RequirementStatus.canceled,
  'waiting': RequirementStatus.waiting,
  'pending': RequirementStatus.pending,
};

class Requirement {
  Requirement({
    this.id,
    this.name,
    this.status,
    this.elements,
  });

  int id;
  String name;
  RequirementStatus status;
  List<Element> elements;

  factory Requirement.fromRawJson(String str) => Requirement.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Requirement.fromJson(Map<String, dynamic> json) => Requirement(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        status: json["status"] == null ? null : requirementStatus[json["status"]],
        elements:
            json["elements"] == null ? null : List<Element>.from(json["elements"].map((x) => Element.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "status": status == null ? null : requirementStatus.keys.firstWhere((k) => requirementStatus[k] == status),
        "elements": elements == null ? null : List<dynamic>.from(elements.map((x) => x.toJson())),
      };
}

enum ElementIndex {
  email,
  fullName,
  phone,
  dateBirth,
  motherMaidenMame,
  type,
  selfiePhoto,
  scanned,
  number,
  scannedIdentification,
  identificationType,
  identificationNumber,
  idFront,
  idBack,

  countryOfBirth,
  nationality,
  taxIdNumber,
  sourceOfFundsIndividual,
  sourceOfFundsCompany,
  website,
  companyPhoneNumber,
  companyDateIncorporated,
  companyName,
  legalRepresentativeName,
  address,
  accountNumber,
  bankName,
  swift,
  beneficialOfficialId,
  beneficialProofPermanentAddress,
  articleIncorporation,
  proofTaxIdNumber,
  proofPermanentAddressRepresentative,
  proofPermanentAddressCompany,
  affidavitAccount,
  proofIncomeStatement,
  lastBankAccountStatement,
  proofPermanentAddress,
  name,
  lastName,
  additionalLastName,
  gender,
  questionnaire,

  /// Affidavit
  fundsTypes,
  comment,
  curp,
  taxId,
  date,
  place,
}

final Map<String, ElementIndex> elementIndexs = {
  'email': ElementIndex.email == null ? null : ElementIndex.email,
  'full_name': ElementIndex.fullName == null ? null : ElementIndex.fullName,
  'phone': ElementIndex.phone == null ? null : ElementIndex.phone,
  'date_birth': ElementIndex.dateBirth == null ? null : ElementIndex.dateBirth,
  'mother_maiden_mame': ElementIndex.motherMaidenMame == null ? null : ElementIndex.motherMaidenMame,
  'type': ElementIndex.type == null ? null : ElementIndex.type,
  'selfie': ElementIndex.selfiePhoto == null ? null : ElementIndex.selfiePhoto,
  'scanned': ElementIndex.scanned == null ? null : ElementIndex.scanned,
  'number': ElementIndex.number == null ? null : ElementIndex.number,
  'identification_scanned': ElementIndex.scannedIdentification == null ? null : ElementIndex.scannedIdentification,
  'identification_type': ElementIndex.identificationType == null ? null : ElementIndex.identificationType,
  'identification_number': ElementIndex.identificationNumber == null ? null : ElementIndex.identificationNumber,
  'front_id': ElementIndex.idFront == null ? null : ElementIndex.idFront,
  'back_id': ElementIndex.idBack == null ? null : ElementIndex.idBack,
  'proof_permanent_address': ElementIndex.proofPermanentAddress == null ? null : ElementIndex.proofPermanentAddress,
  'country_of_birth': ElementIndex.countryOfBirth == null ? null : ElementIndex.countryOfBirth,
  'nationality': ElementIndex.nationality == null ? null : ElementIndex.nationality,
  'tax_id_number': ElementIndex.taxIdNumber == null ? null : ElementIndex.taxIdNumber,
  'source_of_funds_individual': ElementIndex.sourceOfFundsIndividual == null ? null : ElementIndex.sourceOfFundsIndividual,
  'source_of_funds_company': ElementIndex.sourceOfFundsCompany == null ? null : ElementIndex.sourceOfFundsCompany,
  'company_phone_number': ElementIndex.companyPhoneNumber == null ? null : ElementIndex.companyPhoneNumber,
  'company_date_incorporated': ElementIndex.companyDateIncorporated == null ? null : ElementIndex.companyDateIncorporated,
  'company_name': ElementIndex.companyName == null ? null : ElementIndex.companyName,
  'legal_representative_name': ElementIndex.legalRepresentativeName == null ? null : ElementIndex.legalRepresentativeName,
  'account_number': ElementIndex.accountNumber == null ? null : ElementIndex.accountNumber,
  'bank_name': ElementIndex.bankName == null ? null : ElementIndex.bankName,
  'swift': ElementIndex.swift == null ? null : ElementIndex.swift,
  'beneficial_official_id': ElementIndex.beneficialOfficialId == null ? null : ElementIndex.beneficialOfficialId,
  'beneficial_proof_permanent_address': ElementIndex.beneficialProofPermanentAddress == null ? null : ElementIndex.beneficialProofPermanentAddress,
  'article_of_incorporation': ElementIndex.articleIncorporation == null ? null : ElementIndex.articleIncorporation,
  'proof_of_tax_id_number': ElementIndex.proofTaxIdNumber == null ? null : ElementIndex.proofTaxIdNumber,
  'proof_permanent_address_representative': ElementIndex.proofPermanentAddressRepresentative == null ? null : ElementIndex.proofPermanentAddressRepresentative,
  'company_proof_of_permanent_address': ElementIndex.proofPermanentAddressCompany == null ? null : ElementIndex.proofPermanentAddressCompany,
  'affidavit_account': ElementIndex.affidavitAccount == null ? null : ElementIndex.affidavitAccount,
  'proof_income_statement': ElementIndex.proofIncomeStatement == null ? null : ElementIndex.proofIncomeStatement,
  'last_bank_account_statement': ElementIndex.lastBankAccountStatement == null ? null : ElementIndex.lastBankAccountStatement,
  'name': ElementIndex.name == null ? null : ElementIndex.name,
  'last_name': ElementIndex.lastName == null ? null : ElementIndex.lastName,
  'additional_last_name': ElementIndex.additionalLastName == null ? null : ElementIndex.additionalLastName,
  'gender': ElementIndex.gender == null ? null : ElementIndex.gender,
  'address': ElementIndex.address == null ? null : ElementIndex.address,
  'web_site': ElementIndex.website == null ? null : ElementIndex.website,
  'questionnaire': ElementIndex.questionnaire == null ? null : ElementIndex.questionnaire,
  'funds_types': ElementIndex.fundsTypes == null ? null : ElementIndex.fundsTypes,
  'comment': ElementIndex.comment == null ? null : ElementIndex.comment,
  'curp': ElementIndex.curp == null ? null : ElementIndex.curp,
  'tax_id': ElementIndex.taxId == null ? null : ElementIndex.taxId,
  'date': ElementIndex.date == null ? null : ElementIndex.date,
  'place': ElementIndex.place == null ? null : ElementIndex.place,
};

enum ElementType {
  input,
  date,
  options,
  radio,
  file,
}

final Map<String, ElementType> elementTypes = {
  'input': ElementType.input,
  'date': ElementType.date,
  'options': ElementType.options,
  'radio': ElementType.radio,
  'file': ElementType.file,
};

class Element {
  Element({
    this.index,
    this.name,
    this.type,
    this.value,
    this.options,
    this.bytes,
  });

  ElementIndex index;
  String name;
  ElementType type;
  String value;
  Uint8List bytes;
  List<Option> options;

  factory Element.fromRawJson(String str) => Element.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Element.fromJson(Map<String, dynamic> json) => Element(
        index: json["index"] == null ? null : elementIndexs[json["index"]],
        name: json["name"] == null ? null : json["name"],
        type: json["type"] == null ? null : elementTypes[json["type"]],
        value: json["value"] == null ? null : json["value"],
        options: json["options"] == null ? null : List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "index": index == null ? null : elementIndexs.keys.firstWhere((k) => elementIndexs[k] == index),
        "name": name == null ? null : name,
        "type": type == null ? null : elementTypes.keys.firstWhere((k) => elementTypes[k] == type),
        "value": value == null ? null : value,
        "options": options == null ? null : List<dynamic>.from(options.map((x) => x.toJson())),
      };
}

class Option {
  Option({
    this.name,
    this.value,
  });

  String name;
  String value;

  factory Option.fromRawJson(String str) => Option.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        name: json["name"] == null ? null : json["name"],
        value: json["value"] == null ? null : json["value"],
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "value": value == null ? null : value,
      };
}

import '../../../../common/models/country_entity.dart';

class IwtInstruction {
  String additionalInstructions;
  int beneficiaryBankDetailsId;
  int beneficiaryCustomerId;
  DateTime createdAt;
  DateTime updatedAt;
  String currencyCode;
  int id;
  int intermediaryBankDetailsId;
  bool isIwtEnabled;
  BankDetails beneficiaryBankDetails;
  BankDetails intermediaryBankDetails;
  Customer beneficiaryCustomer;

  IwtInstruction.fromJson(Map<String, dynamic> json) {
    additionalInstructions = json['additionalInstructions'];
    beneficiaryBankDetailsId = json['beneficiaryBankDetailsId'];
    beneficiaryCustomerId = json['beneficiaryCustomerId'];
    createdAt = DateTime.parse(json['createdAt']);
    updatedAt = DateTime.parse(json['updatedAt']);
    currencyCode = json['currencyCode'];
    id = json['id'];
    intermediaryBankDetailsId = json['intermediaryBankDetailsId'];
    isIwtEnabled = json['isIwtEnabled'];
    beneficiaryBankDetails =
        BankDetails.fromJson(json['beneficiaryBankDetails']);
    if (json['intermediaryBankDetails'] != null) {
      intermediaryBankDetails =
          BankDetails.fromJson(json['intermediaryBankDetails']);
    }

    beneficiaryCustomer = Customer.fromJson(json['beneficiaryCustomer']);
  }

  @override
  String toString() {
    return 'IwtInstruction{additionalInstructions: $additionalInstructions, beneficiaryBankDetailsId: $beneficiaryBankDetailsId, beneficiaryCustomerId: $beneficiaryCustomerId, createdAt: $createdAt, updatedAt: $updatedAt, currencyCode: $currencyCode, id: $id, intermediaryBankDetailsId: $intermediaryBankDetailsId, isIwtEnabled: $isIwtEnabled, beneficiaryBankDetails: $beneficiaryBankDetails, intermediaryBankDetails: $intermediaryBankDetails, beneficiaryCustomer: $beneficiaryCustomer}';
  }
}

class BankDetails {
  String abaNumber;
  String bankName;
  String address;
  int countryId;
  DateTime createdAt;
  DateTime updatedAt;
  int id;
  String location;
  String iban;
  String swiftCode;
  CountryEntity country;

  BankDetails.fromJson(Map<String, dynamic> json) {
    abaNumber = json['abaNumber'];
    bankName = json['bankName'];
    address = json['address'];
    countryId = json['countryId'];
    createdAt = DateTime.parse(json['createdAt']);
    updatedAt = DateTime.parse(json['updatedAt']);
    id = json['id'];
    location = json['location'];
    iban = json['iban'];
    swiftCode = json['swiftCode'];
    country = CountryEntity.fromJson(json['country']);
  }
}

class Customer {
  String accountName;
  String address;
  DateTime createdAt;
  DateTime updatedAt;
  String iban;
  int id;

  Customer.fromJson(Map<String, dynamic> json) {
    createdAt = DateTime.parse(json['createdAt']);
    updatedAt = DateTime.parse(json['updatedAt']);
    accountName = json['accountName'];
    address = json['address'];
    iban = json['iban'];
    id = json['id'];
  }

  @override
  String toString() {
    return 'Customer{accountName: $accountName, address: $address, createdAt: $createdAt, updatedAt: $updatedAt, iban: $iban, id: $id}';
  }
}

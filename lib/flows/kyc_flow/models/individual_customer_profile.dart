import 'package:Velmie/flows/kyc_flow/models/tiers_result.dart';

import 'affidavit.dart';
import 'customer_profile.dart';

class IndividualCustomerProfile extends CustomerProfile {
  final String name;
  final String fathersSurname;
  final String mothersSurname;
  final String birthday;
  final String gender;
  final String countryOfBirth;
  final Affidavit affidavit;

  const IndividualCustomerProfile({
    this.name,
    this.fathersSurname,
    this.mothersSurname,
    this.birthday,
    this.gender,
    this.countryOfBirth,
    this.affidavit,
    String nationality,
    String phone,
    String email,
    String address,
    String taxIdNumber,
    String accountNumber,
    String bankName,
    String bankAddress,
    String idFront,
    String idBack,
    String selfie,
    String proofPermanentAddress,
    String proofTaxId,
    String proofIncomeStatement,
    String lastBankAccountStatement,
    String termsAndConditions,
  }) : super(
          nationality: nationality,
          phone: phone,
          email: email,
          address: address,
          taxIdNumber: taxIdNumber,
          accountNumber: accountNumber,
          bankName: bankName,
          bankAddress: bankAddress,
          idFront: idFront,
          idBack: idBack,
          selfie: selfie,
          proofPermanentAddress: proofPermanentAddress,
          proofTaxId: proofTaxId,
          proofIncomeStatement: proofIncomeStatement,
          lastBankAccountStatement: lastBankAccountStatement,
          termsAndConditions: termsAndConditions,
        );

  factory IndividualCustomerProfile.fromTier(Tier tier) {
    print('////************ hola tier');
    print(tier.requirements);
    if(tier.requirements.length > 0 ){
       print('////************ SI HAY DATOS');
       print(tier.requirements[6].elements);
      return IndividualCustomerProfile(
      name: tier.requirements[0].elements.first.value,
      fathersSurname: tier.requirements[1].elements[0].value,
      mothersSurname: tier.requirements[1].elements[1].value,
      birthday: tier.requirements[2].elements.first.value.split('/').reversed.join('-'),
      gender: tier.requirements[3].elements.first.value,
      nationality: tier.requirements[4].elements.first.value,
      phone: tier.requirements[5].elements.first.value,
      email: tier.requirements[6].elements.first.value,
      address: tier.requirements[7].elements.first.value,
      taxIdNumber: tier.requirements[8].elements.first.value,
      accountNumber: tier.requirements[9].elements[0].value,
      bankName: tier.requirements[9].elements[1].value,
      bankAddress: tier.requirements[9].elements[2].value,
      idFront: tier.requirements[10].elements[0].value,
      idBack: tier.requirements[10].elements[1].value,
      selfie: tier.requirements[10].elements[2].value,
      proofTaxId: tier.requirements[11].elements.first.value,
      proofPermanentAddress: tier.requirements[12].elements.first.value,
      proofIncomeStatement: tier.requirements[13].elements.first.value,
      lastBankAccountStatement: tier.requirements[14].elements.first.value,
      termsAndConditions: tier.requirements[15].elements.first.value,
      countryOfBirth: tier.requirements[16].elements.first.value,
      affidavit: Affidavit.fromRequirement(tier.requirements[17]),
    );
    }else {
       print('////************ NO HAY DATOS');
    return IndividualCustomerProfile(
      name: '',
      fathersSurname: '',
      mothersSurname: '',
      birthday: '',
      gender: '',
      nationality: '',
      phone: '',
      email: '',
      address: '',
      taxIdNumber: '',
      accountNumber: '',
      bankName: '',
      bankAddress: '',
      idFront: '',
      idBack: '',
      selfie: '',
      proofTaxId: '',
      proofPermanentAddress: '',
      proofIncomeStatement: '',
      lastBankAccountStatement: '',
      termsAndConditions: '',
      countryOfBirth: '',
      affidavit: null,

    );
    }
  }
}

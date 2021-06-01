import 'package:Velmie/flows/kyc_flow/models/affidavit.dart';
import 'package:Velmie/flows/kyc_flow/models/customer_profile.dart';
import 'package:Velmie/flows/kyc_flow/models/tiers_result.dart';

class CorporateCustomerProfile extends CustomerProfile {
  final String companyName;
  final String website;
  final String incorporateDate;
  final String legalRepresentativeName;
  final String legalRepresentativeAddress;
  final String articleIncorporation;
  final String proofPermanentAddressRepresentative;
  final String proofCompanyPermanentAddress;
  final String accountAffidavit;
  final String questionnaire;
  final String beneficialProofPermanentAddress;
  final String beneficialId;
  final Affidavit affidavit;

  const CorporateCustomerProfile({
    this.companyName,
    this.website,
    this.incorporateDate,
    this.legalRepresentativeName,
    this.legalRepresentativeAddress,
    this.articleIncorporation,
    this.proofPermanentAddressRepresentative,
    this.proofCompanyPermanentAddress,
    this.accountAffidavit,
    this.questionnaire,
    this.beneficialProofPermanentAddress,
    this.beneficialId,
    this.affidavit,
    String nationality,
    String phone,
    String email,
    String address,
    String taxIdNumber,
    String sourceOfFunds,
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
          sourceOfFunds: sourceOfFunds,
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

  factory CorporateCustomerProfile.fromTier(Tier tier) {
    return CorporateCustomerProfile(
      nationality: tier.requirements[0].elements.first.value,
      email: tier.requirements[1].elements.first.value,
      taxIdNumber: tier.requirements[2].elements.first.value,
      sourceOfFunds: tier.requirements[3].elements.first.value,
      website: tier.requirements[4].elements.first.value,
      phone: tier.requirements[5].elements.first.value,
      incorporateDate: tier.requirements[6].elements.first.value.split('/').reversed.join('-'),
      companyName: tier.requirements[7].elements.first.value,
      legalRepresentativeName: tier.requirements[8].elements.first.value,
      address: tier.requirements[9].elements.first.value,
      legalRepresentativeAddress: tier.requirements[10].elements.first.value,
      accountNumber: tier.requirements[11].elements[0].value,
      bankName: tier.requirements[11].elements[1].value,
      bankAddress: tier.requirements[11].elements[2].value,
      beneficialId: tier.requirements[12].elements.first.value,
      beneficialProofPermanentAddress: tier.requirements[13].elements.first.value,
      idFront: tier.requirements[14].elements[0].value,
      idBack: tier.requirements[14].elements[1].value,
      selfie: tier.requirements[14].elements[2].value,
      articleIncorporation: tier.requirements[15].elements.first.value,
      proofTaxId: tier.requirements[16].elements.first.value,
      proofPermanentAddressRepresentative: tier.requirements[17].elements.first.value,
      proofCompanyPermanentAddress: tier.requirements[18].elements.first.value,
      accountAffidavit: tier.requirements[19].elements.first.value,
      proofIncomeStatement: tier.requirements[20].elements.first.value,
      lastBankAccountStatement: tier.requirements[21].elements.first.value,
      termsAndConditions: tier.requirements[22].elements.first.value,
      questionnaire: tier.requirements[23].elements.first.value,
      affidavit: Affidavit.fromRequirement(tier.requirements[24]),
    );
  }
}

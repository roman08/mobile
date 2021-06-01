abstract class CustomerProfile {
  final String nationality;
  final String phone;
  final String email;
  final String address;
  final String taxIdNumber;
  final String sourceOfFunds;
  final String accountNumber;
  final String bankName;
  final String bankAddress;

  final String idFront;
  final String idBack;
  final String selfie;
  final String proofPermanentAddress;
  final String proofTaxId;
  final String proofIncomeStatement;
  final String lastBankAccountStatement;

  final String termsAndConditions;

  const CustomerProfile({
    this.nationality,
    this.phone,
    this.email,
    this.address,
    this.taxIdNumber,
    this.sourceOfFunds,
    this.accountNumber,
    this.bankName,
    this.bankAddress,
    this.idFront,
    this.idBack,
    this.selfie,
    this.proofPermanentAddress,
    this.proofTaxId,
    this.proofIncomeStatement,
    this.lastBankAccountStatement,
    this.termsAndConditions,
  });

  DateTime parseDate(String date) {
    return DateTime.parse(date.split('/').reversed.join('-'));
  }
}
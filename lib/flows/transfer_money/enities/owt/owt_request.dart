import '../common/country_entity.dart';
import '../common/currency_entity.dart';

class OwtRequest {
  int accountIdFrom;
  String bankAbaRtn;
  String bankAddress;
  CountryEntity bankCountry;
  String bankLocation;
  String bankName;
  String bankSwiftBic;
  String confirmTotalOutgoingAmount;
  String customerAccIban;
  String customerAddress;
  String customerName;
  String description;
  int feeId;
  String intermediaryBankAbaRtn;
  String intermediaryBankAccIban;
  String intermediaryBankAddress;
  CountryEntity intermediaryBankCountry;
  String intermediaryBankLocation;
  String intermediaryBankName;
  String intermediaryBankSwiftBic;
  bool isIntermediaryBankRequired;
  String outgoingAmount;
  String refMessage;
  CurrencyEntity referenceCurrency;

  @override
  String toString() {
    return 'OwtRequest{accountIdFrom: $accountIdFrom, bankAbaRtn: $bankAbaRtn, bankAddress: $bankAddress, bankCountry: $bankCountry, bankLocation: $bankLocation, bankName: $bankName, bankSwiftBic: $bankSwiftBic, confirmTotalOutgoingAmount: $confirmTotalOutgoingAmount, customerAccIban: $customerAccIban, customerAddress: $customerAddress, customerName: $customerName, description: $description, feeId: $feeId, intermediaryBankAbaRtn: $intermediaryBankAbaRtn, intermediaryBankAccIban: $intermediaryBankAccIban, intermediaryBankAddress: $intermediaryBankAddress, intermediaryBankCountry: $intermediaryBankCountry, intermediaryBankLocation: $intermediaryBankLocation, intermediaryBankName: $intermediaryBankName, intermediaryBankSwiftBic: $intermediaryBankSwiftBic, isIntermediaryBankRequired: $isIntermediaryBankRequired, outgoingAmount: $outgoingAmount, refMessage: $refMessage, referenceCurrency: $referenceCurrency}';
  }
}

import 'package:Velmie/flows/kyc_flow/models/tiers_result.dart';

class Affidavit {
  final String fullName;
  final String fundTypes;
  final List<String> fundTypesOptions;
  final String comment;
  final String address;
  final String curp;
  final String nationality;
  final String taxId;
  final String date;
  final String place;

  List<String> get fundTypesList => fundTypes?.split('.')?.toList() ?? [];

  Affidavit({
    this.fullName,
    this.fundTypes,
    this.fundTypesOptions,
    this.comment,
    this.address,
    this.curp,
    this.nationality,
    this.taxId,
    this.date,
    this.place,
  });

  factory Affidavit.fromRequirement(Requirement requirement) {
    return Affidavit(
      fullName: requirement.elements[0].value,
      fundTypes: requirement.elements[1].value,
      fundTypesOptions: requirement.elements[1].options?.map((Option e) => e.value)?.toList() ?? [],
      comment: requirement.elements[2].value,
      address: requirement.elements[3].value,
      curp: requirement.elements[4].value,
      nationality: requirement.elements[5].value,
      taxId: requirement.elements[6].value,
      date: requirement.elements[7].value.replaceAll('/', '-'),
      place: requirement.elements[8].value,
    );
  }
}

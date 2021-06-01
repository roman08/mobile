import 'dart:typed_data';

class CardDocuments {
  final Uint8List termsAndConditions;
  final Uint8List fees;

  const CardDocuments({
    this.termsAndConditions,
    this.fees,
  });
}

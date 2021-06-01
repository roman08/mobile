part of 'terms_and_conditions_cubit.dart';

enum TermsAndConditionsStatus {
  loading,
  success,
  error,
}

class TermsAndConditionsState {
  final TermsAndConditionsStatus status;
  final Uint8List termsAndConditionsDocument;

  TermsAndConditionsState({
    this.termsAndConditionsDocument,
    this.status = TermsAndConditionsStatus.loading,
  });

  TermsAndConditionsState copyWith({
    Uint8List termsAndConditionsDocument,
    TermsAndConditionsStatus status,
  }) {
    return TermsAndConditionsState(
      termsAndConditionsDocument: termsAndConditionsDocument ?? this.termsAndConditionsDocument,
      status: status ?? this.status,
    );
  }

  @override
  String toString() => 'TermsAndConditionsState{termsAndConditionsDocument: $termsAndConditionsDocument, '
      'status: $status}';
}

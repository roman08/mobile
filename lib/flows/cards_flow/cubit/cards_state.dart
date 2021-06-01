part of 'cards_cubit.dart';

class CardsState {
  final bool termsAndConditionsAccepted;
  final bool cardFeesAccepted;
  final CardStatus cardStatus;
  final bool kycDone;
  final CardDocuments documents;

  const CardsState({
    this.termsAndConditionsAccepted = false,
    this.cardFeesAccepted = false,
    this.cardStatus = CardStatus.notRequested,
    this.kycDone = false,
    this.documents,
  });

  CardsState copyWith({
    bool termsAndConditionsAccepted,
    bool cardFeesAccepted,
    CardStatus cardStatus,
    bool kycDone,
    CardDocuments documents,
  }) {
    return CardsState(
      termsAndConditionsAccepted: termsAndConditionsAccepted ?? this.termsAndConditionsAccepted,
      cardFeesAccepted: cardFeesAccepted ?? this.cardFeesAccepted,
      cardStatus: cardStatus ?? this.cardStatus,
      kycDone: kycDone ?? this.kycDone,
      documents: documents ?? this.documents,
    );
  }
}

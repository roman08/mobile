enum CardStatus {
  notRequested,
  pending,
  completed,
  unknown,
}

extension CardStatusExtension on CardStatus {
  String get value {
    switch (this) {
      case CardStatus.notRequested: return 'not-requested';
      case CardStatus.pending: return 'pending';
      case CardStatus.completed: return 'completed';
      case CardStatus.unknown: return 'unknown';
      default: return '';
    }
  }
}

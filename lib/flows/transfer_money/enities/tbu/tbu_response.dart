class TbuResponse {
  String amount;
  String baseCurrencyCode;
  String cancellationReason;
  String createdAt;
  String description;
  int id;
  bool isInitiatedBySystem;
  String rate;
  String referenceCurrencyCode;
  String status;
  String statusChangedAt;
  String subject;
  String updatedAt;
  String userId;

  TbuResponse(
      {this.amount,
      this.baseCurrencyCode,
      this.cancellationReason,
      this.createdAt,
      this.description,
      this.id,
      this.isInitiatedBySystem,
      this.rate,
      this.referenceCurrencyCode,
      this.status,
      this.statusChangedAt,
      this.subject,
      this.updatedAt,
      this.userId});

  static TbuResponse fromJson(Map<String, dynamic> json) {
    return TbuResponse(
      amount: json['amount'],
      baseCurrencyCode: json['baseCurrencyCode'],
      cancellationReason: json['cancellationReason'],
      createdAt: json['createdAt'],
      description: json['description'],
      id: json['id'],
      isInitiatedBySystem: json['isInitiatedBySystem'],
      rate: json['rate'],
      referenceCurrencyCode: json['referenceCurrencyCode'],
      status: json['status'],
      statusChangedAt: json['statusChangedAt'],
      subject: json['subject'],
      updatedAt: json['updatedAt'],
      userId: json['userId'],
    );
  }

  @override
  String toString() {
    return 'TbuResponse{amount: $amount, baseCurrencyCode: $baseCurrencyCode, cancellationReason: $cancellationReason, createdAt: $createdAt, description: $description, id: $id, isInitiatedBySystem: $isInitiatedBySystem, rate: $rate, referenceCurrencyCode: $referenceCurrencyCode, status: $status, statusChangedAt: $statusChangedAt, subject: $subject, updatedAt: $updatedAt, userId: $userId}';
  }
}

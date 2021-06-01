class TbuRequestPreviewRequest {
  int accountIdFrom;
  int moneyRequestId;

  TbuRequestPreviewRequest({
    this.accountIdFrom,
    this.moneyRequestId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accountIdFrom'] = this.accountIdFrom;
    data['moneyRequestId'] = this.moneyRequestId;
    return data;
  }

  @override
  String toString() {
    return 'TbuPreviewRequest{accountIdFrom: $accountIdFrom, moneyRequestId: $moneyRequestId}';
  }
}

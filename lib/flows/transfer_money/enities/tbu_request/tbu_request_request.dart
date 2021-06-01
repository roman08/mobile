class TbuRequestRequest {
  int accountIdFrom;
  int moneyRequestId;

  TbuRequestRequest({this.accountIdFrom, this.moneyRequestId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accountIdFrom'] = this.accountIdFrom;
    data['moneyRequestId'] = this.moneyRequestId;
    return data;
  }

  @override
  String toString() {
    return 'TbuRequestRequest{accountIdFrom: $accountIdFrom, moneyRequestId: $moneyRequestId}';
  }
}

class TbuPreviewRequest {
  int accountIdFrom;
  String accountNumberTo;
  String outgoingAmount;
  String userName;

  TbuPreviewRequest({
    this.accountIdFrom,
    this.accountNumberTo,
    this.outgoingAmount,
    this.userName,
  });

  factory TbuPreviewRequest.fromJson(Map<String, dynamic> json) {
    return TbuPreviewRequest(
      accountIdFrom: json['accountIdFrom'],
      accountNumberTo: json['accountNumberTo'],
      outgoingAmount: json['outgoingAmount'],
      userName: json['userName'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accountIdFrom'] = this.accountIdFrom;
    data['accountNumberTo'] = this.accountNumberTo;
    data['outgoingAmount'] = this.outgoingAmount.replaceFirst(RegExp(','), '.');
    data['userName'] = this.userName;
    return data;
  }

  @override
  String toString() {
    return 'TransactionPreviewRequest{accountIdFrom: $accountIdFrom, accountNumberTo: $accountNumberTo, outgoingAmount: $outgoingAmount, userName: $userName}';
  }
}

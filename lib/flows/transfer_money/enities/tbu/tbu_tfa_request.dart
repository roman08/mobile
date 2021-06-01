class Tbu2FARequest {
  int accountIdFrom;
  String accountNumberTo;
  String outgoingAmount;
  bool saveAsTemplate;
  String templateName;
  String userName;

  Tbu2FARequest(
      {this.accountIdFrom,
      this.accountNumberTo,
      this.outgoingAmount,
      this.saveAsTemplate,
      this.templateName,
      this.userName});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accountIdFrom'] = this.accountIdFrom;
    data['accountNumberTo'] = this.accountNumberTo;
    data['outgoingAmount'] = this.outgoingAmount;
    data['saveAsTemplate'] = this.saveAsTemplate;
    data['templateName'] = this.templateName;
    data['userName'] = this.userName;
    return data;
  }

  @override
  String toString() {
    return 'Tbu2FARequest{accountIdFrom: $accountIdFrom, accountNumberTo: $accountNumberTo, outgoingAmount: $outgoingAmount, saveAsTemplate: $saveAsTemplate, templateName: $templateName, userName: $userName}';
  }
}

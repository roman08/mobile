class TbuRequest {
  int accountIdFrom;
  String userName;
  String accountNumberTo;
  String outgoingAmount;
  String description;
  String incomingAmount;
  bool saveAsTemplate;
  String templateName;

  TbuRequest({
    this.accountIdFrom,
    this.userName,
    this.accountNumberTo,
    this.outgoingAmount,
    this.description,
    this.incomingAmount,
    this.saveAsTemplate,
    this.templateName,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accountIdFrom'] = this.accountIdFrom;
    data['userName'] = this.userName;
    data['accountNumberTo'] = this.accountNumberTo;
    data['outgoingAmount'] = this.outgoingAmount.replaceFirst(RegExp(','), '.');
    data['description'] = this.description;
    data['incomingAmount'] = this.incomingAmount;
    data['saveAsTemplate'] = this.saveAsTemplate;
    data['templateName'] = this.templateName;
    return data;
  }

  @override
  String toString() {
    return 'TbuRequest{accountIdFrom: $accountIdFrom, userName: $userName, accountNumberTo: $accountNumberTo, outgoingAmount: $outgoingAmount, description: $description, incomingAmount: $incomingAmount, saveAsTemplate: $saveAsTemplate, templateName: $templateName}';
  }
}

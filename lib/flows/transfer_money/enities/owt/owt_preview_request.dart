class OwtPreviewRequest {
  int accountIdFrom;
  String bankName;
  int feeId;
  String outgoingAmount;
  String referenceCurrencyCode;
  bool saveAsTemplate;
  String templateName;

  OwtPreviewRequest({
    this.accountIdFrom,
    this.bankName,
    this.feeId,
    this.outgoingAmount,
    this.referenceCurrencyCode,
    this.saveAsTemplate,
    this.templateName,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accountIdFrom'] = this.accountIdFrom;
    data['bankName'] = this.bankName;
    data['feeId'] = this.feeId;
    data['outgoingAmount'] = this.outgoingAmount.replaceFirst(RegExp(','), '.');
    data['referenceCurrencyCode'] = this.referenceCurrencyCode;
    data['saveAsTemplate'] = this.saveAsTemplate;
    data['templateName'] = this.templateName;
    return data;
  }

  @override
  String toString() {
    return 'OwtPreviewRequest{accountIdFrom: $accountIdFrom, bankName: $bankName, feeId: $feeId, outgoingAmount: $outgoingAmount, referenceCurrencyCode: $referenceCurrencyCode, saveAsTemplate: $saveAsTemplate, templateName: $templateName}';
  }
}

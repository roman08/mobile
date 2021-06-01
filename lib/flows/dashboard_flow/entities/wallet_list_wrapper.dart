class WalletListWrapper {
  List<Wallet> walletList;
  Links links;

  WalletListWrapper({this.walletList, this.links});

  static WalletListWrapper fromJson(Map<String, dynamic> json) {
    return WalletListWrapper(
      walletList: json['data'] != null
          ? (json['data'] as List).map((i) => Wallet.fromJson(i)).toList()
          : null,
      links: json['links'] != null ? Links.fromJson(json['links']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.walletList != null) {
      data['data'] = this.walletList.map((v) => v.toJson()).toList();
    }
    if (this.links != null) {
      data['links'] = this.links.toJson();
    }
    return data;
  }
}

class Wallet {
  bool allowDeposits;
  bool allowWithdrawals;
  String availableAmount;
  String balance;
  String createdAt;
  String description;
  int id;
  Object interestAccountId;
  bool isActive;
  Object maturityDate;
  String number;
  int payoutDay;
  Type type;
  int typeId;
  String userId;
  bool isChecked;

  Wallet(
      {this.allowDeposits,
      this.allowWithdrawals,
      this.availableAmount,
      this.balance,
      this.createdAt,
      this.description,
      this.id,
      this.interestAccountId,
      this.isActive,
      this.maturityDate,
      this.number,
      this.payoutDay,
      this.type,
      this.typeId,
      this.userId,
      this.isChecked});

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      allowDeposits: json['allowDeposits'],
      allowWithdrawals: json['allowWithdrawals'],
      availableAmount: json['availableAmount'],
      balance: json['balance'],
      createdAt: json['createdAt'],
      description: json['description'],
      id: json['id'],
      interestAccountId: json['interestAccountId'] ?? null,
      isActive: json['isActive'],
      maturityDate: json['maturityDate'] ?? null,
      number: json['number'],
      payoutDay: json['payoutDay'] ?? null,
      type: json['type'] != null ? Type.fromJson(json['type']) : null,
      typeId: json['typeId'],
      userId: json['userId'],
      isChecked: false

    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['allowDeposits'] = this.allowDeposits;
    data['allowWithdrawals'] = this.allowWithdrawals;
    data['availableAmount'] = this.availableAmount;
    data['balance'] = this.balance;
    data['createdAt'] = this.createdAt;
    data['description'] = this.description;
    data['id'] = this.id;
    data['isActive'] = this.isActive;
    data['number'] = this.number;
    data['typeId'] = this.typeId;
    data['userId'] = this.userId;
    data['isChecked'] = this.isChecked;
    if (this.interestAccountId != null) {
      data['interestAccountId'] = this.interestAccountId;
    }
    if (this.maturityDate != null) {
      data['maturityDate'] = this.maturityDate;
    }
    if (this.payoutDay != null) {
      data['payoutDay'] = this.payoutDay;
    }
    if (this.type != null) {
      data['type'] = this.type.toJson();
    }
    return data;
  }

  String getShortNumberString() {
    if (number.length > 4) {
      return number.substring(number.length - 4, number.length);
    } else {
      return number;
    }
  }
}

class Type {
  bool autoNumberGeneration;
  Object balanceChargeDay;
  Object balanceFeeAmount;
  Object balanceLimitAmount;
  Object creditAnnualInterestRate;
  Object creditChargeDay;
  Object creditChargePeriodId;
  Object creditLimitAmount;
  Object creditPayoutMethodId;
  String currencyCode;
  String depositAnnualInterestRate;
  int depositPayoutDay;
  int depositPayoutMethodId;
  int depositPayoutPeriodId;
  int id;
  Object monthlyMaintenanceFee;
  String name;

  Type(
      {this.autoNumberGeneration,
      this.balanceChargeDay,
      this.balanceFeeAmount,
      this.balanceLimitAmount,
      this.creditAnnualInterestRate,
      this.creditChargeDay,
      this.creditChargePeriodId,
      this.creditLimitAmount,
      this.creditPayoutMethodId,
      this.currencyCode,
      this.depositAnnualInterestRate,
      this.depositPayoutDay,
      this.depositPayoutMethodId,
      this.depositPayoutPeriodId,
      this.id,
      this.monthlyMaintenanceFee,
      this.name});

  factory Type.fromJson(Map<String, dynamic> json) {
    return Type(
      autoNumberGeneration: json['autoNumberGeneration'],
      balanceChargeDay: json['balanceChargeDay'] ?? null,
      balanceFeeAmount: json['balanceFeeAmount'] ?? null,
      balanceLimitAmount: json['balanceLimitAmount'] ?? null,
      creditAnnualInterestRate: json['creditAnnualInterestRate'] ?? null,
      creditChargeDay: json['creditChargeDay'] ?? null,
      creditChargePeriodId: json['creditChargePeriodId'] ?? null,
      creditLimitAmount: json['creditLimitAmount'] ?? null,
      creditPayoutMethodId: json['creditPayoutMethodId'] ?? null,
      currencyCode: json['currencyCode'],
      depositAnnualInterestRate: json['depositAnnualInterestRate'],
      depositPayoutDay: json['depositPayoutDay'],
      depositPayoutMethodId: json['depositPayoutMethodId'],
      depositPayoutPeriodId: json['depositPayoutPeriodId'],
      id: json['id'],
      monthlyMaintenanceFee: json['monthlyMaintenanceFee'] ?? null,
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['autoNumberGeneration'] = this.autoNumberGeneration;
    data['currencyCode'] = this.currencyCode;
    data['depositAnnualInterestRate'] = this.depositAnnualInterestRate;
    data['depositPayoutDay'] = this.depositPayoutDay;
    data['depositPayoutMethodId'] = this.depositPayoutMethodId;
    data['depositPayoutPeriodId'] = this.depositPayoutPeriodId;
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.balanceChargeDay != null) {
      data['balanceChargeDay'] = this.balanceChargeDay;
    }
    if (this.balanceFeeAmount != null) {
      data['balanceFeeAmount'] = this.balanceFeeAmount;
    }
    if (this.balanceLimitAmount != null) {
      data['balanceLimitAmount'] = this.balanceLimitAmount;
    }
    if (this.creditAnnualInterestRate != null) {
      data['creditAnnualInterestRate'] = this.creditAnnualInterestRate;
    }
    if (this.creditChargeDay != null) {
      data['creditChargeDay'] = this.creditChargeDay;
    }
    if (this.creditChargePeriodId != null) {
      data['creditChargePeriodId'] = this.creditChargePeriodId;
    }
    if (this.creditLimitAmount != null) {
      data['creditLimitAmount'] = this.creditLimitAmount;
    }
    if (this.creditPayoutMethodId != null) {
      data['creditPayoutMethodId'] = this.creditPayoutMethodId;
    }
    if (this.monthlyMaintenanceFee != null) {
      data['monthlyMaintenanceFee'] = this.monthlyMaintenanceFee;
    }
    return data;
  }
}

class Links {
  String first;
  String last;
  Object next;
  Object prev;
  String self;

  Links({this.first, this.last, this.next, this.prev, this.self});

  factory Links.fromJson(Map<String, dynamic> json) {
    return Links(
      first: json['first'],
      last: json['last'],
      next: json['next'] ?? null,
      prev: json['prev'] ?? null,
      self: json['self'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first'] = this.first;
    data['last'] = this.last;
    data['self'] = this.self;
    if (this.next != null) {
      data['next'] = this.next;
    }
    if (this.prev != null) {
      data['prev'] = this.prev;
    }
    return data;
  }
}

class InvestmentAccountConditionsEntity {
  final int id;
  final String name;
  final double minFunds;
  final String currency;
  final String rate;
  final int duration;
  final double fee;
  final String paramCurrency;

  const InvestmentAccountConditionsEntity({
    this.id,
    this.name,
    this.minFunds,
    this.currency,
    this.rate,
    this.duration,
    this.fee,
    this.paramCurrency,
  });

  factory InvestmentAccountConditionsEntity.fromJson(Map<String, dynamic> json) {
    return InvestmentAccountConditionsEntity(
      id: json['id'],
      name: json['name'],
      minFunds: double.parse(json['minFunds']),
      currency: json['currency'],
      rate: json['rate'],
      duration: json['duration'],
      fee: double.parse(json['fee']),
      paramCurrency: json['paramCurrency'],
    );
  }
}

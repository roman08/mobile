class TransactionEntity {
  TransactionEntity({
    this.amount,
    this.id,
  });

  String amount;
  String id;

  factory TransactionEntity.fromJson(Map<String, dynamic> json) => TransactionEntity(
        amount: json["amount"],
        id: json["id"],
      );

  @override
  String toString() {
    return "TransactionEntity { amount = $amount, id = $id }";
  }
}

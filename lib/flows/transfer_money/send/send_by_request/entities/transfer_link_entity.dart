class TransferByRequestEntity {
    String username;
    String phoneNumber;
    String amount;
    String description;
    int moneyRequestId;
    String currencyCode;

    TransferByRequestEntity({
        this.username,
        this.phoneNumber,
        this.amount,
        this.description,
        this.moneyRequestId,
        this.currencyCode
    });
}

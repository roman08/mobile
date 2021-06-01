import '../../../enities/common/wallet_entity.dart';

class TransferByQrEntity {
    String username;
    String phoneNumber;
    String amount;
    String description;
    WalletEntity wallet;

    TransferByQrEntity({
        this.username,
        this.phoneNumber,
        this.amount,
        this.description,
        this.wallet,
    });

    TransferByQrEntity.fromJson(Map<String, dynamic> json) {
        username = json["username"];
        phoneNumber = json["phoneNumber"];
        amount = json["amount"];
        description = json["description"];
        wallet = WalletEntity.fromJson(json["wallet"]);
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data["username"] = this.username;
        data["phoneNumber"] = this.phoneNumber;
        data["amount"] = this.amount;
        data["description"] = this.description;
        data["wallet"] = this.wallet.toJson();
        return data;
    }

    @override
    String toString() {
        return 'RecipientQREntity{username: $username, phoneNumber: $phoneNumber, amount: $amount, description: $description, wallet: $wallet}';
    }
}

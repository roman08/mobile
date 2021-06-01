import 'fees_entity.dart';
import 'recipient_entity.dart';
import 'request_enum.dart';

class RequestEntity {
  RequestEntity({
    this.id,
    this.amount,
    this.balanceSnapshot,
    this.createdAt,
    this.description,
    this.purpose,
    this.requestId,
    this.requestRate,
    this.requestSubject,
    this.showRequestId,
    this.status,
    this.statusChangedAt,
    this.type,
    this.updatedAt,
    this.recipient,
    this.fees,
    this.sender,
  });

  int id;
  String amount;
  String total;
  String balanceSnapshot;
  String billCategory;
  RequestCategory category;
  DateTime createdAt;
  String description;
  String purpose;
  String baseCurrencyCode;
  int requestId;
  String requestRate;
  String requestSubject;
  bool showRequestId;
  RequestStatus status;
  DateTime statusChangedAt;
  String type;
  DateTime updatedAt;
  RecipientEntity recipient;
  String amountInFiat;
  FeesEntity fees;
  RecipientEntity sender;

  static RequestEntity fromJson(Map<String, dynamic> json) => RequestEntity(
        amount: json["amount"],
        balanceSnapshot: json["balanceSnapshot"],
        createdAt: DateTime.parse(json["createdAt"]),
        description: json["description"],
        id: json["id"] as int,
        purpose: json["purpose"],
        recipient: json["recipient"] == null ? null : RecipientEntity.fromJson(json["recipient"]),
        requestId: json["requestId"] as int,
        requestRate: json["requestRate"],
        requestSubject: json["requestSubject"],
        showRequestId: json["showRequestId"],
        status: RequestEnums.stringAsRequestStatus(json["status"]),
        statusChangedAt: DateTime.parse(json["statusChangedAt"]),
        type: json["type"],
        updatedAt: DateTime.parse(json["updatedAt"]),
        fees: json["fees"] == null ? null : FeesEntity.fromJson(json["fees"]),
        sender: json["sender"] == null ? null : RecipientEntity.fromJson(json["sender"]),
      );

  @override
  String toString() {
    return "RequestEntity {id = $id, amount = $amount, total = $total, balanceSnapshot = $balanceSnapshot, billCategory = $billCategory, category = $category, createdAt = $createdAt, description = $description, purpose = $purpose, recipient = $recipient, requestId = $requestId, requestRate = $requestRate, requestSubject = $requestSubject, showRequestId = $showRequestId, status = $status, statusChangedAt = $statusChangedAt, type = $type, updatedAt = $updatedAt, amountInFiat = $amountInFiat, fees = $fees, sender = $sender,}";
  }
}

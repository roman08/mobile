import 'package:rxdart/rxdart.dart';

import '../../../../../app.dart';
import '../../../../../common/secure_repository.dart';
import '../../../../../common/session/session_repository.dart';
import '../../../../../common/storage_constants.dart';
import '../../../enities/common/wallet_entity.dart';
import '../../../enities/tbu/tbu_preview_request.dart';
import '../../../enities/common/common_preview_response.dart';
import '../../../enities/tbu/tbu_request.dart';
import '../../../enities/tbu/tbu_tfa_request.dart';
import '../../../enities/tbu_request/request_from_contact.dart';
import '../../../repository/transfers_repository.dart';
import '../contacts_list_flow.dart';

class SendByContactBloc {
  SendByContactBloc(
    this.transfersRepository,
    this._sessionRepository,
    this.flowType,
  ) {
    senderPhoneNumber = _sessionRepository.userData.value.phoneNumber;
  }

  final TransfersRepository transfersRepository;
  final SessionRepository _sessionRepository;
  ContactFlowType flowType;
  String senderPhoneNumber;
  bool tfaRequired;

  final senderWalletsListObservable = BehaviorSubject<List<WalletEntity>>();
  final transactionPreviewObservable = BehaviorSubject<CommonPreviewResponse>();

  List<WalletEntity> senderAccountsList = [];
  List<WalletEntity> _recipientAccountsList = [];
  WalletEntity selectedSenderAccount;
  WalletEntity recipientWallet;
  CommonPreviewResponse transactionPreview;
  String outgoingAmount;
  String description;
  String contactUID;

  void getWallets(String recipientUid) async {
    await getRecipientAccounts(recipientUid);
    await getSenderAccounts();
  }

  Future<void> getSenderAccounts() async {
    final uid =
        await SecureRepository().getFromStorage(StorageConstants.uidKey);
    await transfersRepository
        .getWallets(uid)
        .then((List<WalletEntity> senderAccounts) {
      senderAccountsList = senderAccounts;
      findRecipientWallet(senderAccountsList[0]);
      selectedSenderAccount = senderAccounts[0];
      senderWalletsListObservable.add(senderAccounts);
    });
  }

  Future<void> getRecipientAccounts(String uid) async {
    await transfersRepository
        .getWallets(uid)
        .then((List<WalletEntity> recipientAccounts) {
      if (recipientAccounts.isNotEmpty) {
        _recipientAccountsList = recipientAccounts;
      }
    });
  }

  // Check if the recipient has the same currency account
  void findRecipientWallet(WalletEntity account) async {
    logger.i(account.toString());
    selectedSenderAccount = account;
    recipientWallet = _recipientAccountsList.firstWhere(
        (WalletEntity recipientAccount) =>
            recipientAccount.type.currencyCode ==
            selectedSenderAccount.type.currencyCode,
        orElse: () => null);
    transactionPreviewObservable.add(null);
  }

  TbuPreviewRequest getTbuPreviewData(String amount) {
    outgoingAmount = amount;
    return TbuPreviewRequest(
      accountIdFrom: selectedSenderAccount?.id,
      accountNumberTo: recipientWallet?.number,
      outgoingAmount: outgoingAmount,
      userName: _sessionRepository.userData.value.username,
    );
  }

  TbuRequest getTbuData() {
    return TbuRequest(
      accountIdFrom: selectedSenderAccount.id,
      userName: _sessionRepository.userData.value.username,
      accountNumberTo: recipientWallet.number,
      outgoingAmount: outgoingAmount,
      description: description,
      incomingAmount: transactionPreview.incomingAmount,
      saveAsTemplate: true,
      templateName: 'test_template - ${DateTime.now().toIso8601String()}',
    );
  }

  Tbu2FARequest get2FARequestData() {
    return Tbu2FARequest(
      accountIdFrom: selectedSenderAccount.id,
      userName: _sessionRepository.userData.value.username,
      accountNumberTo: recipientWallet.number,
      outgoingAmount: outgoingAmount,
      saveAsTemplate: false,
    );
  }

  RequestFromContact getRequestFromContactData() {
    return RequestFromContact(
        amount: outgoingAmount,
        recipientAccountId: selectedSenderAccount.id,
        targetUID: contactUID,
        description: description);
  }

  void dispose() {
    senderWalletsListObservable.close();
    transactionPreviewObservable.close();
  }
}

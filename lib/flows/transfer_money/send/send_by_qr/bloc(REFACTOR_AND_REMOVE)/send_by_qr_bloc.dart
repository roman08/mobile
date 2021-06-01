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
import '../../../repository/transfers_repository.dart';

class SendByQrBloc {
  final TransfersRepository _transfersRepository;
  final SessionRepository _sessionRepository;

  SendByQrBloc(
    this._transfersRepository,
    this._sessionRepository,
  ) {
    senderPhoneNumber = _sessionRepository.userData.value.phoneNumber;
  }

  final senderWalletsListObservable = BehaviorSubject<List<WalletEntity>>();
  final transactionPreviewObservable = BehaviorSubject<CommonPreviewResponse>();

  List<WalletEntity> senderWalletsList = [];
  CommonPreviewResponse transactionPreview;

  WalletEntity recipientWallet;
  WalletEntity senderWallet;
  String recipient;
  String phoneNumber;
  String amount;
  String description;
  String senderPhoneNumber;
  bool tfaRequired;

  Future<void> getSenderWallets() async {
    final uid =
        await SecureRepository().getFromStorage(StorageConstants.uidKey);
    await _transfersRepository
        .getWallets(uid)
        .then((List<WalletEntity> senderAccountsList) {
      senderWalletsList = filterMatchedWallets(senderAccountsList);
      if (senderWalletsList.isNotEmpty) {
        senderWallet = senderWalletsList[0];
        senderWalletsListObservable.add(senderWalletsList);
      }
    });
  }

  // Return list of wallets that matched with recipient wallet account by currencyCode
  List<WalletEntity> filterMatchedWallets(List<WalletEntity> allSenderAccount) {
    final Iterable<WalletEntity> matchedAccounts = allSenderAccount.where(
        (WalletEntity senderAccount) =>
            senderAccount.type.currencyCode ==
            recipientWallet.type.currencyCode);
    return matchedAccounts.toList();
  }

  // Check if the recipient has the same currency account
  void setSenderWallet(WalletEntity account) async {
    logger.i(account.toString());
    senderWallet = account;
  }

  TbuPreviewRequest getTbuPreviewData(String amount) {
    this.amount = amount;
    return TbuPreviewRequest(
      accountIdFrom: senderWallet.id,
      accountNumberTo: recipientWallet.number,
      outgoingAmount: this.amount,
      userName: _sessionRepository.userData.value.username,
    );
  }

  TbuRequest getTbuData() {
    return TbuRequest(
      accountIdFrom: senderWallet.id,
      userName: _sessionRepository.userData.value.username,
      accountNumberTo: recipientWallet.number,
      outgoingAmount: amount,
      description: description,
      incomingAmount: transactionPreview.incomingAmount,
      saveAsTemplate: true,
      templateName: 'test_template - ${DateTime.now().toIso8601String()}',
    );
  }

  Tbu2FARequest get2FARequestData() {
    return Tbu2FARequest(
      accountIdFrom: senderWallet.id,
      userName: _sessionRepository.userData.value.username,
      accountNumberTo: recipientWallet.number,
      outgoingAmount: amount,
      saveAsTemplate: false,
    );
  }

  void dispose() {
    senderWalletsListObservable.close();
    transactionPreviewObservable.close();
  }
}

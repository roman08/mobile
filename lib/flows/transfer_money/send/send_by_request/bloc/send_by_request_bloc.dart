import 'package:rxdart/rxdart.dart';

import '../../../../../app.dart';
import '../../../../../common/secure_repository.dart';
import '../../../../../common/session/session_repository.dart';
import '../../../../../common/storage_constants.dart';
import '../../../enities/common/wallet_entity.dart';
import '../../../enities/common/common_preview_response.dart';
import '../../../enities/tbu_request/tbu_request_preview_request.dart';
import '../../../enities/tbu_request/tbu_request_request.dart';
import '../../../repository/transfers_repository.dart';

class SendByRequestBloc {
  final TransfersRepository _transfersRepository;
  final SessionRepository _sessionRepository;
  final SecureRepository _secureRepository = SecureRepository();

  SendByRequestBloc(
    this._transfersRepository,
    this._sessionRepository,
  ) {
    senderPhoneNumber = _sessionRepository.userData.value.phoneNumber;
  }

  final senderWalletsListObservable = BehaviorSubject<List<WalletEntity>>();
  final isTransactionSuccessObservable = BehaviorSubject<bool>();
  final transactionPreviewObservable = BehaviorSubject<CommonPreviewResponse>();

  List<WalletEntity> senderWalletsList = [];
  CommonPreviewResponse transactionPreview;

  WalletEntity senderWallet;
  String recipient;
  String phoneNumber;
  String amount;
  String description;

  int moneyRequestId;
  String currencyCode;
  bool tfaRequired;
  String senderPhoneNumber;

  Future<void> getSenderWallets() async {
    final uid = await _secureRepository.getFromStorage(StorageConstants.uidKey);
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
            senderAccount.type.currencyCode == currencyCode);
    return matchedAccounts.toList();
  }

  // Check if the recipient has the same currency account
  void setSenderWallet(WalletEntity account) async {
    logger.i(account.toString());
    senderWallet = account;
  }

  TbuRequestPreviewRequest getTbuRequestPreviewData(String amount) {
    this.amount = amount;
    return TbuRequestPreviewRequest(
      accountIdFrom: senderWallet.id,
      moneyRequestId: moneyRequestId,
    );
  }

  TbuRequestRequest getTbuData() {
    return TbuRequestRequest(
      accountIdFrom: senderWallet.id,
      moneyRequestId: moneyRequestId,
    );
  }

  void dispose() {
    senderWalletsListObservable.close();
    isTransactionSuccessObservable.close();
    transactionPreviewObservable.close();
  }
}

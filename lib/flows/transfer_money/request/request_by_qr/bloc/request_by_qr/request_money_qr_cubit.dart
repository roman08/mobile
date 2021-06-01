import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/secure_repository.dart';
import '../../../../../../common/session/session_repository.dart';
import '../../../../../../common/storage_constants.dart';
import '../../../../repository/transfers_repository.dart';
import '../../../../enities/common/wallet_entity.dart';
import '../../entity/transfer_qr_entity.dart';
import 'request_money_qr_state.dart';

class RequestByQrCubit extends Cubit<RequestMoneyState> {
  RequestByQrCubit(this._sessionRepository, this._sendMoneyRepository)
      : super(RequestMoneyInitState());

  final SessionRepository _sessionRepository;
  final TransfersRepository _sendMoneyRepository;

  List<WalletEntity> _wallets;

  void requestAccount() async {
    final uid =
        await SecureRepository().getFromStorage(StorageConstants.uidKey);
    _wallets = await _sendMoneyRepository.getWallets(uid);
    emit(AccountsState(_wallets));
  }

  void completedState(WalletEntity wallet, String amount, String description) {
    final username = _sessionRepository.userData.value.firstName;
    final phoneNumber = _sessionRepository.userData.value.phoneNumber;
    emit(
      CompletedState(
          TransferByQrEntity(
            username: username,
            phoneNumber: phoneNumber,
            amount: amount,
            description: description,
            wallet: wallet,
          ),
          _wallets),
    );
  }

  void inCompletedState() {
    emit(InCompletedState(_wallets));
  }
}

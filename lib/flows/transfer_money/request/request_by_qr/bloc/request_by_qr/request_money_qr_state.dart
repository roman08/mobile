import 'package:equatable/equatable.dart';

import '../../../../enities/common/wallet_entity.dart';
import '../../entity/transfer_qr_entity.dart';

abstract class RequestMoneyState extends Equatable {
    @override
    List<Object> get props => [];

    List<WalletEntity> get wallets;
}

class RequestMoneyInitState extends RequestMoneyState {

    @override
    final List<WalletEntity> wallets = [];
}

class AccountsState extends RequestMoneyState {
    @override
    final List<WalletEntity> wallets;

    AccountsState(this.wallets);

    @override
    List<Object> get props => [wallets];
}

class InCompletedState extends RequestMoneyState {
    @override
    final List<WalletEntity> wallets;

    InCompletedState(this.wallets);

    @override
    List<Object> get props => [wallets];
}

class CompletedState extends RequestMoneyState {
    @override
    final List<WalletEntity> wallets;

    final TransferByQrEntity recipientQREntity;

    CompletedState(this.recipientQREntity, this.wallets);

    @override
    List<Object> get props => [recipientQREntity, wallets];
}

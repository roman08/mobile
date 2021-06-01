import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../../enities/common/wallet_entity.dart';

class QRRequestFormState extends Equatable {
    const QRRequestFormState({
        @required this.isChecked,
        @required this.wallet,
        @required this.amount,
        @required this.description,
    });

    final bool isChecked;
    final WalletEntity wallet;
    final String amount;
    final String description;

    bool get isComplete => (isChecked && wallet != null && amount == null) || (!isChecked && wallet != null && amount != null);

    @override
    List<Object> get props => [isChecked, wallet, amount, description];

    factory QRRequestFormState.initial() =>
        const QRRequestFormState(
            isChecked: false,
            wallet: null,
            amount: null,
            description: "",
        );

    QRRequestFormState copyWithWallet({
        WalletEntity wallet
    }) {
        return QRRequestFormState(
            isChecked: this.isChecked,
            wallet: wallet ?? this.wallet,
            amount: this.amount,
            description: this.description,
        );
    }

    QRRequestFormState copyWithOpenRequest({
        bool isChecked
    }) {
        return QRRequestFormState(
            isChecked: isChecked ?? this.isChecked,
            wallet: wallet ?? this.wallet,
            amount: null,
            description: description ?? this.description,
        );
    }

    QRRequestFormState copyWithAmount({
        String amount
    }) {
        return QRRequestFormState(
            isChecked: this.isChecked,
            wallet: this.wallet,
            amount: amount,
            description: this.description,
        );
    }

    QRRequestFormState copyWithDescription({
        String description
    }) {
        return QRRequestFormState(
            isChecked: this.isChecked,
            wallet: this.wallet,
            amount: this.amount,
            description: description ?? this.description,
        );
    }
}

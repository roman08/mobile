import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../enities/common/wallet_entity.dart';
import 'qr_request_form_state.dart';

class QrRequestFormCubit extends Cubit<QRRequestFormState> {
  QrRequestFormCubit() : super(QRRequestFormState.initial());

  void chooseWallet(WalletEntity wallet) {
    emit(state.copyWithWallet(wallet: wallet));
  }

  void openRequest(bool isChecked) {
    emit(state.copyWithOpenRequest(isChecked: isChecked));
  }

  void changeAmount(String amount) {
    emit(state.copyWithAmount(amount: amount));
  }

  void changeDescription(String description) {
    emit(state.copyWithDescription(description: description));
  }
}

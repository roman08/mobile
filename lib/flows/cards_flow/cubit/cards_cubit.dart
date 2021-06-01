import 'package:Velmie/common/bloc/loader_bloc.dart';
import 'package:Velmie/flows/cards_flow/entities.dart';
import 'package:Velmie/flows/cards_flow/enums/card_status.dart';
import 'package:Velmie/flows/cards_flow/repositories/cards_repository.dart';
import 'package:Velmie/flows/kyc_flow/repository/kyc_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:network_utils/resource.dart';

part 'cards_state.dart';

class CardsCubit extends Cubit<CardsState> {
  final LoaderBloc _loaderBloc;
  final CardsRepository _cardsRepository;
  final KycRepository _kycRepository;

  CardsCubit({
    @required LoaderBloc loaderBloc,
    @required CardsRepository cardsRepository,
    @required KycRepository kycRepository,
  })  : assert(loaderBloc != null),
        assert(cardsRepository != null),
        assert(kycRepository != null),
        _loaderBloc = loaderBloc,
        _cardsRepository = cardsRepository,
        _kycRepository = kycRepository,
        super(const CardsState());

  void toggleTermsAndConditions() {
    emit(state.copyWith(termsAndConditionsAccepted: !state.termsAndConditionsAccepted));
  }

  void toggleCardFees() {
    emit(state.copyWith(cardFeesAccepted: !state.cardFeesAccepted));
  }

  void requestCard() async {
    _loaderBloc.add(LoaderEvent.buttonLoadEvent);

    await for (final resource in _cardsRepository.requestCard()) {
      if (resource.status == Status.success) {
        emit(state.copyWith(cardStatus: CardStatus.pending));
        _loaderBloc.add(LoaderEvent.stopButtonLoadEvent);
        return;
      } else if (resource.status == Status.error) {
        _loaderBloc.add(LoaderEvent.stopButtonLoadEvent);
        return;
      }
    }
  }

  void checkCardStatus() async {
    await for (final resource in _cardsRepository.checkCardStatus()) {
      if (resource.status == Status.success) {
        emit(state.copyWith(cardStatus: resource.data));
        return;
      } else if (resource.status == Status.error) {
        return;
      }
    }
  }

  void checkKycStatus() async {
    final status = await _kycRepository.checkKycStatus();
    emit(state.copyWith(kycDone: status));
  }

  void loadDocuments() async {
    await for (final resource in _cardsRepository.getDocuments()) {
      if (resource.status == Status.success) {
        emit(state.copyWith(documents: resource.data));
        return;
      } else if (resource.status == Status.error) {
        return;
      }
    }
  }
}

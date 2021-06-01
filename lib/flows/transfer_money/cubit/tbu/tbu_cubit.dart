import 'package:bloc/bloc.dart';
import 'package:network_utils/resource.dart';

import '../../../../app.dart';
import '../../enities/tbu/tbu_preview_request.dart';
import '../../enities/tbu/tbu_request.dart';
import '../../enities/tbu/tbu_tfa_request.dart';
import '../../enities/tbu_request/request_from_contact.dart';
import '../../repository/tbu_repository.dart';
import 'tbu_state.dart';

class TbuCubit extends Cubit<TbuState> {
  final TbuRepository _tbuRepository;
  TbuRequest tbuRequest;
  TbuPreviewRequest tbuPreviewRequest;
  RequestFromContact requestFromContactData;

  TbuCubit(this._tbuRepository) : super(TbuInitState());

  void truPreview() async {
    await for (final resource in _tbuRepository.tbuPreview(tbuPreviewRequest)) {
      if (resource.status == Status.success) {
        emit(TbuPreviewSuccessState(resource.data));
        return;
      } else if (resource.status == Status.loading) {
        emit(TbuPreviewLoadingState());
      } else {
        emit(TbuPreviewErrorState(resource.errors));
        return;
      }
    }
  }

  void tbu() async {
    await for (final resource in _tbuRepository.tbu(tbuRequest)) {
      if (resource.status == Status.success) {
        emit(TbuSuccessState());
        clearData();
        return;
      } else if (resource.status == Status.loading) {
        emit(TbuLoadingState());
      } else {
        logger.e(resource.errors.toString());
        emit(TbuErrorState(resource.errors));
        return;
      }
    }
  }

  void requestFromContact() async {
    await for (final resource
        in _tbuRepository.requestFromContact(requestFromContactData)) {
      if (resource.status == Status.success) {
        emit(RequestFromContactSuccessState());
        return;
      } else if (resource.status == Status.loading) {
        emit(RequestFromContactLoadingState());
      } else {
        emit(RequestFromContactErrorState(resource.errors));
        return;
      }
    }
  }

  void clearData() {
    tbuRequest = null;
    tbuPreviewRequest = null;
  }
}

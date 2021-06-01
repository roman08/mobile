import 'package:bloc/bloc.dart';
import 'package:network_utils/resource.dart';

import '../../enities/tbu_request/tbu_request_preview_request.dart';
import '../../enities/tbu_request/tbu_request_request.dart';
import '../../repository/tbu_request_repository.dart';
import 'tbu_request_state.dart';

class TbuRequestCubit extends Cubit<TbuRequestState> {
  final TbuRequestRepository _tbuRequestRepository;
  TbuRequestRequest tbuRequestData;
  TbuRequestPreviewRequest tbuRequestPreviewData;

  TbuRequestCubit(this._tbuRequestRepository) : super(TbuRequestInitState());

  void truRequestPreview() async {
    await for (final resource
        in _tbuRequestRepository.tbuRequestPreview(tbuRequestPreviewData)) {
      if (resource.status == Status.success) {
        emit(TbuRequestPreviewSuccessState(resource.data));
        return;
      } else if (resource.status == Status.loading) {
        emit(TbuRequestPreviewLoadingState());
      } else {
        emit(TbuRequestPreviewErrorState(resource.errors));
        return;
      }
    }
  }

  void tbuRequest() async {
    await for (final resource
        in _tbuRequestRepository.tbuRequest(tbuRequestData)) {
      if (resource.status == Status.success) {
        emit(TbuRequestSuccessState(resource.data));
        clearData();
        return;
      } else if (resource.status == Status.loading) {
        emit(TbuRequestLoadingState());
      } else {
        emit(TbuRequestErrorState(resource.errors));
        return;
      }
    }
  }

  void clearData() {
    tbuRequestData = null;
    tbuRequestPreviewData = null;
  }
}

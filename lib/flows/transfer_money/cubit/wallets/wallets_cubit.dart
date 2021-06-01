import 'package:bloc/bloc.dart';
import 'package:network_utils/resource.dart';

import '../../../dashboard_flow/repository/dashboard_repository.dart';
import 'wallets_state.dart';

class WalletsCubit extends Cubit<WalletsState> {
  final DashboardRepository _dashboardRepository;

  WalletsCubit(this._dashboardRepository) : super(WalletsInitialState());

  void getWallets() async {
    await for (final resource in _dashboardRepository.getWallets()) {
      if (resource.status == Status.success) {
        emit(WalletsSuccessLoadedState(resource.data));
        return;
      } else if (resource.status == Status.loading) {
        emit(WalletsLoadingState());
      } else {
        emit(WalletsErrorState(resource.errors));
        return;
      }
    }
  }
}

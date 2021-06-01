import 'dart:developer';

import 'package:Velmie/common/repository/user_repository.dart';
import 'package:network_utils/resource.dart';
import 'package:rxdart/rxdart.dart';

import '../../../app.dart';
import '../../../common/session/session_repository.dart';
import '../entities/wallet_list_wrapper.dart';
import '../repository/dashboard_repository.dart';

class DashboardBloc {
  final DashboardRepository _dashboardRepository;
  final SessionRepository _sessionRepository;
  final UserRepository _userRepository;
  final BehaviorSubject<List<Wallet>> walletListObservable = BehaviorSubject();
  final BehaviorSubject<List<Wallet>> iwtWalletListObservable = BehaviorSubject();
  final BehaviorSubject<String> nicknameObservable = BehaviorSubject();

  DashboardBloc(this._dashboardRepository, this._sessionRepository,
      this._userRepository) {
    _sessionRepository.userData.listen((userData) {
      nicknameObservable
          .add((userData.fullName.isNotEmpty) ? userData.fullName : "");
    });
  }

  Future<void> loadWallets() async {
    _dashboardRepository.loadWallets().then((List<Wallet> value) {
      walletListObservable.add(value);
    });
    _dashboardRepository.loadWallets(forIwt: true).then((List<Wallet> value) {
      log(value.toString());
      iwtWalletListObservable.add(value);
    });
  }

  void getUserData() {
    _userRepository.getUserData().listen((resource) {
      switch (resource.status) {
        case Status.success:
          logger.d(resource.data.toString());
          break;
        case Status.loading:
          break;
        case Status.error:
          logger.e(resource.errors.first?.message ?? "");
          break;
      }
    });
  }

  void dispose() {
    walletListObservable.close();
    iwtWalletListObservable.close();
    nicknameObservable.close();
  }
}

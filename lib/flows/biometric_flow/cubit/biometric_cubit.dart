import 'package:bloc/bloc.dart';
import 'package:local_auth/local_auth.dart';

import '../../../common/session/session_repository.dart';
import 'biometric_state.dart';

class BiometricCubit extends Cubit<BiometricState> {
  SessionRepository sessionRepository;

  BiometricCubit(this.sessionRepository) : super(BiometricInitial());

  void enabledEvent(BiometricType type) {
    sessionRepository.setBiometricType(type);
  }

  void biometricSkipEvent(bool isReject) {
    /// Stub
  }
}

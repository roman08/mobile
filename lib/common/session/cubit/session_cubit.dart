import 'package:Velmie/common/repository/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network_utils/resource.dart';

import '../session_repository.dart';
import 'session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  SessionCubit(this._sessionRepository)
      : super(_getInitState(_sessionRepository));

  final SessionRepository _sessionRepository;
  UserRepository userRepository;

  static SessionState _getInitState(SessionRepository sessionRepository) {
    if (sessionRepository.isValidSession) {
      if (sessionRepository.biometricType == null) {
        return PinVerificationSessionState();
      } else {
        return BioVerificationSessionState();
      }
    } else {
      if (sessionRepository.isValidRefreshToken) {
        return SignInPassCodeSessionState();
      } else {
        return LogOutSessionState();
      }
    }
  }

  void sessionCreatingPassCodeEvent({bool isSignIn}) {
    emit(SignInPassCodeSessionState());
  }

  void sessionVerificationEvent() {
    if (_sessionRepository.biometricType == null) {
      emit(PinVerificationSessionState());
    } else {
      emit(BioVerificationSessionState());
    }
  }

  void sessionVerificationSuccessEvent() {
    emit(SuccessSessionState());
  }

  void logout() async {
    await for (final event in userRepository.logOut()) {
      if (event.status == Status.success || event.status == Status.error) {
        _sessionRepository.destroySession();
        emit(LogOutSessionState());
        return;
      }
    }
  }
}

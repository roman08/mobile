import 'package:equatable/equatable.dart';

abstract class SessionState extends Equatable {
  const SessionState();

  @override
  List<Object> get props => [];
}

class SignInPassCodeSessionState extends SessionState {}

class SignUpPassCodeSessionState extends SessionState {}

class LogOutSessionState extends SessionState {}

class PinVerificationSessionState extends SessionState {}

class BioVerificationSessionState extends SessionState {}

class SuccessSessionState extends SessionState {}

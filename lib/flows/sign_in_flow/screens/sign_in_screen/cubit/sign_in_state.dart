part of 'sign_in_cubit.dart';

class SignInState extends Equatable {
  const SignInState({
    this.login = const LoginInput.pure(),
    this.password = const PasswordInput.pure(),
    this.status = FormzStatus.pure,
    this.backendErrors = const SignInErrors(),
  });

  final LoginInput login;
  final PasswordInput password;
  final FormzStatus status;
  final SignInErrors backendErrors;

  @override
  List<Object> get props => [
        login,
        password,
        status,
        backendErrors,
      ];

  SignInState copyWith({
    LoginInput login,
    PasswordInput password,
    FormzStatus status,
    SignInErrors backendErrors,
  }) {
    return SignInState(
      login: login ?? this.login,
      password: password ?? this.password,
      status: status ?? this.status,
      backendErrors: backendErrors ?? this.backendErrors,
    );
  }

  @override
  String toString() {
    return 'SignInState{login: $login, password: $password, status: $status, backendErrors: $backendErrors}';
  }
}

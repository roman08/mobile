part of 'password_field_cubit.dart';

@immutable
class PasswordFieldState extends Equatable {
  const PasswordFieldState({this.obscurePassword = true});

  final bool obscurePassword;

  @override
  List<Object> get props => [obscurePassword];

  PasswordFieldState copyWith({bool obscurePassword}) {
    return PasswordFieldState(
      obscurePassword: obscurePassword ?? this.obscurePassword,
    );
  }
}

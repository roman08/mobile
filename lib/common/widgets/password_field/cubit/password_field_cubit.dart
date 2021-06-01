import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'password_field_state.dart';

class PasswordFieldCubit extends Cubit<PasswordFieldState> {
  PasswordFieldCubit() : super(const PasswordFieldState());

  void changePasswordVisibility() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }
}

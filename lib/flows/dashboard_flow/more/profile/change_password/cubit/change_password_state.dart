import 'package:equatable/equatable.dart';

class ChangePasswordState extends Equatable {
    const ChangePasswordState({this.isOldVisible = false, this.isNewVisible = false, this.isConfirmVisible = false});

    final bool isOldVisible;
    final bool isNewVisible;
    final bool isConfirmVisible;

    @override
    List<Object> get props => [isOldVisible, isNewVisible, isConfirmVisible];
}

class ChangePasswordInitState extends ChangePasswordState {}

class ChangePasswordOldErrorState extends ChangePasswordState {
    const ChangePasswordOldErrorState({this.error});

    final String error;

    @override
    List<Object> get props => [error];
}

class ChangePasswordNewErrorState extends ChangePasswordState {
    const ChangePasswordNewErrorState({this.error});

    final String error;

    @override
    List<Object> get props => [error];
}

class ChangePasswordConfirmErrorState extends ChangePasswordState {
    const ChangePasswordConfirmErrorState({this.error});

    final String error;

    @override
    List<Object> get props => [error];
}

class ChangePasswordErrorState extends ChangePasswordState {
    const ChangePasswordErrorState({this.error});

    final String error;

    @override
    List<Object> get props => [error];
}

class ChangePasswordChangedState extends ChangePasswordState {}

class ChangePasswordLoadingState extends ChangePasswordState {}

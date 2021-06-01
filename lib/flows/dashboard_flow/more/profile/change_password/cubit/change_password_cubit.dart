import 'package:Velmie/common/repository/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network_utils/resource.dart';

import '../../../../../../app.dart';
import '../../../../../../common/utils/validator.dart';
import '../../../../../../resources/strings/app_strings.dart';
import 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit(this.validator, this._userRepository)
      : super(ChangePasswordInitState());

  final Validator validator;

  final UserRepository _userRepository;

  void changePasswordEvent(
      {String oldPassword, String newPassword, String confirmPassword}) {
    _update(
      oldPassword,
      newPassword,
      confirmPassword,
    );
  }

  void changePasswordOldVisibilityEvent({bool isVisible}) {
    emit(ChangePasswordState(
      isOldVisible: isVisible,
      isNewVisible: state.isNewVisible,
      isConfirmVisible: state.isConfirmVisible,
    ));
  }

  void changePasswordNewVisibilityEvent({bool isVisible}) {
    emit(ChangePasswordState(
      isOldVisible: state.isOldVisible,
      isNewVisible: isVisible,
      isConfirmVisible: state.isConfirmVisible,
    ));
  }

  void changePasswordConfirmVisibilityEvent({bool isVisible}) {
    emit(ChangePasswordState(
      isOldVisible: state.isOldVisible,
      isNewVisible: state.isNewVisible,
      isConfirmVisible: isVisible,
    ));
  }

  void _update(
    String old,
    String newPassword,
    String confirm,
  ) async {
    String oldError;
    if (old.isEmpty) {
      oldError = ErrorStrings.FIELD_IS_REQUIRED;
    } else if (old.length < 8) {
      oldError = ErrorStrings.SHOULD_BE_MINIMUM_EIGHT_CHARACTERS;
    } else if (!validator.isValidPassword(old)) {
      oldError = ErrorStrings.PASSWORD_REQUIREMENTS;
    }
    if (oldError != null) {
      emit(ChangePasswordOldErrorState(error: oldError));
    }

    String newError;
    if (newPassword.isEmpty) {
      newError = ErrorStrings.FIELD_IS_REQUIRED;
    } else if (newPassword.length < 8) {
      newError = ErrorStrings.SHOULD_BE_MINIMUM_EIGHT_CHARACTERS;
      emit(const ChangePasswordNewErrorState(
          error: ErrorStrings.SHOULD_BE_MINIMUM_EIGHT_CHARACTERS));
    } else if (!validator.isValidPassword(newPassword)) {
      newError = ErrorStrings.PASSWORD_REQUIREMENTS;
    }
    if (newError != null) {
      emit(ChangePasswordNewErrorState(error: newError));
    }

    String confirmError;
    if (confirm.isEmpty) {
      confirmError = ErrorStrings.FIELD_IS_REQUIRED;
    } else if (newPassword != confirm) {
      confirmError = ErrorStrings.PASSWORD_MISMATCH;
    }
    if (confirmError != null) {
      emit(ChangePasswordConfirmErrorState(error: confirmError));
    }

    if (oldError == null && newError == null && confirmError == null) {
      await for (final event in _userRepository.resetPassword(
          previousPassword: old,
          proposedPassword: newPassword,
          confirmPassword: confirm)) {
        logger.d(event);
        if (event.status == Status.success) {
          emit(ChangePasswordChangedState());
          return;
        } else if (event.status == Status.loading) {
          emit(ChangePasswordLoadingState());
        } else {
          //TODO add error handler
          emit(ChangePasswordErrorState(
              error: event.errors?.first?.message ?? event.errorMessage));
          return;
        }
      }
    }
  }
}

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/session/session_repository.dart';
import 'pin_code_state.dart';

class PinCodeCubit extends Cubit<PinCodeState> {
  PinCodeCubit(this._sessionRepository) : super(PinCodeInitState());

  final SessionRepository _sessionRepository;
  String _pinCode = "";
  String _repeatPinCode = "";
  bool _isConfirm;
  int failedAttempts = 0;

  void pinCodeInitEvent() => emit(PinCodeInitState());

  void pinCodeResetEvent() {
    _reset();
    emit(PinCodeInitState(isRepeat: _isConfirm));
  }

  void addNumber(String number) {
    if (_isConfirm == true) {
      _repeatPinCode += number;
      emit(PinCodeChangedState(_repeatPinCode.length, isRepeat: _isConfirm));
    } else {
      _pinCode += number;
      emit(PinCodeChangedState(_pinCode.length, isRepeat: _isConfirm));
    }
  }

  void deleteNumber() {
    if (_isConfirm == true) {
      _repeatPinCode = _repeatPinCode.substring(0, _repeatPinCode.length - 1);
      emit(PinCodeChangedState(_repeatPinCode.length, isRepeat: _isConfirm));
    } else {
      _pinCode = _pinCode.substring(0, _pinCode.length - 1);
      emit(PinCodeChangedState(_pinCode.length));
    }
  }

  void pinCodeNextStepEvent() async {
    _isConfirm = true;
    await Future.delayed(const Duration(milliseconds: 300));
    emit(PinCodeInitState(isRepeat: _isConfirm));
  }

  void comparePin() async {
    if (_isConfirm == true) {
      final isEqual = _pinCode == _repeatPinCode;
      if (isEqual) {
        _sessionRepository.savePassCode(_pinCode);
      } else {
        failedAttempts++;
      }
      await Future.delayed(const Duration(milliseconds: 300));
      emit(PinCodeResultState(isEqual, failedAttempts, isRepeat: _isConfirm));
    } else {
      final isEqual = _sessionRepository.equalPassCode(_pinCode);
      if (!isEqual) {
        failedAttempts++;
      }
      await Future.delayed(const Duration(milliseconds: 300));
      emit(PinCodeResultState(isEqual, failedAttempts, isRepeat: _isConfirm));
    }
  }

  void compareAfterChangedPin() {
    final isEqual = _pinCode == _repeatPinCode;
    if (isEqual) {
      _sessionRepository.savePassCode(_pinCode);
    }
    emit(PinCodeResultState(isEqual, failedAttempts, isRepeat: _isConfirm));
  }

  void compareOldPin() async {
    final isEqual = _sessionRepository.equalPassCode(_pinCode);
    if (isEqual) {
      emit(PinCodeResultState(isEqual, failedAttempts,
          isRepeat: _isConfirm, isFinish: false));
      _reset();
      _isConfirm = false;
      await Future.delayed(const Duration(milliseconds: 700));
      emit(PinCodeInitState(isRepeat: false));
    } else {
      emit(PinCodeResultState(isEqual, failedAttempts, isRepeat: _isConfirm));
    }
  }

  void _reset() {
    _pinCode = "";
    _repeatPinCode = "";
    _isConfirm = null;
  }
}

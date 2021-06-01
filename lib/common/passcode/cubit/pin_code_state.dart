import 'package:equatable/equatable.dart';

abstract class PinCodeState extends Equatable {
  int get length;

  bool get isRepeat;

  @override
  List<Object> get props => [length, isRepeat];
}

class PinCodeInitState extends PinCodeState {
  PinCodeInitState({this.isRepeat});

  @override
  int get length => 0;

  @override
  final bool isRepeat;
}

class PinCodeChangedState extends PinCodeState {
  PinCodeChangedState(this.length, {this.isRepeat});

  @override
  final int length;

  @override
  final bool isRepeat;
}

class PinCodeResultState extends PinCodeState {
  PinCodeResultState(
    this.isSuccess,
    this.failedAttempts, {
    this.isRepeat,
    this.isFinish = true,
  });

  final bool isSuccess;
  final int failedAttempts;
  final bool isFinish;

  @override
  final bool isRepeat;

  @override
  int get length => 6;

  @override
  List<Object> get props =>
      [length, isRepeat, isSuccess, failedAttempts, isFinish];
}

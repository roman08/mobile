import 'package:equatable/equatable.dart';

abstract class BiometricState extends Equatable {
  const BiometricState();

  @override
  List<Object> get props => [];
}

class BiometricInitial extends BiometricState {}

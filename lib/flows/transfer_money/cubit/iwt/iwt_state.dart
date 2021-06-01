part of 'iwt_cubit.dart';

abstract class IwtState {}

class IwtInitial extends IwtState {}

class IwtLoadingState extends IwtState {}

class IwtInstructionsLoadingState extends IwtState {}

class IwtInstructionsLoadedState extends IwtState {}

class IwtFileSaving extends IwtState {}

class IwtFileSaved extends IwtState {
  final String fileName;

  IwtFileSaved({this.fileName});
}

class IwtFileSaveError extends IwtState {}

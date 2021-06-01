part of 'owt_cubit.dart';

@immutable
abstract class OwtState {}

class OwtInitial extends OwtState {}

/// Countries
class OwtCurrenciesLoaded extends OwtState {}

class OwtCountriesLoaded extends OwtState {}

class OwtCountriesAndCurrenciesLoading extends OwtState {}

class OwtCountriesAndCurrenciesLoaded extends OwtState {}

/// OWT preview
class OwtPreviewLoading extends OwtState {}

class OwtPreviewLoaded extends OwtState {
  final OwtPreviewResponse preview;

  OwtPreviewLoaded(this.preview);
}

class OwtPreviewFailed extends OwtState {
  final List<ParserMessageEntity> errors;

  OwtPreviewFailed(this.errors);
}

/// OWT
class OwtRequestPerforming extends OwtState {}

class OwtRequestPerformed extends OwtState {
  final int requestId;

  OwtRequestPerformed(this.requestId);
}

class OwtRequestFailed extends OwtState {
  final List<ParserMessageEntity> errors;

  OwtRequestFailed(this.errors);
}
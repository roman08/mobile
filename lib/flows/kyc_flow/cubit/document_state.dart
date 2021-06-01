part of 'document_cubit.dart';

@immutable
abstract class DocumentState {}

class DocumentInitial extends DocumentState {}

class DocumentLoaded extends DocumentState {
  final Uint8List data;

  DocumentLoaded(this.data);
}

import 'dart:typed_data';

import 'package:Velmie/flows/kyc_flow/repository/kyc_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'document_state.dart';

class DocumentCubit extends Cubit<DocumentState> {
  final KycRepository _kycRepository;

  DocumentCubit({@required KycRepository kycRepository})
      : _kycRepository = kycRepository,
        super(DocumentInitial());

  void loadDocument(String id) async {
    final file = await _kycRepository.getDocument(id: id);
    emit(DocumentLoaded(file));
  }
}

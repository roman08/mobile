import 'dart:typed_data';

import 'package:Velmie/flows/kyc_flow/models/tiers_result.dart';
import 'package:Velmie/flows/kyc_flow/repository/kyc_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:network_utils/resource.dart';

part 'terms_and_conditions_state.dart';

const TERMS_SIGNATURE_AT_LEVEL = 1;
const DOCUMENT_REQUIREMENT_ID = 74;

class TermsAndConditionsCubit extends Cubit<TermsAndConditionsState> {
  final KycRepository _kycRepository;

  TermsAndConditionsCubit({
    @required KycRepository kycRepository,
  })  : assert(kycRepository != null),
        _kycRepository = kycRepository,
        super(TermsAndConditionsState());

  void init() async {
    final documentId = await getSignedDocumentIdFromKyc();
    requestTermsAndConditionsDocument(documentId: documentId);
  }

  // ignore: missing_return
  Future<String> getSignedDocumentIdFromKyc() async {
    await for (final event in _kycRepository.getTiers()) {
      if (event.status == Status.loading) {
        emit(state.copyWith(status: TermsAndConditionsStatus.loading));
      } else if (event.status == Status.success) {
        emit(state.copyWith(status: TermsAndConditionsStatus.success));
        return extractDocumentIdFromTiers(event.data);
      } else if (event.status == Status.error) {
        emit(state.copyWith(status: TermsAndConditionsStatus.error));
        return null;
      }
    }
  }

  void requestTermsAndConditionsDocument({String documentId}) async {
    await for (final resource in _kycRepository.getTermsAndConditionsDoc(documentId: documentId)) {
      if (resource.status == Status.loading) {
        emit(state.copyWith(status: TermsAndConditionsStatus.loading));
      }
      if (resource.status == Status.success) {
        emit(state.copyWith(
          termsAndConditionsDocument: resource.data,
          status: TermsAndConditionsStatus.success,
        ));
        return;
      }
      if (resource.status == Status.error) {
        emit(state.copyWith(status: TermsAndConditionsStatus.error));
        return;
      }
    }
  }

  String extractDocumentIdFromTiers(List<Tier> tiers) {
    final tierWithDoc = tiers.firstWhere((Tier t) => t.level == TERMS_SIGNATURE_AT_LEVEL, orElse: () => null);
    if (tierWithDoc == null) {
      return null;
    }

    final documentRequirementObject = tierWithDoc.requirements.firstWhere(
      (Requirement r) => r.id == DOCUMENT_REQUIREMENT_ID,
      orElse: () => null,
    );
    if (documentRequirementObject == null) {
      return null;
    }

    final documentId = documentRequirementObject.elements[0]?.value;
    return documentId != null && documentId.isNotEmpty ? documentId : null;
  }
}

import 'package:Velmie/flows/kyc_flow/models/affidavit.dart';
import 'package:Velmie/flows/kyc_flow/models/requirement_request.dart';
import 'package:Velmie/flows/kyc_flow/models/tiers_result.dart';
import 'package:Velmie/flows/kyc_flow/repository/kyc_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:network_utils/resource.dart';

part 'affidavit_state.dart';

const AFFIDAVIT_REQUIREMENT_ID = 77;

class AffidavitCubit extends Cubit<AffidavitState> {
  final KycRepository _kycRepository;

  AffidavitCubit(
    KycRepository kycRepository, {
    Affidavit affidavit,
  })  : assert(kycRepository != null),
        _kycRepository = kycRepository,
        super(AffidavitState(affidavit: affidavit));

  void fundSourcesChanged(List<dynamic> fundSources) {
    emit(state.copyWith(fundSources: fundSources));
  }

  void updateAffidavit(Affidavit affidavit) {
    final requirement = RequirementRequest(id: AFFIDAVIT_REQUIREMENT_ID, values: [
      ElementValue(index: ElementIndex.fullName, value: affidavit.fullName),
      ElementValue(index: ElementIndex.fundsTypes, value: affidavit.fundTypes),
      ElementValue(index: ElementIndex.comment, value: affidavit.comment),
      ElementValue(index: ElementIndex.address, value: affidavit.address),
      ElementValue(index: ElementIndex.curp, value: affidavit.curp),
      ElementValue(index: ElementIndex.nationality, value: affidavit.nationality),
      ElementValue(index: ElementIndex.taxId, value: affidavit.taxId),
      ElementValue(index: ElementIndex.date, value: affidavit.date),
      ElementValue(index: ElementIndex.place, value: affidavit.place),
    ]);

    _kycRepository.updateRequirement(id: AFFIDAVIT_REQUIREMENT_ID, requirement: requirement).listen((event) {
      if (event.status == Status.loading) {
        emit(state.copyWith(status: AffidavitStatus.saving));
      } else if (event.status == Status.success) {
        emit(state.copyWith(status: AffidavitStatus.success));
        return;
      } else if (event.status == Status.error) {
        emit(state.copyWith(status: AffidavitStatus.error));
        return;
      }
    });
  }
}

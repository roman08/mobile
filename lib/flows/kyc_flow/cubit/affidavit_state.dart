part of 'affidavit_cubit.dart';

enum AffidavitStatus { pending, saving, success, error }
const OTHER_FUND_SOURCES_KEY = 'others';

class AffidavitState {
  final Affidavit affidavit;
  final AffidavitStatus status;
  final List<dynamic> fundSources;

  bool get fundSourcesEnumerationRequired => fundSources != null && fundSources.contains(OTHER_FUND_SOURCES_KEY);

  AffidavitState({
    @required this.affidavit,
    this.status = AffidavitStatus.pending,
    this.fundSources,
  });

  AffidavitState copyWith({
    Affidavit affidavit,
    AffidavitStatus status,
    List<dynamic> fundSources,
  }) {
    return AffidavitState(
      affidavit: affidavit ?? this.affidavit,
      status: status ?? this.status,
      fundSources: fundSources ?? this.fundSources,
    );
  }
}

import 'package:Velmie/common/bloc/loader_bloc.dart';
import 'package:Velmie/common/repository/countries_repository.dart';
import 'package:Velmie/common/repository/user_repository.dart';
import 'package:Velmie/flows/sign_in_flow/entities/user.dart';
import 'package:Velmie/flows/transfer_money/enities/common/country_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:network_utils/resource.dart';
import 'package:rxdart/rxdart.dart';

import '../models/current_tier_result.dart';
import '../models/requirement_request.dart';
import '../models/tiers_result.dart';
import '../repository/kyc_repository.dart';
import 'kyc_state.dart';
import '../../../app.dart';

class KycCubit extends Cubit<KycState> {
  final KycRepository kycRepository;
  final UserRepository userRepository;
  final CountriesRepository countriesRepository;
  final LoaderBloc loaderBloc;

  KycCubit({
    this.kycRepository,
    this.userRepository,
    this.countriesRepository,
    this.loaderBloc,
  }) : super(KycInitial());

  void fetch({ProfileStatus status}) {
    emit(LoadingState());

    Rx.zip4(kycRepository.getCurrentTier(), kycRepository.getTiers(), userRepository.getUserData(),
        countriesRepository.getCountries(), (
      Resource<CurrentTier, String> a,
      Resource<List<Tier>, String> b,
      Resource<UserData, String> userData,
      Resource<List<CountryEntity>, String> countries,
    ) {
      _updateData(
        currentTier: a.data,
        tiers: b.data,
        userData: userData.data,
        countries: countries.data,
        status: status,
      );
    }).listen((e) {});
  }

  void getTier({int id}) {
    emit(LoadingState());

    Rx.combineLatest3(
        kycRepository.getTier(id: id),
        kycRepository.getCurrentTier(),
        kycRepository.getTiers(),
        (
          Resource<Tier, String> a,
          Resource<CurrentTier, String> b,
          Resource<List<Tier>, String> c,
        ) =>
            _updateData(
              tier: a.data,
              currentTier: b.data,
              tiers: c.data,
            )).listen((e) {});
  }

  void updateRequirement({int id, RequirementRequest requirement}) async {

    loaderBloc.add(LoaderEvent.buttonLoadEvent);
    kycRepository.updateRequirement(id: requirement.id, requirement: requirement).take(2).listen((event) {
      if (event.status == Status.success) {
        loaderBloc.add(LoaderEvent.stopButtonLoadEvent);
        fetch();
        return;
      }
      if (event.status == Status.error) {
        loaderBloc.add(LoaderEvent.stopButtonLoadEvent);
        return;
      }
    });
  }

  void updateRequirements({List<RequirementRequest> requirements}) async {
    final tierId = (state as SuccessState).tiers.last.id;
    emit(LoadingState());

    await for (final _ in Rx.zipList(
      requirements.map((element) => kycRepository.updateRequirement(id: element.id, requirement: element)).toList(),
    ).take(requirements.length)) {
      sendRequest(id: tierId);
      fetch(status: ProfileStatus.updated);
      break;
    }
  }

  void _updateData({
    CurrentTier currentTier,
    List<Tier> tiers,
    Tier tier,
    UserData userData,
    List<CountryEntity> countries,
    ProfileStatus status = ProfileStatus.pending,
  }) {
    logger.d('TEST DIER: -> ROMAN');
    print(tier);
    if (tiers == null || currentTier == null || userData == null || countries == null) {
      return;
    }

    emit(SuccessState(
      tiers: tiers ?? [],
      tier: tier,
      currentTier: currentTier,
      userData: userData,
      countries: countries ?? [],
      status: status,
    ));
  }

  void sendRequest({int id}) {
    emit(LoadingState());

    kycRepository.sendRequest(id: id).listen((_) {});
  }

  void sendPhoneCode() {
    kycRepository.generateNewPhoneCode().listen((event) {});
  }

  void sendEmailCode() {
    kycRepository.generateNewEmailCode().listen((event) {});
  }

  void checkEmailCode({String code}) {
    final tierId = (this.state as SuccessState).tier.id;

    emit(LoadingState());

    kycRepository.checkEmailCode(code: code).listen((event) {
      if (event.status == Status.success) {
        emit(VerifiedState());
      } else if (event.status == Status.error) {
        emit(FailState());
      }

      getTier(id: tierId);
    });
  }

  void checkPhoneCode({String code}) {
    final tierId = (this.state as SuccessState).tier.id;
    emit(LoadingState());
    kycRepository.checkPhoneCode(code: code).listen((event) {
      if (event.status == Status.success) {
        emit(VerifiedState());
      } else if (event.status == Status.error) {
        emit(FailState());
      }

      getTier(id: tierId);
    });
  }
}

import 'package:Velmie/flows/sign_in_flow/entities/user.dart';
import 'package:Velmie/flows/transfer_money/enities/common/country_entity.dart';
import 'package:equatable/equatable.dart';

import '../models/current_tier_result.dart';
import '../models/tiers_result.dart';

enum ProfileStatus { pending, updated }

abstract class KycState extends Equatable {
  const KycState();
}

class KycInitial extends KycState {
  @override
  List<Object> get props => [];
}

class LoadingState extends KycState {
  @override
  List<Object> get props => [];
}

class VerifiedState extends KycState {
  @override
  List<Object> get props => [];
}

class SuccessState extends KycState {
  final CurrentTier currentTier;
  final List<Tier> tiers;
  final Tier tier;
  final UserData userData;
  final List<CountryEntity> countries;
  final ProfileStatus status;

  const SuccessState({
    this.tiers,
    this.currentTier,
    this.tier,
    this.userData,
    this.countries,
    this.status = ProfileStatus.pending,
  });

  @override
  List<Object> get props => [
        currentTier,
        tiers,
        tier,
        userData,
        countries,
        status,
      ];
}

class FailState extends KycState {
  @override
  List<Object> get props => [];
}

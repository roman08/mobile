import 'package:Velmie/common/bloc/loader_bloc.dart';
import 'package:Velmie/common/repository/countries_repository.dart';
import 'package:Velmie/common/repository/user_repository.dart';
import 'package:Velmie/flows/kyc_flow/screens/customer_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/kyc_cubit.dart';
import 'repository/kyc_repository.dart';

class KycFlow extends StatefulWidget {
  static const String ROUTE = '/kyc';

  const KycFlow({Key key}) : super(key: key);

  @override
  _KycFlowState createState() => _KycFlowState();
}

class _KycFlowState extends State<KycFlow> {
  KycCubit _cubit;

  @override
  void initState() {
    super.initState();

    _cubit = KycCubit(
      kycRepository: context.read<KycRepository>(),
      userRepository: context.read<UserRepository>(),
      countriesRepository: context.read<CountriesRepository>(),
      loaderBloc: context.read<LoaderBloc>(),
    )..fetch();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubit,
      child: const CustomerProfileScreen(),
    );
  }
}

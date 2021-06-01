import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app.dart';
import '../../destination_view.dart';

class BottomNavigationState extends Equatable {
  const BottomNavigationState(
    this.index,
    this.navigation,
  );

  final int index;
  final Navigation navigation;

  @override
  List<Object> get props => [index, navigation];
}

class BottomNavigationCubit extends Cubit<BottomNavigationState> {
  BottomNavigationCubit()
      : super(const BottomNavigationState(0, Navigation.overview));

  void navigateTo(Navigation navigateTo) {
    logger.d(navigateTo);
    emit(BottomNavigationState(
      Navigation.values.indexOf(navigateTo),
      navigateTo,
    ));
  }
}

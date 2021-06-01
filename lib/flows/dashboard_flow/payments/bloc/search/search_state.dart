import 'package:equatable/equatable.dart';

import '../../entity/title_serchable.dart';

abstract class SearchState extends Equatable {
  List<TitleSearchable> get list;

  @override
  List<Object> get props => [list];
}

class SearchInitState extends SearchState {
  SearchInitState(this.list);

  @override
  final List<TitleSearchable> list;
}

class SearchFilteredState extends SearchState {
  SearchFilteredState(this.list);

  @override
  final List<TitleSearchable> list;
}

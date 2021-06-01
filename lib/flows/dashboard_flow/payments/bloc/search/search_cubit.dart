import 'package:flutter_bloc/flutter_bloc.dart';

import '../../entity/title_serchable.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit(this._categories) : super(SearchInitState(_categories));

  final List<TitleSearchable> _categories;

  void filterList(String query) {
    emit(SearchFilteredState(_categories
        .where((element) =>
            element.title.toLowerCase().contains(query.toLowerCase()))
        .toList()));
  }
}

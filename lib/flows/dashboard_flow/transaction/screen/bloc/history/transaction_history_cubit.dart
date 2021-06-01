import 'package:api_error_parser/api_error_parser.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:network_utils/resource.dart';

import '../../../../../../app.dart';
import '../../../../entities/transaction/request_entity.dart';
import '../../../../entities/transaction/request_enum.dart';
import '../../../../repository/dashboard_repository.dart';
import 'transaction_history_state.dart';

class TransactionHistoryCubit extends Cubit<TransactionHistoryState> {
  TransactionHistoryCubit(this._dashboardRepository) : super(TransactionHistoryInitState()) {
    _to = DateTime.now();
    _from = DateTime(_to.year, _to.month - 1, _to.day);
  }

  final DashboardRepository _dashboardRepository;
  DateTime _from;
  DateTime _to;
  RequestCategory _category;
  RequestOperation _operation;
  String _query;
  Pagination _pagination;
  final Map<DateTime, List<RequestEntity>> _map = {};

  DateTime get from => _from;

  DateTime get to => _to;

  RequestCategory get category => _category;

  void updateDateEvent({DateTime from, DateTime to}) {
    _clearCache();
    _updateDate(from, to);
    getRequests(true);
  }

  void updateCategoryEvent(RequestCategory category) {
    _category = category;
    _clearCache();
    getRequests(true);
  }

  void updateOperationEvent(RequestOperation operation) {
    if (operation == RequestOperation.all) {
      _operation = null;
    } else {
      _operation = operation;
    }
    _category = null;
    _clearCache();
    getRequests(true);
  }

  void searchRequestDataEvent(String query) {
    _query = query;
    _clearCache();
    getRequests(true);
  }

  void requestDataEvent() {
    getRequests(false);
  }

  void refreshDataEvent() {
    _clearCache();
    getRequests(true);
  }

  void _clearCache() {
    _pagination = null;
    _map.clear();
  }

  void _updateDate(DateTime from, DateTime to) {
    _from = from;
    _to = to;
  }

  void getRequests(bool isRefreshing) async {
    final int nextPage = (_pagination?.currentPage ?? 0) + 1;
    if (_pagination != null && nextPage >= _pagination?.totalPage) {
      emit(TransactionHistoryList(_generateDataList()));
    }
    await for (final event in _dashboardRepository.getRequests(
      from: _from,
      to: DateTime(_to.year, _to.month, _to.day, 23, 59),
      category: _category,
      page: nextPage,
      query: _query,
      operation: _operation,
    )) {
      logger.d(event);
      if (event.status == Status.success) {
        if (_pagination?.currentPage == event.pagination.currentPage) {
          return;
        }

        _pagination = event.pagination;

        final responseMap = groupBy<RequestEntity, DateTime>(
          event.data,
          (element) => DateTime.parse(DateFormat("yMMdd", 'en').format(element.createdAt)),
        );
        responseMap.keys.forEach((key) {
          if (_map.containsKey(key)) {
            final oldList = _map[key];
            oldList.addAll(responseMap[key]);
          } else {
            _map.putIfAbsent(key, () => responseMap[key]);
          }
        });
        if (_map.keys.isNotEmpty) {
          if (_map.keys.last.month < DateTime.now().month) {
            _from = _map.keys.last;
          }
        }

        emit(TransactionHistoryList(_generateDataList()));
        return;
      } else if (event.status == Status.loading) {
        if (isRefreshing) {
          emit(TransactionHistoryRefreshingState());
        } else {
          emit(TransactionHistoryLoadingState());
        }
      } else {
        emit(TransactionHistoryErrorState(event.errors?.first?.message ?? ""));
        return;
      }
    }
  }

  List<dynamic> _generateDataList() {
    final keys = _map.keys.toList();
    final dataList = <dynamic>[];
    keys.forEach((key) {
      dataList.add(key);
      dataList.addAll(_map[key]);
    });
    return dataList;
  }
}

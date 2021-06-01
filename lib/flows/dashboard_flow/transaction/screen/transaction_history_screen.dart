import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../app.dart';
import '../../../../common/utils/date_formatter.dart';
import '../../../../common/widgets/loader/loading_footer.dart';
import '../../../../common/widgets/loader/loading_header.dart';
import '../../../../common/widgets/shimmering_effect/list_shimmering.dart';
import '../../../../common/widgets/tabbed_app_bar.dart';
import '../../../../resources/colors/custom_color_scheme.dart';
import '../../../../resources/icons/icons_svg.dart';
import '../../../../resources/strings/app_strings.dart';
import '../../../../resources/themes/app_text_theme.dart';
import '../../../../resources/themes/need_to_refactor_and_remove/app_colors_old.dart';
import '../../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';
import '../../../in_app_notifications/screens/notifications_list/widgets/notifications_date_cell.dart';
import '../../entities/transaction/request_entity.dart';
import '../../repository/dashboard_repository.dart';
import 'bloc/date/entity/date_selected_entity.dart';
import 'bloc/history/transaction_history_cubit.dart';
import 'bloc/history/transaction_history_state.dart';
import 'transaction_categories_screen.dart';
import 'transaction_date_screen.dart';
import 'transaction_details_screen.dart';
import 'widgets/transaction_history_cell.dart';

class _TransactionHistoryScreenStyle {
  final TextStyle titleTextStyle;
  final TextStyle emptyTextStyle;
  final AppColorsOld colors;

  _TransactionHistoryScreenStyle({
    this.titleTextStyle,
    this.emptyTextStyle,
    this.colors,
  });

  factory _TransactionHistoryScreenStyle.fromOldTheme(AppThemeOld theme) {
    return _TransactionHistoryScreenStyle(
      titleTextStyle: theme.textStyles.m18.copyWith(color: theme.colors.darkShade),
      emptyTextStyle: Get.textTheme.headline6Bold.copyWith(color: Get.theme.colorScheme.midShade),
      colors: theme.colors,
    );
  }
}

class TransactionHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => TransactionHistoryCubit(context.repository<DashboardRepository>()),
        child: _TransactionHistory());
  }
}

class _TransactionHistory extends StatelessWidget {
  final _TransactionHistoryScreenStyle style = _TransactionHistoryScreenStyle.fromOldTheme(AppThemeOld.defaultTheme());

  @override
  Widget build(BuildContext context) {
    return TabbedAppBar(
      choices: _transactionChoice(),
      title: AppStrings.TRANSACTIONS.tr(),
      onSubmitted: (query) {
        context.read<TransactionHistoryCubit>().searchRequestDataEvent(query);
      },
      onSearchChange: (query) {
        context.read<TransactionHistoryCubit>().searchRequestDataEvent(query);
      },
      bottomActions: _bottomAction(context),
      body: (choice) => _ChoiceCard(choice: choice),
    );
  }

  List<Widget> _bottomAction(BuildContext context) {
    return <Widget>[
      Container(
          width: 40,
          height: 40,
          child: IconButton(
            onPressed: () => openDateScreen(context),
            icon: SvgPicture.asset(
              IconsSVG.date,
              // color: Get.theme.colorScheme.primary,
            ),
          )),
      Container(
          width: 40,
          height: 40,
          child: IconButton(
            onPressed: () => openCategoryScreen(context),
            icon: SvgPicture.asset(
              IconsSVG.menu,
              color: Color(0xFFD1AC00),
            ),
          ))
    ];
  }

  void openCategoryScreen(BuildContext context) async {
    final cubit = context.bloc<TransactionHistoryCubit>();
    final data = await Get.to(TransactionCategoriesScreen(cubit.category));
    logger.d("selected category = $data");
    cubit.updateCategoryEvent(data);
  }

  void openDateScreen(BuildContext context) async {
    final bloc = context.bloc<TransactionHistoryCubit>();
    final data = await Get.to(TransactionDateScreen(bloc.from, bloc.to, context.locale.languageCode));
    if (data != null && data is DateSelectedEntity) {
      logger.d("date = $data");
      bloc.updateDateEvent(from: data.dateFrom, to: data.dateTo);
    }
  }

  List<TabBarChoice> _transactionChoice() {
    return [
      TabBarChoice(title: AppStrings.ALL),
      TabBarChoice(title: AppStrings.INCOMING),
      TabBarChoice(title: AppStrings.OUTGOING),
    ];
  }
}

class _ChoiceCard extends StatelessWidget {
  _ChoiceCard({Key key, this.choice}) : super(key: key);

  final _TransactionHistoryScreenStyle _style = _TransactionHistoryScreenStyle.fromOldTheme(AppThemeOld.defaultTheme());
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  final TabBarChoice choice;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionHistoryCubit, TransactionHistoryState>(
      listener: (context, state) {
        switch (state.runtimeType) {
          case TransactionHistoryRefreshingState:
          case TransactionHistoryList:
          case TransactionHistoryErrorState:
            _refreshController.refreshCompleted();
            _refreshController.loadComplete();
            break;
          default:
            break;
        }
      },
      buildWhen: (previous, current) {
        return !(current is TransactionHistoryLoadingState);
      },
      builder: (context, state) {
        return SmartRefresher(
            controller: _refreshController,
            enablePullUp: (state is TransactionHistoryList) && state.requests.isNotEmpty,
            onRefresh: () =>
                {if (_refreshController.isRefresh) context.read<TransactionHistoryCubit>().refreshDataEvent()},
            onLoading: () {
              if (_refreshController.isLoading) {
                context.read<TransactionHistoryCubit>().requestDataEvent();
              }
            },
            header: LoadingHeader(),
            footer: LoadingFooter(),
            child: _getRefresherList(context, state));
      },
    );
  }

  Widget _getRefresherList(BuildContext context, TransactionHistoryState state) {
    switch (state.runtimeType) {
      case TransactionHistoryInitState:
        context.watch<TransactionHistoryCubit>().requestDataEvent();
        return ListShimmering();
      case TransactionHistoryRefreshingState:
        return ListShimmering();
      case TransactionHistoryList:
        return _transactionList(context, (state as TransactionHistoryList).requests);
      default:
        return const SizedBox();
    }
  }

  Widget _transactionList(BuildContext context, List<dynamic> list) {
    if (list.isNotEmpty) {
      return ListView.separated(
        padding: const EdgeInsets.only(top: 12),
        itemCount: list.length,
        separatorBuilder: (BuildContext context, int index) {
          if (list[index] is NotificationsListSectionForm || list[index + 1] is NotificationsListSectionForm) {
            return const SizedBox();
          } else {
            return Divider(indent: 70, height: 1, thickness: 1, color: _style.colors.extraLightShade);
          }
        },
        itemBuilder: (context, index) {
          final item = list[index];
          switch (item.runtimeType) {
            case DateTime:
              String title;
              final dateTime = item as DateTime;
              final today = getTodayDate();
              final yesterday = getYesterdayDate();
              if (dateTime.year == today.year) {
                if (dateTime.month == today.month && dateTime.day == today.day) {
                  title = AppStrings.TODAY.tr();
                } else if (dateTime.month == yesterday.month && dateTime.day == yesterday.day) {
                  title = AppStrings.YESTERDAY.tr();
                } else {
                  title = DateFormat("MMM, d", 'en').format(dateTime);
                }
              } else {
                title = AppStrings.LATER.tr();
              }

              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GroupHeaderSection(title: title),
                );
              }
              return Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: GroupHeaderSection(title: title),
              );
            case RequestEntity:
              return InkWell(
                child: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 8),
                    child: TransactionHistoryCell(item as RequestEntity)),
                onTap: () => {Get.to(TransactionDetailsScreen(item))},
              );
            default:
              return const SizedBox();
          }
        },
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            AppStrings.NO_TRANSACTIONS.tr(),
            style: _style.emptyTextStyle,
          ),
        ],
      );
    }
  }
}

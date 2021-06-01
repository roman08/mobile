import 'package:Velmie/resources/colors/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../flows/dashboard_flow/entities/transaction/request_enum.dart';
import '../../flows/dashboard_flow/transaction/screen/bloc/history/transaction_history_cubit.dart';
import '../../resources/themes/need_to_refactor_and_remove/app_colors_old.dart';
import '../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';
import 'app_bars/search_bar.dart';

typedef BodyBuilder = Widget Function(TabBarChoice choice);

class _TabbedAppBarStyle {
  final TextStyle titleTextStyle;
  final TextStyle tabLabelTextStyle;
  final AppColorsOld colors;

  _TabbedAppBarStyle({
    this.titleTextStyle,
    this.tabLabelTextStyle,
    this.colors,
  });

  factory _TabbedAppBarStyle.fromOldTheme(AppThemeOld theme) {
    return _TabbedAppBarStyle(
        titleTextStyle: theme.textStyles.m18.copyWith(color: theme.colors.darkShade),
        tabLabelTextStyle: theme.textStyles.m16,
        colors: theme.colors);
  }
}

enum TransactionType { all, incoming, outgoing }

class TabbedAppBar extends StatelessWidget {
  TabbedAppBar(
      {Key key,
      @required this.choices,
      this.title,
      this.body,
      this.leading,
      this.onSubmitted,
      this.onSearchChange,
      this.bottomActions = const <Widget>[]})
      : assert(choices != null),
        super(key: key);

  final String title;
  final BodyBuilder body;
  final List<TabBarChoice> choices;
  final Widget leading;
  final List<Widget> bottomActions;
  final ValueChanged<String> onSubmitted;
  final ValueChanged<String> onSearchChange;

  final _TabbedAppBarStyle style = _TabbedAppBarStyle.fromOldTheme(AppThemeOld.defaultTheme());

  @override
  Widget build(BuildContext context) {
    final bottomBar = _bottomBar(context);
    return DefaultTabController(
      length: choices.length,
      child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(110 + bottomBar.preferredSize.height),
              child: AppBar(
                backgroundColor: Colors.white,
                centerTitle: true,
                elevation: 0,
                leading: leading,
                automaticallyImplyLeading: false,
                title: Text(
                  title,
                  style: style.titleTextStyle,
                ),
                bottom: _bottomBar(context),
              )),
          body: SafeArea(
            child: TabBarView(
              children: choices.map((TabBarChoice choice) {
                return body(choice);
              }).toList(),
            ),
          )),
    );
  }

  PreferredSize _bottomBar(BuildContext context) {
    final tabWidth = MediaQuery.of(context).size.width / choices.length;
    return PreferredSize(
      preferredSize: const Size.fromHeight(60.0),
      child: Column(
        children: <Widget>[
          TabBar(
            indicatorColor: AppColors.primary,
            unselectedLabelColor: AppColors.primary,
            labelStyle: style.tabLabelTextStyle,
            labelColor: AppColors.tabs,
            indicatorWeight: 1,
            isScrollable: true,
            indicatorSize: TabBarIndicatorSize.label,
            labelPadding: const EdgeInsets.symmetric(horizontal: 0.0),
            tabs: choices.map((TabBarChoice choice) {
              return Container(width: tabWidth, child: Tab(text: choice.title.tr()));
            }).toList(),
            onTap: (position) => {
              context
                  .read<TransactionHistoryCubit>()
                  .updateOperationEvent(RequestEnums.intAsRequestOperation(position)),
            },
          ),
          Divider(
            color: style.colors.lightShade,
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 22),
            child: _appBottomBarButtons(context),
          ),
        ],
      ),
    );
  }

  Widget _appBottomBarButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 16, right: 16),
      child: Row(
        children: <Widget>[
          Expanded(
            child: SearchBar(
              onSubmitted: onSubmitted,
              onSearchChange: onSearchChange,
              margin: EdgeInsets.zero,
            ),
          ),
          ...bottomActions,
        ],
      ),
    );
  }
}

class TabBarChoice {
  TabBarChoice({this.title});

  final String title;
}

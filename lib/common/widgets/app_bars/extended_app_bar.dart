import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'base_app_bar.dart';
import 'search_bar.dart';

/// Complex AppBar for combination tabBar and/or searchBar with BaseAppBar
class ExtendedAppBar extends StatelessWidget {
  const ExtendedAppBar(
      {Key key,
      @required this.tabs,
      this.titleWidget,
      this.titleString,
      this.leading,
      this.actions = const <Widget>[],
      this.toolBarHeight,
      this.searchBarHeight,
      this.tabBarHeight,
      this.isTabBar = true,
      this.isSearchBar = true,
      this.onSubmitted,
      this.onSearchChange,
      this.searchActions = const <Widget>[]})
      : assert(titleWidget == null || titleString == null,
            '\n\nCannot provide both a titleWidget and a titleString.\nUse only one option\n'),
        assert(isTabBar || isSearchBar,
            '\n\nCannot hide tabBar and searchBar at the same time. Use $BaseAppBar widget instead.\n'),
        super(key: key);

  final Map<String, Widget> tabs;
  final Widget titleWidget;
  final String titleString;
  final Widget leading;
  final List<Widget> actions;
  final bool isSearchBar;
  final bool isTabBar;
  final double toolBarHeight;
  final double searchBarHeight;
  final double tabBarHeight;
  final ValueChanged<String> onSubmitted;
  final ValueChanged<String> onSearchChange;
  final List<Widget> searchActions;

  @override
  Widget build(BuildContext context) {
    final tabbedBar = _tabbedBar(context);
    final searchBar = _searchBar(context);
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            (toolBarHeight ?? kToolbarHeight.h) +
                (isTabBar ? tabbedBar.preferredSize.height : 0) +
                (isSearchBar ? searchBar.preferredSize.height : 0),
          ),
          child: AppBar(
            backgroundColor: Get.theme.colorScheme.primary,
            leading: leading,
            automaticallyImplyLeading: false,
            actions: actions,
            title: titleWidget ??
                Text(
                  titleString ?? '',
                  style: Get.textTheme.headline3
                      .copyWith(color: Get.theme.colorScheme.onPrimary),
                ),
            bottom: PreferredSize(
              preferredSize: null,
              child: Column(
                children: [
                  if (isTabBar) tabbedBar else const SizedBox(),
                  if (isSearchBar) searchBar else const SizedBox(),
                ],
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              TabBarView(children: tabs.values.toList()),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 24.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Get.theme.colorScheme.onPrimary.withOpacity(0),
                        Get.theme.colorScheme.onPrimary.withOpacity(0.35),
                        Get.theme.colorScheme.onPrimary,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSize _tabbedBar(BuildContext context) {
    final tabWidth = Get.width / tabs.length;
    return PreferredSize(
      preferredSize: Size.fromHeight(tabBarHeight ?? 44.h),
      child: TabBar(
        indicatorColor: Get.theme.colorScheme.onPrimary,
        unselectedLabelColor: Get.theme.colorScheme.surface,
        labelStyle: Get.textTheme.headline3
            .copyWith(color: Get.theme.colorScheme.onPrimary),
        labelColor: Get.theme.colorScheme.onPrimary,
        indicatorWeight: 1,
        isScrollable: true,
        indicatorSize: TabBarIndicatorSize.label,
        labelPadding: EdgeInsets.zero,
        tabs: tabs.keys
            .map((e) => Container(
                  width: tabWidth,
                  child: Tab(text: e.tr()),
                ))
            .toList(),
        onTap: (position) => {},
      ),
    );
  }

  PreferredSize _searchBar(BuildContext context) => PreferredSize(
        preferredSize: Size.fromHeight(searchBarHeight ?? kToolbarHeight),
        child: Container(
          padding: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 10.w),
          alignment: Alignment.center,
          color: Get.theme.colorScheme.onPrimary,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: SearchBar(
                  onSubmitted: (query) => onSubmitted(query),
                  onSearchChange: (query) => onSearchChange(query),
                  margin: EdgeInsets.zero,
                ),
              ),
              ...searchActions,
            ],
          ),
        ),
      );
}

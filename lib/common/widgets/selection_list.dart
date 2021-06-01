import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../resources/colors/custom_color_scheme.dart';
import '../../resources/icons/icons_svg.dart';
import 'app_bars/base_app_bar.dart';

class SelectionList extends StatefulWidget {
  final PreferredSizeWidget appBar;
  final List<dynamic> list;
  final Widget Function(dynamic) itemBuilder;
  final Function(dynamic) onSelected;

  const SelectionList({
    Key key,
    this.appBar,
    this.list,
    this.itemBuilder,
    this.onSelected,
  }) : super(key: key);

  @override
  _SelectionListState createState() => _SelectionListState();
}

class _SelectionListState extends State<SelectionList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar ?? _defaultAppBar(context),
      body: ListView.separated(
          itemCount: this.widget.list.length + 1,
          separatorBuilder: (BuildContext context, int index) => Divider(
                indent: 24.w,
                endIndent: 24.w,
                height: 1,
                thickness: 1,
                color: Get.theme.colorScheme.lightShade,
              ),
          itemBuilder: (context, index) {
            if (index != this.widget.list.length) {
              final item = this.widget.list[index];
              return InkWell(
                onTap: () {
                  this.widget.onSelected(item);
                  Get.back();
                },
                child: this.widget.itemBuilder(item),
              );
            } else {
              return const SizedBox();
            }
          }),
    );
  }

  Widget _defaultAppBar(BuildContext context) => BaseAppBar(
        backIconPath: IconsSVG.cross,
        backIconColor: Get.theme.colorScheme.onBackground,
        backgroundColor: Get.theme.colorScheme.background,
      );
}

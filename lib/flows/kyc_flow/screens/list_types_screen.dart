import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/widgets/app_bars/base_app_bar.dart';
import '../../../resources/icons/icons_svg.dart';
import '../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';
import '../models/tiers_result.dart';
import '../widgets/field_cell.dart';

class ListTypesScreenObject {
  final List<Option> types;
  final int selectedIndex;
  final Function(int) onPressed;

  ListTypesScreenObject({
    this.types,
    this.selectedIndex,
    this.onPressed,
  });
}

class ListTypesScreen extends StatefulWidget {
  static const String LIST_TYPES_ROUTE = '/list_types';

  final ListTypesScreenObject object;

  const ListTypesScreen({
    Key key,
    this.object,
  }) : super(key: key);

  @override
  _ListTypesScreenState createState() => _ListTypesScreenState();
}

class _ListTypesScreenState extends State<ListTypesScreen> {
  int _selectedIndex = -1;

  @override
  void initState() {
    Provider.of<AppThemeOld>(context, listen: false);
    setState(() {
      _selectedIndex = this.widget.object.selectedIndex;
    });
    super.initState();
  }

  BaseAppBar _appBar() => const BaseAppBar(
        backIconPath: IconsSVG.cross,
      );

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<AppThemeOld>(context);

    return Scaffold(
      appBar: _appBar(),
      body: ListView.separated(
        padding: const EdgeInsets.only(
          top: 26,
          left: 13,
          right: 19,
        ),
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              FieldCell(
                text: this.widget.object.types[index].name,
                status: _selectedIndex == index,
                onPressed: () {
                  this.widget.object.onPressed(index);
                  setState(() {
                    _selectedIndex = index;
                  });
                  Navigator.of(context).pop();
                },
              ),
              if (index == this.widget.object.types.length - 1)
                Container(
                  height: 1,
                  color: theme.colors.extraLightShade,
                )
              else
                Container(),
            ],
          );
        },
        separatorBuilder: (context, index) {
          return Container(
            height: 1,
            color: theme.colors.extraLightShade,
          );
        },
        itemCount: this.widget.object.types.length,
      ),
    );
  }
}

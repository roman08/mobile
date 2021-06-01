import 'package:Velmie/flows/sign_up_flow/screens/sign_up_screen/widgets/country_code_picker/country_code.dart';
import 'package:Velmie/flows/sign_up_flow/screens/sign_up_screen/widgets/country_code_picker/custom_selection_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../resources/colors/custom_color_scheme.dart';

import 'code_countries_map.dart';

class CustomCountryList extends StatefulWidget {
  const CustomCountryList({
    this.onChanged,
    this.isShowFlag,
    this.isDownIcon,
    this.isShowTitle,
    this.initialSelection,
  });

  final bool isShowTitle;
  final bool isShowFlag;
  final bool isDownIcon;
  final String initialSelection;
  final ValueChanged<CountryCode> onChanged;

  @override
  _CustomCountryListState createState() {
    final List<Map<String, String>> jsonList = codes;

    final List<CountryCode> elements = jsonList
        .map(
          (Map<String, String> s) => CountryCode(
          name: s['name'], code: s['code'], dialCode: s['dial_code']),
    )
        .toList();
    return _CustomCountryListState(elements);
  }
}

class _CustomCountryListState extends State<CustomCountryList> {
  _CustomCountryListState(this.elements);

  CountryCode selectedItem;
  List<CountryCode> elements = [];

  @override
  void initState() {
    if (widget.initialSelection != null) {
      selectedItem = elements.firstWhere(
              (CountryCode e) =>
          (e.code.toUpperCase() == widget.initialSelection.toUpperCase()) ||
              (e.dialCode == widget.initialSelection.toString()),
          orElse: () => elements[0]);
    } else {
      selectedItem = elements[0];
    }

    super.initState();
  }

  Future<void> _awaitFromSelectScreen(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) =>
            CustomSelectionList(elements, selectedItem),
      ),
    );

    setState(() {
      selectedItem = result ?? selectedItem;
      widget.onChanged(result ?? selectedItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _awaitFromSelectScreen(context);
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4, right: 8),
        child: Flex(
          direction: Axis.horizontal,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Text(
                  widget.isShowTitle
                      ? selectedItem.toCountryStringOnly()
                      : selectedItem.toString(),
                  style: Get.textTheme.headline5.copyWith(color: Get.theme.colorScheme.onBackground),
                ),
              ),
            ),
            if (widget.isDownIcon == true)
              Flexible(
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: Get.theme.colorScheme.midShade,
                ),
              )
          ],
        ),
      ),
    );
  }
}

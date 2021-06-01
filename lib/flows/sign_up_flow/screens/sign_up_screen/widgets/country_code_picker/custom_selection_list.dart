import 'package:Velmie/flows/sign_up_flow/screens/sign_up_screen/widgets/country_code_picker/country_code.dart';
import 'package:Velmie/resources/colors/app_colors.dart';
import 'package:Velmie/resources/themes/need_to_refactor_and_remove/app_theme_old.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomSelectionList extends StatefulWidget {
  const CustomSelectionList(
    this.elements,
    this.initialSelection, {
    Key key,
  }) : super(key: key);

  final List<CountryCode> elements;
  final CountryCode initialSelection;

  @override
  _SelectionListState createState() => _SelectionListState();
}

class _SelectionListState extends State<CustomSelectionList> {
  List<CountryCode> countries;
  final TextEditingController _controller = TextEditingController();
  ScrollController _controllerScroll;
  double diff = 0.0;

  int posSelected = 0;
  double height = 0.0;

  bool isShowVerticalSearchHelper = false;

  Icon icon = Icon(Icons.search);

  @override
  void initState() {
    countries = widget.elements;
    countries.sort((CountryCode a, CountryCode b) {
      return a.name.toString().compareTo(b.name.toString());
    });
    _controllerScroll = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  void _sendDataBack(BuildContext context, CountryCode initialSelection) {
    Navigator.pop(context, initialSelection);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<AppThemeOld>(context);
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: theme.colors.darkShade),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constrainsts) {
          diff = height - constrainsts.biggest.height;
          return Stack(
            children: <Widget>[
              ListView(
                controller: _controllerScroll,
                children: [
                  Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                          title: Text('${widget.initialSelection.name}  ${widget.initialSelection.dialCode}',
                              textAlign: TextAlign.start,
                              style: theme.textStyles.r16.copyWith(color: theme.colors.darkShade)),
                          trailing: const Icon(Icons.check, color: AppColors.primary),
                        ),
                      ),
                      Divider(thickness: 1, height: 1, color: theme.colors.lightShade),
                    ],
                  ),
                  ...countries.map(
                    (CountryCode country) => getListCountry(country, theme),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget getListCountry(CountryCode country, AppThemeOld theme) {
    return Container(
      child: (country == widget.initialSelection)
          ? const SizedBox()
          : Column(
              children: <Widget>[
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  title: Text('${country.name}  ${country.dialCode}',
                      textAlign: TextAlign.start, style: theme.textStyles.r16.copyWith(color: theme.colors.darkShade)),
                  onTap: () {
                    _sendDataBack(context, country);
                  },
                ),
                Divider(thickness: 1, height: 1, color: theme.colors.lightShade),
              ],
            ),
    );
  }

  Widget appBarTitle = const Text("Select Country");

  void _handleSearchEnd() {
    setState(() {
      icon = Icon(
        Icons.search,
        color: Theme.of(context).secondaryHeaderColor,
      );
      appBarTitle = const Text('Select Country');
      _controller.clear();
    });
  }

  void _filterElements(String s) {
    s = s.toUpperCase();
    setState(() {
      countries = widget.elements
          .where((CountryCode e) => e.code.contains(s) || e.dialCode.contains(s) || e.name.toUpperCase().contains(s))
          .toList();
    });
  }

  _scrollListener() {
    if ((_controllerScroll.offset) >= (_controllerScroll.position.maxScrollExtent)) {}
    if (_controllerScroll.offset <= _controllerScroll.position.minScrollExtent &&
        !_controllerScroll.position.outOfRange) {}
  }
}

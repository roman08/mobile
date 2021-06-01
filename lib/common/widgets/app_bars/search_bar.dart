import 'dart:async';

import 'package:Velmie/resources/app_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../resources/colors/custom_color_scheme.dart';

import '../../../resources/icons/icons_svg.dart';
import '../../../resources/strings/app_strings.dart';

class SearchBar extends StatefulWidget {
  final ValueChanged<String> onSearchChange;
  final ValueChanged<String> onSubmitted;
  final EdgeInsets margin;

  const SearchBar({
    Key key,
    this.onSearchChange,
    this.onSubmitted,
    this.margin,
  }) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final _controller = TextEditingController();
  var _isShowingClearButton = false;
  Timer _debounce;
  String _previousValue = '';

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      _showClearButtonIfNeeded();

      if (widget.onSearchChange != null && _previousValue != _controller.text) {
        _previousValue = _controller.text;
        updateSearchWhenUserStopsTyping(_controller.text);
      }
    });
  }

  void updateSearchWhenUserStopsTyping(String amount) {
    if (_debounce?.isActive ?? false) {
      _debounce.cancel();
    }

    const timerDuration = Duration(milliseconds: DEFAULT_DEBOUNCE_TIME_MS);

    _debounce = Timer(timerDuration, () {
      widget.onSearchChange(_controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: widget.margin,
      child: Container(
        height: 36.h,
        child: TextField(
          controller: _controller,
          style: Get.textTheme.headline5
              .copyWith(color: Get.theme.colorScheme.onBackground),
          onSubmitted: (value) {
            widget.onSubmitted(_controller.text);
          },
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: Get.theme.colorScheme.primaryExtraLight,
            // Borders are needed to keep search icon in place
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Get.theme.colorScheme.primaryExtraLight),
              borderRadius: BorderRadius.all(
                Radius.circular(24.w),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Get.theme.colorScheme.primaryExtraLight),
              borderRadius: BorderRadius.all(
                Radius.circular(24.w),
              ),
            ),
            contentPadding: EdgeInsets.all(8.w),
            prefixIcon: Padding(
              padding: EdgeInsets.all(8.w),
              child: SvgPicture.asset(
                IconsSVG.search,
                color: Get.theme.colorScheme.boldShade,
              ),
            ),
            suffixIcon: _clearButton(),
            hintStyle: Get.textTheme.headline5
                .copyWith(color: Get.theme.colorScheme.boldShade),
            hintText: AppStrings.SEARCH.tr(),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showClearButtonIfNeeded() {
    setState(() {
      _isShowingClearButton = _controller.text?.isNotEmpty ?? false;
    });
  }

  Widget _clearButton() {
    if (!_isShowingClearButton) {
      return const SizedBox();
    }
    return GestureDetector(
      onTap: () {
        _controller.clear();
        FocusScope.of(context).unfocus();
      },
      child: Container(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.all(8.w),
          child: SvgPicture.asset(
            IconsSVG.cross,
            color: Get.theme.colorScheme.onSecondary,
          ),
        ),
      ),
    );
  }
}

import 'package:Velmie/resources/colors/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../app.dart';
import '../../../../common/widgets/app_bars/base_app_bar.dart';
import '../../../../resources/icons/icons_svg.dart';
import '../../../../resources/strings/app_strings.dart';
import '../../../../resources/themes/need_to_refactor_and_remove/app_colors_old.dart';
import '../../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';
import 'bloc/date/entity/date_selected_entity.dart';
import 'bloc/date/transaction_date_cubit.dart';
import 'bloc/date/transaction_date_state.dart';

class _TransactionDateScreenStyle {
  final TextStyle titleTextStyle;
  final AppColorsOld colors;
  final TextStyle cancelButtonStyle;
  final String iconDropDown;

  _TransactionDateScreenStyle({
    this.titleTextStyle,
    this.colors,
    this.cancelButtonStyle,
    this.iconDropDown,
  });

  factory _TransactionDateScreenStyle.fromOldTheme(AppThemeOld theme) {
    return _TransactionDateScreenStyle(
      titleTextStyle: theme.textStyles.m18.copyWith(color: theme.colors.darkShade),
      colors: theme.colors,
      cancelButtonStyle: theme.textStyles.m16.copyWith(color: AppColors.primary),
      iconDropDown: IconsSVG.arrowDown,
    );
  }
}

class TransactionDateScreen extends StatelessWidget {
  TransactionDateScreen(DateTime dateFrom, DateTime dateTo, String languageCode) {
    dateTo ??= DateTime.now();
    dateFrom ??= DateTime(dateTo.year, dateTo.month - 1, dateTo.day);

    _cubit = TransactionDateCubit(dateFrom, dateTo);
    _controllerDateFrom.text = _dateFormat(dateFrom, languageCode: languageCode);
    _controllerDateTo.text = _dateFormat(dateTo, languageCode: languageCode);
  }

  TransactionDateCubit _cubit;

  final _TransactionDateScreenStyle style = _TransactionDateScreenStyle.fromOldTheme(AppThemeOld.defaultTheme());

  final _controllerDateFrom = TextEditingController();
  final _controllerDateTo = TextEditingController();
  final _dateFromKey = UniqueKey();
  final _dateToKey = UniqueKey();

  String _dateFormat(DateTime date, {String languageCode = 'en'}) {
    if (date == null) {
      return "";
    } else {
      return DateFormat('d MMMM, y', languageCode).format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(context),
        body: SafeArea(
            child: BlocConsumer<TransactionDateCubit, TransactionDateState>(
                cubit: _cubit,
                listener: (context, state) {
                  if (state.runtimeType == SuccessTransactionDateState) {
                    Get.back(result: DateSelectedEntity(dateFrom: state.dateFrom, dateTo: state.dateTo));
                    return;
                  }
                  if (state.dateFrom != null) {
                    _controllerDateFrom.text = _dateFormat(
                      state.dateFrom,
                      languageCode: context.locale.languageCode,
                    );
                  }
                  if (state.dateTo != null) {
                    _controllerDateTo.text = _dateFormat(
                      state.dateTo,
                      languageCode: context.locale.languageCode,
                    );
                  }
                },
                buildWhen: (previous, current) {
                  return current.runtimeType != SuccessTransactionDateState;
                },
                builder: (_, state) {
                  return Column(children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                      child: _dateFromField(context, state),
                    ),
                    const SizedBox(height: 14),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                      child: _dateToField(context, state),
                    ),
                    const Spacer(),
                    _datePicker(context, state)
                  ]);
                })));
  }

  BaseAppBar _appBar(BuildContext context) => BaseAppBar(
        titleString: AppStrings.SELECT_DATE_RANGE.tr(),
        actions: <Widget>[
          CupertinoButton(
            child: Text(AppStrings.DONE.tr(), style: style.cancelButtonStyle),
            onPressed: () => _cubit.done(),
          ),
        ],
      );

  Widget _dateFromField(BuildContext context, TransactionDateState state) {
    return FocusScope(
      child: Focus(
        onFocusChange: (focus) {
          if (focus) _cubit.showDatePicker(true, state.dateFrom);
        },
        child: TextFormField(
          key: _dateFromKey,
          controller: _controllerDateFrom,
          enableInteractiveSelection: false,
          readOnly: true,
          autofocus: false,
          decoration: InputDecoration(
            labelText: AppStrings.DATE_FROM.tr(),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(top: 20, left: 24, right: 8),
              child: SvgPicture.asset(
                style.iconDropDown,
                color: _getFocusedColorForSuffix(state.isFrom),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _dateToField(BuildContext context, TransactionDateState state) {
    return FocusScope(
      child: Focus(
        onFocusChange: (focus) {
          if (focus) _cubit.showDatePicker(false, state.dateTo);
        },
        child: TextFormField(
          key: _dateToKey,
          controller: _controllerDateTo,
          enableInteractiveSelection: false,
          readOnly: true,
          autofocus: false,
          decoration: InputDecoration(
            labelText: AppStrings.DATE_TO.tr(),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(top: 20, left: 24, right: 8),
              child: SvgPicture.asset(
                style.iconDropDown,
                color: _getFocusedColorForSuffix(state.isFrom != null && !state.isFrom),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getFocusedColorForSuffix(bool isFocus) {
    if (isFocus != null && isFocus) {
      return AppColors.primary;
    } else {
      return style.colors.boldShade;
    }
  }

  Widget _datePicker(BuildContext context, TransactionDateState state) {
    if (state.isFrom != null) {
      DateTime dateTime;
      DateTime dateMin;
      if (state.isFrom) {
        dateTime = state.dateFrom;
      } else {
        dateTime = state.dateTo;
        dateMin = state.dateFrom;
      }
      logger.d(_dateFormat(dateTime));

      return Container(
        color: style.colors.thinShade,
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                color: style.colors.extraLightShade,
              )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CupertinoButton(
                    child: SvgPicture.asset(IconsSVG.cross),
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      _cubit.closeDatePicker();
                    },
                  ),
                  CupertinoButton(
                    child: Text(AppStrings.DONE.tr(), style: style.cancelButtonStyle),
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      _cubit.doneDatePicker(state.isFrom);
                    },
                  )
                ],
              ),
            ),
            Container(
              height: 214,
              foregroundDecoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    colors: [
                      style.colors.thinShade.withOpacity(0.8),
                      style.colors.thinShade.withOpacity(0.3),
                      style.colors.thinShade.withOpacity(0.8),
                    ],
                    stops: List.from([0.0, 0.5, 1.0])),
              ),
              child: CupertinoDatePicker(
                initialDateTime: dateTime,
                mode: CupertinoDatePickerMode.date,
                minimumDate: dateMin,
                onDateTimeChanged: (dateTime) {
                  _cubit.changeDate(state.isFrom, dateTime);
                },
              ),
            ),
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}

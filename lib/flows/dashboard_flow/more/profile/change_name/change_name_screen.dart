import 'package:Velmie/resources/colors/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/app_bars/base_app_bar.dart';
import '../../../../../common/widgets/loader/progress_loader.dart';
import '../../../../../resources/icons/icons_svg.dart';
import '../../../../../resources/strings/app_strings.dart';
import '../../../../../resources/themes/need_to_refactor_and_remove/app_colors_old.dart';
import '../../../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';

class _ChangeNameScreenStyle {
  final TextStyle titleTextStyle;
  final TextStyle appBarTextButton;
  final TextStyle descriptionTextButton;
  final AppColorsOld colors;

  _ChangeNameScreenStyle({
    this.titleTextStyle,
    this.appBarTextButton,
    this.descriptionTextButton,
    this.colors,
  });

  factory _ChangeNameScreenStyle.fromOldTheme(AppThemeOld theme) {
    return _ChangeNameScreenStyle(
      titleTextStyle: theme.textStyles.m28.copyWith(color: theme.colors.darkShade),
      appBarTextButton: theme.textStyles.m16.copyWith(color: AppColors.primary),
      descriptionTextButton: theme.textStyles.r16.copyWith(color: theme.colors.textColor),
      colors: theme.colors,
    );
  }
}

class ChangeNameScreen extends StatelessWidget {
  ChangeNameScreen(this._cubit) {
    _firstNameController.text = _cubit.state.firstName;
    _lastNameController.text = _cubit.state.lastName;
    _secondNameController.text = _cubit.state.secondName;
    _mothersNameController.text = _cubit.state.mothersName;
  }

  final _ChangeNameScreenStyle _style = _ChangeNameScreenStyle.fromOldTheme(AppThemeOld.defaultTheme());
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _secondNameController = TextEditingController();
  final _mothersNameController = TextEditingController();

  final ProfileCubit _cubit;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      cubit: _cubit,
      listener: (context, state) {
        if (state is ProfileUpdatedState) {
          Get.back();
        }
        _firstNameController.text = state.firstName;
        _lastNameController.text = state.lastName;
        _secondNameController.text = state.secondName;
        _mothersNameController.text = state.mothersName;
      },
      child: Scaffold(
        appBar: _appBar(),
        body: ListView(
          children:<Widget>[ BlocBuilder<ProfileCubit, ProfileState>(
              cubit: _cubit,
              builder: (context, state) {
                if (state is ProfileLoadingState) {
                  return progressLoader();
                } else {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 40.h, 16.w, 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          AppStrings.FULL_NAME.tr(),
                          style: _style.titleTextStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 30.0),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16.h),
                          child: Text(
                            AppStrings.FULL_NAME_CHANGE_DESCRIPTION.tr(),
                            style: _style.descriptionTextButton,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 39.h),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: AppStrings.FIRST_NAME.tr(),
                              errorText: (state is ProfileUpdatingErrorState) ? state.error.tr() : null,
                            ),
                            controller: _firstNameController,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 15.h),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: AppStrings.SECOND_NAME.tr(),
                            ),
                            controller: _secondNameController,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 15.h),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: AppStrings.LAST_NAME.tr(),
                              errorText: (state is ProfileUpdatingErrorState) ? state.error.tr() : null,
                            ),
                            controller: _lastNameController,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 15.h),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: AppStrings.MOTHERS_SURNAME.tr(),
                            ),
                            controller: _mothersNameController,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              })],
        ),
      ),
    );
  }

  BaseAppBar _appBar() => BaseAppBar(
        backIconPath: IconsSVG.cross,
        actions: <Widget>[
          CupertinoButton(
            onPressed: () {
              _cubit.updateName(
                firstName: _firstNameController.text,
                lastName: _lastNameController.text,
                secondName: _secondNameController.text,
                mothersName: _mothersNameController.text,
              );
            },
            child: Text(
              AppStrings.SAVE.tr(),
              style: _style.appBarTextButton,
            ),
          )
        ],
      );
}

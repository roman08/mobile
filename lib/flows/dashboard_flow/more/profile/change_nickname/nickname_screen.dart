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

class _ChangeNicknameScreenStyle {
  final TextStyle titleTextStyle;
  final TextStyle appBarTextButton;
  final TextStyle descriptionTextButton;
  final AppColorsOld colors;

  _ChangeNicknameScreenStyle({
    this.titleTextStyle,
    this.appBarTextButton,
    this.descriptionTextButton,
    this.colors,
  });

  factory _ChangeNicknameScreenStyle.fromOldTheme(AppThemeOld theme) {
    return _ChangeNicknameScreenStyle(
      titleTextStyle:
          theme.textStyles.m28.copyWith(color: theme.colors.darkShade),
      appBarTextButton:
          theme.textStyles.m16.copyWith(color: AppColors.primary),
      descriptionTextButton:
          theme.textStyles.r16.copyWith(color: theme.colors.boldShade),
      colors: theme.colors,
    );
  }
}

class ChangeNicknameScreen extends StatelessWidget {
  ChangeNicknameScreen(this._cubit) {
    _nickNameController.text = _cubit.state.nickName;
  }

  final _ChangeNicknameScreenStyle _style =
      _ChangeNicknameScreenStyle.fromOldTheme(AppThemeOld.defaultTheme());
  final _nickNameController = TextEditingController();

  final ProfileCubit _cubit;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      cubit: _cubit,
      listener: (context, state) {
        if (state is ProfileUpdatedState) {
          Get.back();
        }
        _nickNameController.text = state.nickName;
      },
      child: Scaffold(
        appBar: _appBar(),
        body: SafeArea(
          child: BlocBuilder<ProfileCubit, ProfileState>(
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
                          AppStrings.NICKNAME.tr(),
                          style: _style.titleTextStyle,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16.h),
                          child: Text(
                            AppStrings.CHANGE_NICKNAME_DESCRIPTION.tr(),
                            style: _style.descriptionTextButton,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 39.h),
                          child: TextFormField(
                            decoration: InputDecoration(
                              errorText: (state is ProfileUpdatingErrorState)
                                  ? state.error.tr()
                                  : null,
                            ),
                            controller: _nickNameController,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }),
        ),
      ),
    );
  }

  BaseAppBar _appBar() => BaseAppBar(
        backIconPath: IconsSVG.cross,
        actions: <Widget>[
          CupertinoButton(
            onPressed: () {
              _cubit.updateNickName(nickName: _nickNameController.text);
            },
            child: Text(
              AppStrings.SAVE.tr(),
              style: _style.appBarTextButton,
            ),
          )
        ],
      );
}

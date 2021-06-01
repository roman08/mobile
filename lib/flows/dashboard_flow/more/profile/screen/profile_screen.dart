import 'dart:typed_data';

import 'package:Velmie/common/enums/language.dart';
import 'package:Velmie/common/repository/user_repository.dart';
import 'package:Velmie/common/widgets/info_widgets.dart';
import 'package:Velmie/common/widgets/selection_list.dart';
import 'package:Velmie/flows/cards_flow/cubit/cards_cubit.dart';
import 'package:Velmie/flows/cards_flow/enums/card_status.dart';
import 'package:Velmie/flows/cards_flow/screens/issue_card_screen.dart';
import 'package:Velmie/flows/dashboard_flow/more/profile/screen/contacts_screen.dart';
import 'package:Velmie/flows/dashboard_flow/more/profile/screen/profile_terms_and_conditions_screen.dart';
import 'package:Velmie/flows/kyc_flow/kyc_flow.dart';
import 'package:Velmie/flows/sign_up_flow/screens/terms_and_conditions_screen.dart';
import 'package:Velmie/resources/colors/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../common/models/list/list_item_entity.dart';
import '../../../../../common/session/cubit/session_cubit.dart';
import '../../../../../common/session/session_repository.dart';
import '../../../../../common/screens/camera-view-screen/camera_view_screen.dart';
import '../../../../../common/widgets/loader/progress_loader.dart';
import '../../../../../resources/icons/icons_svg.dart';
import '../../../../../resources/strings/app_strings.dart';
import '../../../../../resources/themes/need_to_refactor_and_remove/app_colors_old.dart';
import '../../../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';
import '../account_settings/account_settings_screen.dart';
import '../change_name/change_name_screen.dart';
import '../change_nickname/nickname_screen.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';

class _ProfileScreenStyle {
  final TextStyle titleTextStyle;
  final TextStyle itemTitleStyle;
  final TextStyle itemTitleRedStyle;
  final TextStyle itemSubtitleStyle;
  final TextStyle usernameInitialsStyle;
  final TextStyle sheetActionTextStyle;
  final TextStyle sheetCancelTextStyle;
  final AppColorsOld colors;

  _ProfileScreenStyle({
    this.titleTextStyle,
    this.itemTitleStyle,
    this.itemTitleRedStyle,
    this.itemSubtitleStyle,
    this.usernameInitialsStyle,
    this.sheetActionTextStyle,
    this.sheetCancelTextStyle,
    this.colors,
  });

  factory _ProfileScreenStyle.fromOldTheme(AppThemeOld theme) {
    return _ProfileScreenStyle(
      titleTextStyle: theme.textStyles.m24.copyWith(color: Get.theme.colorScheme.onBackground),
      itemTitleStyle: theme.textStyles.r16.copyWith(color: theme.colors.darkShade),
      itemTitleRedStyle: theme.textStyles.r16.copyWith(color: AppColors.primary),
      itemSubtitleStyle: theme.textStyles.m16.copyWith(color: theme.colors.darkShade),
      usernameInitialsStyle: theme.textStyles.m30.copyWith(color: theme.colors.white),
      sheetActionTextStyle: theme.textStyles.r20.copyWith(color: AppColors.primary),
      sheetCancelTextStyle: theme.textStyles.m20.copyWith(color: AppColors.primary),
      colors: theme.colors,
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final _ProfileScreenStyle _style = _ProfileScreenStyle.fromOldTheme(AppThemeOld.defaultTheme());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _style.colors.primaryBlue,
      body: SafeArea(
        child: BlocProvider(
          create: (BuildContext context) =>
              ProfileCubit(context.read<SessionRepository>(), context.read<UserRepository>()),
          child: _ProfileWidget(),
        ),
      ),
    );
  }
}

class _ProfileWidget extends StatefulWidget {
  @override
  __ProfileWidgetState createState() => __ProfileWidgetState();
}

class __ProfileWidgetState extends State<_ProfileWidget> {
  final _ProfileScreenStyle _style = _ProfileScreenStyle.fromOldTheme(AppThemeOld.defaultTheme());

  @override
  void initState() {
    context.read<CardsCubit>().checkKycStatus();
    context.read<CardsCubit>().checkCardStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CardsCubit, CardsState>(
      builder: (context, cardsState) => BlocBuilder<ProfileCubit, ProfileState>(
        buildWhen: (previousState, profileState) {
          return profileState is ProfileUpdatedState || profileState is ProfileLoadingState;
        },
        builder: (context, profileState) {
          final profileActions = _profileActions(context, profileState, cardsState);
          if (profileState is ProfileLoadingState) {
            return progressLoader();
          } else {
            return Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 90.h),
                  decoration: BoxDecoration(
                    color: _style.colors.brackgroundGeneral,
                    // borderRadius: BorderRadius.only(
                    //   topLeft: Radius.circular(10.w),
                    //   topRight: Radius.circular(10.w),
                    // ),
                  ),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.w, 50.h, 0.w, 24.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 40.w),
                                child: Text(
                                  "${profileState.firstName} ${profileState.lastName}",
                                  style: _style.titleTextStyle,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 3.w),
                              child: IconButton(
                                icon: SvgPicture.asset(
                                  IconsSVG.edit,
                                  width: 15.w,
                                  height: 15.h,
                                ),
                                // color: Colors.red,
                                onPressed: () {
                                  Get.to(ChangeNameScreen(context.bloc<ProfileCubit>()));
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                          separatorBuilder: (context, index) {
                            if (index == 0 || index == profileActions.length - 2) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.h),
                                child: Divider(
                                  height: 1.h,
                                  thickness: 1,
                                  color: _style.colors.primaryBlue,
                                ),
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                          itemCount: profileActions.length,
                          padding: EdgeInsets.fromLTRB(16.w, 16.h, 20.w, 16.h),
                          itemBuilder: (BuildContext context, int index) {
                            if (index == profileActions.length - 1) {
                              return _listItem(
                                context,
                                profileActions[index],
                                titleStyle: _style.itemTitleRedStyle,
                              );
                            } else {
                              return _listItem(context, profileActions[index]);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: 30.h),
                      child: _avatar(
                        context,
                        profileState.avatar,
                        profileState.firstName,
                        profileState,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _avatar(BuildContext context, Uint8List avatar, String userName, ProfileState state) {
    return GestureDetector(
      onTap: () => Get.bottomSheet(modalPopup(
        context,
      )),
      child: CircleAvatar(
        radius: 42.w,
        backgroundColor: _style.colors.boldShade,
        backgroundImage: MemoryImage(avatar ?? Uint8List.fromList(<int>[])),
        child: (avatar == null || avatar.isEmpty)
            ? Text(
                userName?.isNotEmpty == true ? userName[0] : '?',
                style: _style.usernameInitialsStyle,
              )
            : const SizedBox(),
      ),
    );
  }

  Widget _listItem(BuildContext context, ListItemEntity listItem, {TextStyle titleStyle}) {
    return InkWell(
      onTap: () => listItem.onClick(),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 40,
                  height: 40,
                  margin: EdgeInsets.only(right: 14.w),
                  decoration: BoxDecoration(color: AppColorsOld.defaultColors().brackgroundIcons, shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: listItem.icon,
                ),
                SizedBox(
                  width: 260.w,
                  child: Text(
                    listItem.title.tr(),
                    style: titleStyle ?? _style.itemTitleStyle,
                  ),
                ),
              ],
            ),
            SvgPicture.asset(listItem.onClick != null ? IconsSVG.arrowRightIOSStyle : IconsSVG.lock),
          ],
        ),
      ),
    );
  }

  Widget modalPopup(BuildContext context) {
    return CupertinoActionSheet(
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text(
            KYCStrings.SELECT_FROM_GALERY.tr(),
            style: _style.sheetActionTextStyle,
          ),
          onPressed: () async {
            final pickedFile = await ImagePicker().getImage( 
              source: ImageSource.gallery,
              imageQuality: 100,
            );
            context.read<ProfileCubit>().updateAvatar(filePath: pickedFile.path);
            Get.back();
          },
        ),
        CupertinoActionSheetAction(
          child: Text(
            KYCStrings.TAKE_SHOT.tr(),
            style: _style.sheetActionTextStyle,
          ),
          onPressed: () async {
            Get.to(
              CameraViewScreen(
                pageTitle: AppStrings.AVATAR.tr(),
                onTakePicture: (path) {
                  context.read<ProfileCubit>().updateAvatar(filePath: path);

                  // Close the action sheet and then profile screen
                  Get.close(2);
                },
              ),
            );
          },
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text(
          AppStrings.CANCEL.tr(),
          style: _style.sheetCancelTextStyle,
        ),
        onPressed: () {
          Get.back();
        },
      ),
    );
  }

  List<ListItemEntity> _profileActions(BuildContext context, ProfileState profileState, CardsState cardsState) {
    return [
      ListItemEntity(
        title: AppStrings.NICKNAME,
        subtitle: profileState.nickName,
        icon: SvgPicture.asset(IconsSVG.nickName, color: AppColorsOld.defaultColors().white),
        onClick: () => Get.to(ChangeNicknameScreen(context.bloc())),
      ),
      // ListItemEntity(
      //     title: AppStrings.ISSUE_CARD,
      //     icon: SvgPicture.asset(IconsSVG.creditCard1, color: AppColorsOld.defaultColors().white),
      //     onClick: () {
      //       if (cardsState.cardStatus != CardStatus.notRequested) {
      //         showToast(context, AppStrings.SORRY_YOU_CAN_REQUEST_ONE_CARD_ONLY.tr());
      //         return;
      //       }

      //       if (cardsState.kycDone) {
      //         Get.to(IssueCardScreen());
      //       } else {
      //         showToast(context, AppStrings.PLEASE_UPGRADE_YOUR_KYC_LEVEL.tr());
      //       }
      //     }),
      ListItemEntity(
          title: AppStrings.ACCOUNT_SETTINGS,
          icon: SvgPicture.asset(IconsSVG.password, color: AppColorsOld.defaultColors().white),
          onClick: () => Get.to(AccountSettingsScreen())),
      ListItemEntity(
        title: AppStrings.PROFILE,
        icon: SvgPicture.asset(IconsSVG.profile, color: AppColorsOld.defaultColors().white),
        onClick: () => Get.to(const KycFlow()),
      ),
      ListItemEntity(
        title: AppStrings.SYSTEM_LANGUAGE.tr(),
        icon: SvgPicture.asset(IconsSVG.lenguage, color: AppColorsOld.defaultColors().white),
        onClick: () => Get.to(SelectionList(
          list: Language.values,
          onSelected: (item) {
            final code = (item as Language).code;
            context.locale = Locale(code);
            context.read<ProfileCubit>().changeLanguage(code);
          },
          itemBuilder: (item) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    (item as Language).name,
                    style: AppThemeOld.defaultTheme()
                        .textStyles
                        .r16
                        .copyWith(color: AppColorsOld.defaultColors().darkShade),
                  ),
                  if ((item as Language).code == context.locale.languageCode)
                    Icon(
                      Icons.check,
                      color: AppColorsOld.defaultColors().darkShade,
                    )
                ],
              ),
            );
          },
        )),
      ),
      ListItemEntity(
        title: AppStrings.LEGAL_TERMS_AND_COMMERCIAL_CONDITIONS,
        icon: SvgPicture.asset(IconsSVG.terms, color: AppColorsOld.defaultColors().white),
        onClick: () => Get.to(ProfileTermsAndConditionsScreen()),
      ),
      ListItemEntity(
        title: AppStrings.CONTACT_US,
        icon: SvgPicture.asset(IconsSVG.contac, color: AppColorsOld.defaultColors().white),
        onClick: () => Get.to(ContactsScreen()),
      ),
      ListItemEntity(
        title: AppStrings.LOGOUT,
        icon: SvgPicture.asset(IconsSVG.logout, color: AppColorsOld.defaultColors().white),
        onClick: () => context.read<SessionCubit>().logout(),
      ),
    ];
  }
}

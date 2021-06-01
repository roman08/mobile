import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../common/widgets/app_bars/base_app_bar.dart';
import '../../../common/widgets/app_buttons/button.dart';
import '../../../common/widgets/loader/progress_loader.dart';
import '../../../resources/colors/custom_color_scheme.dart';
import '../../../resources/icons/icons_svg.dart';
import '../../../resources/strings/app_strings.dart';
import '../../../resources/themes/need_to_refactor_and_remove/app_colors_old.dart';
import '../../../resources/themes/need_to_refactor_and_remove/app_text_styles_old.dart';
import '../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';
import '../cubit/kyc_cubit.dart';
import '../cubit/kyc_state.dart';
import '../models/current_tier_result.dart';
import '../models/tiers_result.dart';
import '../widgets/verification_item.dart';
import 'verification_group_details_screen.dart';

enum TileBorder {
  none,
  rightBottom,
  right,
  bottom,
}

class AccountLevelScreenStyle {
  final TextStyle titleTextStyle;
  final TextStyle currentLevelTextStyle;
  final TextStyle levelNameTextStyle;
  final TextStyle yourFeatureTitleTextStyle;
  final TextStyle yourFeatureNameTextStyle;
  final TextStyle yourLimitsTitleTextStyle;
  final TextStyle yourLimitsDescTextStyle;
  final TextStyle yourLimitsNoteTextStyle;
  final TextStyle verificationStatusTextStyle;
  final TextStyle verificationStatusSuccessTextStyle;
  final TextStyle verificationTitleTextStyle;
  final TextStyle verificationPropertyTextStyle;
  final Color checkColor;
  final Color tintColor;

  AccountLevelScreenStyle({
    this.titleTextStyle,
    this.currentLevelTextStyle,
    this.levelNameTextStyle,
    this.yourFeatureTitleTextStyle,
    this.yourFeatureNameTextStyle,
    this.yourLimitsTitleTextStyle,
    this.yourLimitsDescTextStyle,
    this.yourLimitsNoteTextStyle,
    this.verificationStatusTextStyle,
    this.verificationStatusSuccessTextStyle,
    this.verificationTitleTextStyle,
    this.verificationPropertyTextStyle,
    this.checkColor,
    this.tintColor,
  });

  factory AccountLevelScreenStyle.fromOldTheme(AppThemeOld theme) {
    return AccountLevelScreenStyle(
      titleTextStyle: theme.textStyles.m18.copyWith(
        color: theme.colors.darkShade,
      ),
      currentLevelTextStyle: AppTextStylesOld.defaultTextStyles().r12.copyWith(
            color: theme.colors.boldShade,
          ),
      levelNameTextStyle: AppTextStylesOld.defaultTextStyles().m30.copyWith(
            color: theme.colors.darkShade,
          ),
      yourFeatureTitleTextStyle:
          AppTextStylesOld.defaultTextStyles().m16.copyWith(
                color: theme.colors.darkShade,
              ),
      yourFeatureNameTextStyle:
          AppTextStylesOld.defaultTextStyles().r16.copyWith(
                color: theme.colors.darkShade,
              ),
      yourLimitsTitleTextStyle:
          AppTextStylesOld.defaultTextStyles().m30.copyWith(
                color: theme.colors.darkShade,
              ),
      yourLimitsDescTextStyle:
          AppTextStylesOld.defaultTextStyles().r12.copyWith(
                color: theme.colors.boldShade,
              ),
      yourLimitsNoteTextStyle:
          AppTextStylesOld.defaultTextStyles().r10.copyWith(
                color: theme.colors.boldShade,
              ),
      verificationStatusTextStyle:
          AppTextStylesOld.defaultTextStyles().r10.copyWith(
                color: theme.colors.boldShade,
              ),
      verificationStatusSuccessTextStyle:
          AppTextStylesOld.defaultTextStyles().r10.copyWith(
                color: theme.colors.green,
              ),
      verificationTitleTextStyle:
          AppTextStylesOld.defaultTextStyles().r24.copyWith(
                color: theme.colors.darkShade,
              ),
      verificationPropertyTextStyle:
          AppTextStylesOld.defaultTextStyles().r12.copyWith(
                color: theme.colors.darkShade,
              ),
      checkColor: Get.theme.colorScheme.success,
      tintColor: theme.colors.extraLightShade,
    );
  }
}

class AccountLevelScreen extends StatefulWidget {
  static const String ROUTE = '/kyc/account_level';

  @override
  _AccountLevelScreenState createState() => _AccountLevelScreenState();
}

class _AccountLevelScreenState extends State<AccountLevelScreen> {
  AccountLevelScreenStyle _style;
  KycCubit _cubit;

  final _formattedNumber = NumberFormat.compactCurrency(
    locale: 'en',
    decimalDigits: 1,
    symbol: '',
  );

  @override
  void initState() {
    _cubit = context.read();
    _style = AccountLevelScreenStyle.fromOldTheme(
      Provider.of<AppThemeOld>(context, listen: false),
    );
    _cubit.fetch();
    super.initState();
  }

  BaseAppBar _appBar() => BaseAppBar(
        titleString: KYCStrings.ACCOUNT_LEVEL.tr(),
      );

  Widget _renderLevelStatus({
    String name,
    bool hasCheck,
    bool hasButton,
    Function onPressed,
  }) {
    return Container(
      color: AppColorsOld.defaultColors().thinShade,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 24,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  KYCStrings.CURRENT_LEVEL.tr(),
                  style: _style.currentLevelTextStyle,
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (hasCheck) ...[
                      Container(
                        child: Center(
                          child: SvgPicture.asset(
                            IconsSVG.check,
                            color: _style.checkColor,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 11,
                      ),
                    ] else
                      Container(),
                    Text(
                      name,
                      style: _style.levelNameTextStyle,
                    ),
                  ],
                ),
                if (hasButton)
                  Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        width: 150,
                        child: Button(
                          title: KYCStrings.UPGRADE.tr(),
                          onPressed: onPressed,
                        ),
                      ),
                    ],
                  )
                else
                  Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderYourFeatures({String name, bool hasCheck}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          KYCStrings.YOUR_FEATURES.tr(),
          style: _style.yourFeatureTitleTextStyle,
        ),
        const SizedBox(
          height: 12,
        ),
        Row(
          children: <Widget>[
            SvgPicture.asset(
              IconsSVG.check,
              color: _style.checkColor,
              width: 12,
            ),
            const SizedBox(
              width: 18,
            ),
            Text(
              name,
              style: _style.yourFeatureNameTextStyle,
            ),
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        Container(
          height: 1,
          color: _style.tintColor,
        ),
      ],
    );
  }

  Widget _renderLimit({CurrentTier currentTier}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          KYCStrings.YOUR_LIMITS.tr(),
          style: _style.yourFeatureTitleTextStyle,
        ),
        const SizedBox(
          height: 9,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: _style.tintColor,
              width: 1,
            ),
          ),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
              childAspectRatio: 1.3,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final limitation = currentTier.limitations[index];
              TileBorder border = TileBorder.none;
              if (index.isEven) {
                if (index == currentTier.limitations.length - 2) {
                  border = TileBorder.right;
                } else {
                  border = TileBorder.rightBottom;
                }
              } else {
                if (index != currentTier.limitations.length - 1) {
                  border = TileBorder.bottom;
                }
              }
              return _renderLimitItem(
                title: _formattedNumber.format(
                  int.parse(limitation.value ?? '0'),
                ),
                note: '',
                description: limitation.name,
                border: border,
              );
            },
            itemCount: currentTier.limitations.length,
          ),
        ),
      ],
    );
  }

  Widget _renderLimitItem({
    String title,
    String note,
    String description,
    TileBorder border,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
            bottom: (border == TileBorder.rightBottom ||
                    border == TileBorder.bottom)
                ? BorderSide(
                    color: _style.tintColor,
                    width: 1,
                  )
                : BorderSide.none,
            right:
                (border == TileBorder.rightBottom || border == TileBorder.right)
                    ? BorderSide(color: _style.tintColor, width: 1)
                    : BorderSide.none),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 35,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  title,
                  style: _style.yourLimitsTitleTextStyle,
                ),
                if (note == null)
                  Container()
                else
                  Row(
                    children: <Widget>[
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        note,
                        style: _style.yourLimitsNoteTextStyle,
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Text(
              description,
              maxLines: 100,
              textAlign: TextAlign.center,
              style: _style.yourLimitsDescTextStyle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderVerificationProgress({List<Tier> tiers}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          KYCStrings.VERIFICATION_PROGRESS.tr(),
          style: _style.yourFeatureTitleTextStyle,
        ),
        const SizedBox(
          height: 16,
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return VerificationItem(
              tintColor: _style.checkColor,
              normalColor: _style.tintColor,
              statusTextStyle: _style.verificationStatusTextStyle,
              statusSelectedTextStyle:
                  _style.verificationStatusSuccessTextStyle,
              titleTextStyle: _style.verificationTitleTextStyle,
              propertyTextStyle: _style.verificationPropertyTextStyle,
              status: tiers[index].status,
              title: tiers[index].name,
              requirements: tiers[index].requirements,
              hasLine: index != tiers.length - 1,
              onTap: () {
                if (tiers[index].status == RequirementStatus.pending ||
                    tiers[index].status == RequirementStatus.approved) {
                  return;
                }
                Navigator.of(context).pushNamed(
                  VerificationGroupDetailsScreen.ROUTE,
                  arguments: {
                    'id': tiers[index].id,
                    'bloc': _cubit,
                  },
                );
              },
            );
          },
          itemCount: tiers.length,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      cubit: _cubit,
      builder: (context, state) {
        if (state is SuccessState) {
          final currentTier = state.currentTier;

          final availableLevels =
              state.tiers.where((element) => element.level > currentTier.level);

          return Scaffold(
            appBar: _appBar(),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _renderLevelStatus(
                      name: currentTier.name,
                      hasCheck: true,
                      hasButton: availableLevels.isNotEmpty,
                      onPressed: () {
                        final id = availableLevels.first.id;
                        Navigator.of(context).pushNamed(
                          VerificationGroupDetailsScreen.ROUTE,
                          arguments: {
                            'id': id,
                            'bloc': _cubit,
                          },
                        );
                      }),
                  const SizedBox(
                    height: 24,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _renderYourFeatures(
                          name: currentTier.name,
                          hasCheck: true,
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        _renderLimit(currentTier: currentTier),
                        const SizedBox(
                          height: 24,
                        ),
                        _renderVerificationProgress(tiers: state.tiers),
                        const SizedBox(
                          height: 24,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Scaffold(
            appBar: _appBar(),
            body: progressLoader(),
          );
        }
      },
    );
  }
}

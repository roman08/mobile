import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../common/widgets/app_bars/base_app_bar.dart';
import '../../../common/widgets/app_buttons/button.dart';
import '../../../common/screens/camera-view-screen/camera_view_screen.dart';
import '../../../common/widgets/info_widgets.dart';
import '../../../common/widgets/loader/progress_loader.dart';
import '../../../resources/strings/app_strings.dart';
import '../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';
import '../../kyc_flow/screens/selfie_preview_screen.dart';
import '../cubit/kyc_cubit.dart';
import '../cubit/kyc_state.dart';
import '../models/tiers_result.dart';
import '../widgets/property_item.dart';
import 'enter_property_screen.dart';
import 'indicator_document_screen.dart';
import 'success_screen.dart';
import 'verification_screen.dart';

class VerificationGroupDetailsScreenStyle {
  final TextStyle titleTextStyle;
  final Color separatorColor;
  final Color imageBackgroundColor;
  final TextStyle propertyTitleTextStyle;
  final TextStyle propertyPlaceholderTextStyle;
  final TextStyle propertyValueTextStyle;

  VerificationGroupDetailsScreenStyle({
    this.titleTextStyle,
    this.separatorColor,
    this.imageBackgroundColor,
    this.propertyTitleTextStyle,
    this.propertyPlaceholderTextStyle,
    this.propertyValueTextStyle,
  });

  factory VerificationGroupDetailsScreenStyle.fromOldTheme(AppThemeOld theme) {
    return VerificationGroupDetailsScreenStyle(
      titleTextStyle: theme.textStyles.m18.copyWith(
        color: theme.colors.darkShade,
      ),
      separatorColor: theme.colors.extraLightShade,
      imageBackgroundColor: theme.colors.lightShade,
      propertyTitleTextStyle: theme.textStyles.r12.copyWith(
        color: theme.colors.boldShade,
      ),
      propertyPlaceholderTextStyle: theme.textStyles.r16.copyWith(
        color: theme.colors.midShade,
      ),
      propertyValueTextStyle: theme.textStyles.r16.copyWith(
        color: theme.colors.darkShade,
      ),
    );
  }
}

class VerificationGroupDetailsScreen extends StatefulWidget {
  static const String ROUTE = '/kyc/verification_group_details';

  final int tierId;
  final KycCubit cubit;

  const VerificationGroupDetailsScreen({
    Key key,
    this.tierId,
    this.cubit,
  }) : super(key: key);

  @override
  _VerificationGroupDetailsScreenState createState() =>
      _VerificationGroupDetailsScreenState();
}

class _VerificationGroupDetailsScreenState
    extends State<VerificationGroupDetailsScreen> {
  VerificationGroupDetailsScreenStyle _style;
  String _imagePath;

  @override
  void initState() {
    _style = VerificationGroupDetailsScreenStyle.fromOldTheme(
      Provider.of<AppThemeOld>(context, listen: false),
    );
    this.widget.cubit.getTier(id: this.widget.tierId);
    super.initState();
  }

  BaseAppBar _appBar({String name}) => BaseAppBar(
        titleString: '$name ${AppStrings.GROUP_DETAILS_LEVEL.tr()}',
        centerTitle: true,
      );

  String _getPlaceholder({ElementIndex index}) {
    switch (index) {
      case ElementIndex.fullName:
        return KYCStrings.ADD_FULL_NAME;
      case ElementIndex.email:
        return KYCStrings.CONFIRM;
      case ElementIndex.phone:
        return KYCStrings.CONFIRM;
      case ElementIndex.dateBirth:
        return KYCStrings.BIRTHDAY_TITLE;
      case ElementIndex.motherMaidenMame:
        return KYCStrings.ADD_MAIDEN;
      case ElementIndex.selfiePhoto:
        return KYCStrings.ADD_SELFIE;
      case ElementIndex.identificationType:
        return KYCStrings.ADD_DOCUMENT;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      cubit: this.widget.cubit,
      builder: (context, state) {
        if (state is SuccessState) {
          final tier = state.tier;

          if (tier == null) {
            return Scaffold(
              appBar: _appBar(name: ''),
              body: progressLoader(),
            );
          }

          final validated = tier.requirements
              .where((item) => item.status == RequirementStatus.notFilled)
              .isEmpty;

          final needButton = tier.requirements
              .where((element) =>
                  element.status == RequirementStatus.notFilled ||
                  element.status == RequirementStatus.waiting ||
                  element.status == RequirementStatus.canceled)
              .toList()
              .isNotEmpty;

          return Scaffold(
            appBar: _appBar(name: state.tier.name),
            body: Stack(
              children: <Widget>[
                SingleChildScrollView(
                  padding: needButton
                      ? const EdgeInsets.only(bottom: 100)
                      : const EdgeInsets.all(0),
                  child: Column(
                    children: <Widget>[
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final requirement = tier.requirements[index];
                          final elementIndex = requirement.elements == null
                              ? ''
                              : requirement.elements.first.index;
                          String value = '';

                          if (requirement.elements.first.index ==
                              ElementIndex.identificationType) {
                            final options = requirement.elements.first.options
                                .where((element) =>
                                    element.value ==
                                    requirement.elements.first.value)
                                .toList();
                            if (options.isNotEmpty) {
                              value = options.first.name;
                            }
                          } else {
                            value = requirement.elements == null
                                ? null
                                : requirement.elements.first.value;
                          }

                          return PropertyItem(
                            imageBackgroundColor: _style.imageBackgroundColor,
                            titleTextStyle: _style.propertyTitleTextStyle,
                            placeholderTextStyle:
                                _style.propertyPlaceholderTextStyle,
                            valueTextStyle: _style.propertyValueTextStyle,
                            title: requirement.name,
                            placeholder:
                                _getPlaceholder(index: elementIndex).tr(),
                            value: value,
                            status: requirement.status,
                            index: requirement.elements.first.index,
                            imagePath: requirement.elements.first.index ==
                                    ElementIndex.selfiePhoto
                                ? _imagePath
                                : null,
                            bytes: requirement.elements.first.bytes,
                            onTap: () async {
                              if (requirement.status ==
                                      RequirementStatus.approved ||
                                  requirement.status ==
                                      RequirementStatus.pending) {
                                return;
                              }

                              switch (requirement.elements.first.index) {
                                case ElementIndex.phone:
                                case ElementIndex.email:
                                  Navigator.of(context).pushNamed(
                                    VerificationScreen.ROUTE,
                                    arguments: {
                                      'requirement': requirement,
                                      'bloc': this.widget.cubit,
                                    },
                                  );
                                  break;
                                case ElementIndex.fullName:
                                case ElementIndex.dateBirth:
                                case ElementIndex.motherMaidenMame:
                                  Navigator.of(context).pushNamed(
                                    EnterPropertyScreen.ROUTE,
                                    arguments: {
                                      'requirement': requirement,
                                      'bloc': this.widget.cubit,
                                    },
                                  );
                                  break;
                                case ElementIndex.identificationType:
                                  Navigator.of(context).pushNamed(
                                    IndicatorDocumentScreen.ROUTE,
                                    arguments: {
                                      'requirement': requirement,
                                      'bloc': this.widget.cubit,
                                    },
                                  );
                                  break;
                                case ElementIndex.selfiePhoto:
                                  Get.to(
                                    CameraViewScreen(
                                      pageTitle: KYCStrings.SELFIE.tr(),
                                      onTakePicture: (path) {
                                        Get.to(SelfiePreviewScreen(
                                          picturePath: path,
                                          kycCubit: widget.cubit,
                                          requirement: requirement,
                                        ));
                                      },
                                    ),
                                  );
                                  break;
                                default:
                                  showToast(context, "Will be available soon");
                                  break;
                              }
                            },
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              left: 72,
                            ),
                            child: Container(
                              height: 1,
                              color: _style.separatorColor,
                            ),
                          );
                        },
                        itemCount: tier.requirements.length,
                      ),
                    ],
                  ),
                ),
                if (needButton)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 32,
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 32,
                        child: Button(
                          title: KYCStrings.SEND_REQUEST.tr(),
                          onPressed: validated
                              ? () {
                                  this
                                      .widget
                                      .cubit
                                      .sendRequest(id: this.widget.tierId);
                                  Navigator.of(context).pushNamed(
                                    SuccessScreen.ROUTE,
                                    arguments: state.tier.name,
                                  );
                                }
                              : null,
                        ),
                      ),
                    ),
                  )
                else
                  Container(),
              ],
            ),
          );
        } else {
          return Scaffold(
            appBar: _appBar(name: ''),
            body: progressLoader(),
          );
        }
      },
    );
  }
}

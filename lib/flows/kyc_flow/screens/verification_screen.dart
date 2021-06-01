import 'package:Velmie/resources/colors/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../common/widgets/app_bars/base_app_bar.dart';
import '../../../common/widgets/loader/progress_loader.dart';
import '../../../resources/icons/icons_svg.dart';
import '../../../resources/strings/app_strings.dart';
import '../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';
import '../cubit/kyc_cubit.dart';
import '../cubit/kyc_state.dart';
import '../models/tiers_result.dart';

class VerificationScreenStyle {
  final TextStyle titleTextStyle;
  final TextStyle saveButtonStyle;
  final TextStyle headerTextStyle;
  final TextStyle noteTextStyle;
  final TextStyle buttonTextStyle;
  final TextStyle alertButtonTextStyle;
  final TextStyle alertTitleTextStyle;
  final TextStyle alertBodyTextStyle;
  final Color buttonBackgroundColor;

  VerificationScreenStyle({
    this.titleTextStyle,
    this.saveButtonStyle,
    this.headerTextStyle,
    this.noteTextStyle,
    this.buttonTextStyle,
    this.alertButtonTextStyle,
    this.alertTitleTextStyle,
    this.alertBodyTextStyle,
    this.buttonBackgroundColor,
  });

  factory VerificationScreenStyle.fromOldTheme(AppThemeOld theme) {
    return VerificationScreenStyle(
      titleTextStyle: theme.textStyles.m18.copyWith(
        color: theme.colors.darkShade,
      ),
      saveButtonStyle: theme.textStyles.r16.copyWith(color: AppColors.primary),
      headerTextStyle: theme.textStyles.r16.copyWith(color: theme.colors.darkShade),
      noteTextStyle: theme.textStyles.m16.copyWith(color: theme.colors.darkShade),
      buttonTextStyle: theme.textStyles.m16.copyWith(color: theme.colors.white),
      alertButtonTextStyle: theme.textStyles.m16.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
      alertTitleTextStyle: theme.textStyles.m18.copyWith(color: theme.colors.darkShade),
      alertBodyTextStyle: theme.textStyles.r12.copyWith(color: theme.colors.darkShade),
      buttonBackgroundColor: AppColors.primary,
    );
  }
}

class VerificationScreen extends StatefulWidget {
  static const String ROUTE = '/kyc/verification';

  final Requirement requirement;
  final KycCubit bloc;

  const VerificationScreen({
    Key key,
    this.requirement,
    this.bloc,
  }) : super(key: key);

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  VerificationScreenStyle _style;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _style = VerificationScreenStyle.fromOldTheme(
      Provider.of<AppThemeOld>(context, listen: false),
    );
    _controller.addListener(() {
      if (_controller.text.length == 6) {
        FocusScope.of(context).unfocus();
        switch (this.widget.requirement.elements.first.index) {
          case ElementIndex.email:
            this.widget.bloc.checkEmailCode(code: _controller.text);
            break;
          case ElementIndex.phone:
            this.widget.bloc.checkPhoneCode(code: _controller.text);
            break;
          default:
            break;
        }

        _controller.clear();
      }
    });
    switch (this.widget.requirement.elements.first.index) {
      case ElementIndex.email:
        this.widget.bloc.sendEmailCode();
        break;
      case ElementIndex.phone:
        this.widget.bloc.sendPhoneCode();
        break;
      default:
        break;
    }
    super.initState();
  }

  void showAlertDialog(BuildContext context) {
    final Widget okButton = FlatButton(
      child: Text(
        AppStrings.OK.tr(),
        style: _style.alertButtonTextStyle,
      ),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );

    final CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text(
        KYCStrings.SUCCESS.tr(),
        style: _style.alertTitleTextStyle,
      ),
      content: Padding(
        padding: const EdgeInsets.only(
          top: 4,
        ),
        child: Text(
          this.widget.requirement.elements.first.index == ElementIndex.email
              ? KYCStrings.EMAIL_VERIFIED.tr()
              : KYCStrings.PHONE_VERIFIED.tr(),
          style: _style.alertBodyTextStyle,
        ),
      ),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void showErrorDialog(BuildContext context) {
    final Widget okButton = FlatButton(
      child: Text(
        AppStrings.OK.tr(),
        style: _style.alertButtonTextStyle,
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    final CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text(
        AppStrings.ERROR.tr(),
        style: _style.alertTitleTextStyle,
      ),
      content: Padding(
        padding: const EdgeInsets.only(
          top: 4,
        ),
        child: Text(
          KYCStrings.INVALID_CODE.tr(),
          style: _style.alertBodyTextStyle,
        ),
      ),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  BaseAppBar _appBar() => const BaseAppBar(
        backIconPath: IconsSVG.cross,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: BlocConsumer(
        cubit: this.widget.bloc,
        listener: (context, state) {
          if (state is VerifiedState) {
            showAlertDialog(context);
          } else if (state is FailState) {
            showErrorDialog(context);
          }
        },
        builder: (context, state) {
          if (state is VerifiedState || state is SuccessState) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 40,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      widget.requirement.elements.first.index == ElementIndex.phone
                          ? KYCStrings.SEND_SMS_CODE.tr()
                          : KYCStrings.SEND_EMAIL_CODE.tr(),
                      style: _style.headerTextStyle,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      this.widget.requirement.elements.first.value,
                      style: _style.noteTextStyle,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 130,
                          child: TextFormField(
                            controller: _controller,
                            decoration: InputDecoration(
                              labelText: KYCStrings.VERIFICATION_CODE.tr(),
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 55,
                    ),
                    CupertinoButton(
                      onPressed: () {
                        switch (this.widget.requirement.elements.first.index) {
                          case ElementIndex.email:
                            this.widget.bloc.sendEmailCode();
                            break;
                          case ElementIndex.phone:
                            this.widget.bloc.sendPhoneCode();
                            break;
                          default:
                            break;
                        }
                      },
                      minSize: 0,
                      padding: EdgeInsets.zero,
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            24,
                          ),
                          color: _style.buttonBackgroundColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              KYCStrings.GET_NEW_CODE.tr(),
                              style: _style.buttonTextStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return progressLoader();
          }
        },
      ),
    );
  }
}

import 'package:Velmie/resources/colors/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:provider/provider.dart';

import '../../../common/widgets/app_bars/base_app_bar.dart';
import '../../../resources/icons/icons_svg.dart';
import '../../../resources/strings/app_strings.dart';
import '../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';
import '../cubit/kyc_cubit.dart';
import '../models/requirement_request.dart';
import '../models/tiers_result.dart';

class EnterPropertyScreenStyle {
  final TextStyle titleTextStyle;
  final TextStyle saveButtonStyle;
  final TextStyle headerTextStyle;
  final TextStyle noteTextStyle;
  final TextStyle errorTextStyle;

  EnterPropertyScreenStyle({
    this.titleTextStyle,
    this.saveButtonStyle,
    this.headerTextStyle,
    this.noteTextStyle,
    this.errorTextStyle,
  });

  factory EnterPropertyScreenStyle.fromOldTheme(AppThemeOld theme) {
    return EnterPropertyScreenStyle(
      titleTextStyle: theme.textStyles.m18.copyWith(
        color: theme.colors.darkShade,
      ),
      saveButtonStyle: theme.textStyles.r16.copyWith(color: AppColors.primary),
      headerTextStyle: theme.textStyles.m30.copyWith(color: theme.colors.darkShade),
      noteTextStyle: theme.textStyles.r16.copyWith(color: theme.colors.boldShade),
      errorTextStyle: theme.textStyles.r14.copyWith(color: theme.colors.red),
    );
  }
}

class EnterPropertyScreen extends StatefulWidget {
  static const String ROUTE = '/kyc/enter_property';

  final Requirement requirement;
  final KycCubit cubit;

  const EnterPropertyScreen({
    Key key,
    this.requirement,
    this.cubit,
  }) : super(key: key);

  @override
  _EnterPropertyScreenState createState() => _EnterPropertyScreenState();
}

class _EnterPropertyScreenState extends State<EnterPropertyScreen> {
  EnterPropertyScreenStyle _style;
  MaskedTextController _controller;
  String error;

  @override
  void initState() {
    _style = EnterPropertyScreenStyle.fromOldTheme(
      Provider.of<AppThemeOld>(context, listen: false),
    );
    switch (this.widget.requirement.elements.first.type) {
      case ElementType.input:
        _controller = MaskedTextController(mask: '******************************');
        break;
      case ElementType.date:
        _controller = MaskedTextController(mask: '00/00/0000');
        break;
      default:
        break;
    }
    _controller.text = this.widget.requirement.elements.first.value;

    super.initState();
  }

  TextInputType _getInputType() {
    switch (this.widget.requirement.elements.first.type) {
      case ElementType.date:
        return TextInputType.number;
      default:
        return TextInputType.text;
    }
  }

  BaseAppBar _appBar() => BaseAppBar(
        backIconPath: IconsSVG.cross,
        actions: <Widget>[saveButton(context)],
      );

  Widget saveButton(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.only(top: 2, left: 16, right: 16),
      color: Colors.transparent,
      child: Text(AppStrings.SAVE.tr(), style: _style.saveButtonStyle),
      onPressed: () {
        if (widget.requirement.elements.first.type == ElementType.date) {
          final date = _controller.text.split('/');

          final day = int.parse(date[0]);
          final month = int.parse(date[1]);
          final year = int.parse(date[2]);

          if (!(day > 0 && day <= 31)) {
            setState(() {
              error = 'Invalid date';
            });
            return;
          }

          if (!(month > 0 && month <= 12)) {
            setState(() {
              error = 'Invalid date';
            });
            return;
          }

          if (year <= 0) {
            setState(() {
              error = 'Invalid date';
            });
            return;
          }

          setState(() {
            error = null;
          });
        }

        this.widget.cubit.updateRequirement(
              id: this.widget.requirement.id,
              requirement: RequirementRequest(
                values: [
                  ElementValue(
                    index: this.widget.requirement.elements.first.index,
                    value: _controller.text,
                  ),
                ],
              ),
            );
        Navigator.of(context).pop();
      },
    );
  }

  String _getPlaceholder({ElementIndex index}) {
    switch (index) {
      case ElementIndex.fullName:
        return KYCStrings.ADD_FULL_NAME;
      case ElementIndex.email:
        return KYCStrings.CONFIRM;
      case ElementIndex.phone:
        return KYCStrings.CONFIRM;
      case ElementIndex.dateBirth:
        return KYCStrings.DATE_FORMAT;
      case ElementIndex.motherMaidenMame:
        return KYCStrings.ADD_MAIDEN;
      case ElementIndex.selfiePhoto:
        return KYCStrings.ADD_SELFIE;
      case ElementIndex.type:
        return KYCStrings.ADD_DOCUMENT;
      default:
        return '';
    }
  }

  String _getNote({ElementIndex index}) {
    switch (index) {
      case ElementIndex.fullName:
        return KYCStrings.FULL_NAME_NOTE;
      case ElementIndex.email:
        return KYCStrings.EMAIL_NOTE;
      case ElementIndex.phone:
        return KYCStrings.PHONE_NOTE;
      case ElementIndex.dateBirth:
        return KYCStrings.BIRTHDAY_NOTE;
      case ElementIndex.motherMaidenMame:
        return KYCStrings.MOTHER_NAME_NOTE;
      case ElementIndex.type:
        return KYCStrings.TYPE_NOTE;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final index = this.widget.requirement.elements.first.index;

    return Scaffold(
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                this.widget.requirement.name,
                style: _style.headerTextStyle,
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                _getNote(
                  index: index,
                ).tr(),
                style: _style.noteTextStyle,
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: _getPlaceholder(
                    index: index,
                  ).tr(),
                ),
                keyboardType: _getInputType(),
              ),
              const SizedBox(height: 10),
              if (error != null)
                Text(
                  error,
                  style: _style.errorTextStyle,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

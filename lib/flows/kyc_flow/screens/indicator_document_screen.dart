import 'dart:io';

import 'package:Velmie/resources/colors/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../common/widgets/app_bars/base_app_bar.dart';
import '../../../resources/icons/icons_svg.dart';
import '../../../resources/strings/app_strings.dart';
import '../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';
import '../cubit/kyc_cubit.dart';
import "../models/requirement_request.dart";
import '../models/tiers_result.dart';
import 'document_preview_screen.dart';
import 'list_types_screen.dart';

class IndicatorDocumentScreenStyle {
  final TextStyle titleTextStyle;
  final TextStyle saveButtonStyle;
  final TextStyle headerTextStyle;
  final TextStyle noteTextStyle;
  final TextStyle buttonTextStyle;
  final TextStyle alertButtonTextStyle;
  final TextStyle alertTitleTextStyle;
  final TextStyle alertBodyTextStyle;
  final TextStyle actionSheetButtonStyle;
  final TextStyle cancelActionSheetButtonStyle;
  final Color buttonBackgroundColor;

  IndicatorDocumentScreenStyle({
    this.titleTextStyle,
    this.saveButtonStyle,
    this.headerTextStyle,
    this.noteTextStyle,
    this.buttonTextStyle,
    this.alertButtonTextStyle,
    this.alertTitleTextStyle,
    this.alertBodyTextStyle,
    this.actionSheetButtonStyle,
    this.cancelActionSheetButtonStyle,
    this.buttonBackgroundColor,
  });

  factory IndicatorDocumentScreenStyle.fromOldTheme(AppThemeOld theme) {
    return IndicatorDocumentScreenStyle(
      titleTextStyle: theme.textStyles.m18.copyWith(
        color: theme.colors.darkShade,
      ),
      saveButtonStyle: theme.textStyles.r16.copyWith(color: AppColors.primary),
      headerTextStyle: theme.textStyles.m30.copyWith(color: theme.colors.darkShade),
      noteTextStyle: theme.textStyles.r16.copyWith(color: theme.colors.boldShade),
      buttonTextStyle: theme.textStyles.m16.copyWith(color: theme.colors.white),
      alertButtonTextStyle: theme.textStyles.m16.copyWith(color: AppColors.primary),
      alertTitleTextStyle: theme.textStyles.m18.copyWith(color: theme.colors.darkShade),
      alertBodyTextStyle: theme.textStyles.r12.copyWith(color: theme.colors.darkShade),
      actionSheetButtonStyle: theme.textStyles.r20.copyWith(color: AppColors.primary),
      cancelActionSheetButtonStyle: theme.textStyles.m20.copyWith(color: AppColors.primary),
      buttonBackgroundColor: AppColors.primary,
    );
  }
}

class IndicatorDocumentScreen extends StatefulWidget {
  static const String ROUTE = '/kyc/indicator_document_route';

  final Requirement requirement;
  final KycCubit cubit;

  const IndicatorDocumentScreen({
    Key key,
    this.requirement,
    this.cubit,
  }) : super(key: key);

  @override
  _IndicatorDocumentScreenState createState() => _IndicatorDocumentScreenState();
}

class _IndicatorDocumentScreenState extends State<IndicatorDocumentScreen> {
  final TextEditingController _typeIdController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  IndicatorDocumentScreenStyle _style;
  String _imagePath;
  int _selectedIndex = -1;

  @override
  void initState() {
    _style = IndicatorDocumentScreenStyle.fromOldTheme(
      Provider.of<AppThemeOld>(context, listen: false),
    );

    final options = this
        .widget
        .requirement
        .elements[0]
        .options
        .where((element) => element.value == this.widget.requirement.elements[0].value)
        .toList();

    if (options.isNotEmpty) {
      final index =
          this.widget.requirement.elements[0].options.indexWhere((element) => element.value == options.first.value);
      setState(() {
        _selectedIndex = index;
      });
      _typeIdController.text = options.first.name;
    }

    _numberController.text = this.widget.requirement.elements[1].value;
    super.initState();
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
        if ((_imagePath == null && this.widget.requirement.elements[2].value == null) ||
            _selectedIndex == -1 ||
            _numberController.text == null) {
          return;
        }
        this.widget.cubit.updateRequirement(
              id: this.widget.requirement.id,
              requirement: RequirementRequest(
                values: [
                  ElementValue(
                    index: this.widget.requirement.elements[0].index,
                    value: this.widget.requirement.elements[0].options[_selectedIndex].value,
                  ),
                  ElementValue(
                    index: this.widget.requirement.elements[1].index,
                    value: _numberController.text,
                  ),
                  ElementValue(
                    index: this.widget.requirement.elements[2].index,
                    value: _imagePath ?? this.widget.requirement.elements[2].value,
                  ),
                ],
              ),
            );
        Navigator.of(context).pop();
      },
    );
  }

  Widget _renderDocumentTypeField() {
    final theme = Provider.of<AppThemeOld>(context);

    return Stack(
      children: <Widget>[
        TextFormField(
          controller: _typeIdController,
          enabled: false,
          style: TextStyle(
            color: theme.colors.darkShade,
          ),
          decoration: InputDecoration(
            suffixIcon: IconButton(
              padding: const EdgeInsets.all(0),
              alignment: Alignment.bottomCenter,
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: theme.colors.midShade,
              ),
              onPressed: () {},
            ),
            labelText: AppStrings.TYPE_OF_DOCUMENT.tr(),
          ),
        ),
        CupertinoButton(
          onPressed: () {
            Navigator.of(context).pushNamed(
              ListTypesScreen.LIST_TYPES_ROUTE,
              arguments: ListTypesScreenObject(
                  types: this.widget.requirement.elements.first.options,
                  selectedIndex: _selectedIndex,
                  onPressed: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                    _typeIdController.text = this.widget.requirement.elements.first.options[index].name;
                  }),
            );
          },
          child: Container(),
        )
      ],
    );
  }

  Widget _renderNumberId(BuildContext context) {
    final theme = Provider.of<AppThemeOld>(context);

    return TextFormField(
      controller: _numberController,
      style: TextStyle(
        color: theme.colors.darkShade,
      ),
      decoration: InputDecoration(
        labelText: KYCStrings.ID_NUMBER.tr(),
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget _renderPhotoField() {
    final theme = Provider.of<AppThemeOld>(context);
    final bytes = this.widget.requirement.elements.last.bytes;

    return Container(
      height: 56,
      child: Row(
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: theme.colors.lightShade,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: _imagePath == null
                  ? (bytes == null
                      ? SvgPicture.asset(IconsSVG.camera)
                      : ClipOval(
                          child: Image.memory(
                            bytes,
                            fit: BoxFit.cover,
                            width: 40,
                            height: 40,
                          ),
                        ))
                  : ClipOval(
                      child: Image.file(
                        File(_imagePath),
                        fit: BoxFit.cover,
                        width: 40,
                        height: 40,
                      ),
                    ),
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 18,
                ),
                CupertinoButton(
                  onPressed: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    final act = CupertinoActionSheet(
                        actions: <Widget>[
                          CupertinoActionSheetAction(
                            child: Text(
                              KYCStrings.SELECT_FROM_GALERY.tr(),
                              style: _style.actionSheetButtonStyle,
                            ),
                            onPressed: () async {
                              Navigator.of(context).pop();

                              final pickedFile = await ImagePicker().getImage(
                                source: ImageSource.gallery,
                                imageQuality: 100,
                              );
                              Navigator.of(context).pushNamed(
                                DocumentPreviewScreen.ROUTE,
                                arguments: DocumentPreviewObject(
                                  path: pickedFile.path,
                                  title: KYCStrings.ID_NATIONAL.tr(),
                                  onPressed: () {
                                    setState(() {
                                      _imagePath = pickedFile.path;
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                          CupertinoActionSheetAction(
                            child: Text(
                              KYCStrings.TAKE_SHOT.tr(),
                              style: _style.actionSheetButtonStyle,
                            ),
                            onPressed: () async {
                              Navigator.of(context).pop();
                              final pickedFile = await ImagePicker().getImage(
                                source: ImageSource.camera,
                                imageQuality: 100,
                              );
                              Navigator.of(context).pushNamed(
                                DocumentPreviewScreen.ROUTE,
                                arguments: DocumentPreviewObject(
                                  path: pickedFile.path,
                                  title: KYCStrings.ID_NATIONAL.tr(),
                                  onPressed: () {
                                    setState(() {
                                      _imagePath = pickedFile.path;
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                        cancelButton: CupertinoActionSheetAction(
                          child: Text(
                            AppStrings.CANCEL.tr(),
                            style: _style.cancelActionSheetButtonStyle,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ));
                    showCupertinoModalPopup(
                      context: context,
                      builder: (BuildContext context) => act,
                    );
                  },
                  minSize: 0,
                  padding: EdgeInsets.zero,
                  child: Text(
                    _imagePath == null && bytes?.isEmpty == true
                        ? KYCStrings.ADD_DOCUMENT_PHOTO.tr()
                        : KYCStrings.CHANGE_DOCUMENT_PHOTO.tr(),
                    style: _style.saveButtonStyle,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 1,
                  color: theme.colors.lightShade,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                KYCStrings.IDENTIFICATION_DOCUMENT.tr(),
                style: _style.headerTextStyle,
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                KYCStrings.IDENTIFICATION_DOCUMENT_NOTE.tr(),
                style: _style.noteTextStyle,
              ),
              const SizedBox(
                height: 30,
              ),
              _renderDocumentTypeField(),
              const SizedBox(
                height: 8,
              ),
              if (_selectedIndex == -1)
                Container()
              else
                Column(
                  children: <Widget>[
                    _renderNumberId(context),
                    const SizedBox(
                      height: 8,
                    ),
                    _renderPhotoField(),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

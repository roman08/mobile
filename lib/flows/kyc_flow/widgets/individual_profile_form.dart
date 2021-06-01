import 'package:Velmie/common/widgets/app_buttons/button.dart';
import 'package:Velmie/common/widgets/select.dart';
import 'package:Velmie/flows/kyc_flow/models/individual_customer_profile.dart';
import 'package:Velmie/flows/kyc_flow/models/requirement_request.dart';
import 'package:Velmie/flows/kyc_flow/models/tiers_result.dart';
import 'package:Velmie/flows/kyc_flow/screens/affidavit_screen.dart';
import 'package:Velmie/flows/kyc_flow/widgets/document_field.dart';
import 'package:Velmie/flows/kyc_flow/widgets/form_section_title.dart';
import 'package:Velmie/flows/sign_up_flow/screens/signature_screen.dart';
import 'package:Velmie/flows/transfer_money/enities/common/country_entity.dart';
import 'package:Velmie/resources/colors/app_colors.dart';
import 'package:Velmie/resources/icons/icons_svg.dart';
import 'package:Velmie/resources/strings/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'document_fields_group.dart';
import 'package:Velmie/app.dart';

class IndividualProfileForm extends StatefulWidget {
  final IndividualCustomerProfile formData;
  final bool excludeFilled;
  final List<CountryEntity> countries;
  final Function(List<RequirementRequest> requirements) onSubmit;
  final Function(RequirementRequest requirement) onDocumentChange;
  final Function onExternalUpdate;

  const IndividualProfileForm({
    @required this.formData,
    this.excludeFilled = false,
    this.countries = const [],
    this.onSubmit,
    this.onExternalUpdate,
    this.onDocumentChange,
  }) : assert(formData != null);

  @override
  _IndividualProfileFormState createState() => _IndividualProfileFormState();
}

class _IndividualProfileFormState extends State<IndividualProfileForm> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  String gender;
  String countryOfBirth;
  bool submitAvailable = false;

  @override
  void initState() {
    countryOfBirth = widget.formData.countryOfBirth;
    gender = getGenderFromValue(widget.formData.gender);
        logger.d('AQUI VAN LOS DATOS DEL PERFIL');
        logger.d(widget.formData.name);

    Future.microtask(() {
      _formKey.currentState.fields['name']?.currentState?.didChange(widget.formData.name);
      _formKey.currentState.fields['fathersSurname']?.currentState?.didChange(widget.formData.fathersSurname);
      _formKey.currentState.fields['mothersSurname']?.currentState?.didChange(widget.formData.mothersSurname);
      _formKey.currentState.fields['birthday']?.currentState?.didChange(widget.formData.birthday);
      _formKey.currentState.fields['nationality']?.currentState?.didChange(widget.formData.nationality);
      _formKey.currentState.fields['phone']?.currentState?.didChange(widget.formData.phone);
      _formKey.currentState.fields['email']?.currentState?.didChange(widget.formData.email);
      _formKey.currentState.fields['homeAddress']?.currentState?.didChange(widget.formData.address);
      _formKey.currentState.fields['taxIdNumber']?.currentState?.didChange(widget.formData.taxIdNumber);
      _formKey.currentState.fields['accountNumber'].currentState.didChange(widget.formData.accountNumber);
      _formKey.currentState.fields['bankName'].currentState.didChange(widget.formData.bankName);
      _formKey.currentState.fields['bankAddress'].currentState.didChange(widget.formData.bankAddress);
        logger.d('AQUI VAN LOS DATOS DEL PERFIL 2');
        logger.d(widget.formData.email);
      validate();
    });

    super.initState();
  }

  String getGenderFromValue(String genderValue) {
    switch (genderValue) {
      case 'male':
        return AppStrings.MALE.tr();
      case 'female':
        return AppStrings.FEMALE.tr();
      case 'not_answer':
        return AppStrings.NOT_ANSWER.tr();
      default:
        return AppStrings.NOT_ANSWER.tr();
    }
  }

  void validate() {
    print('validate!!');
    if (!_formKey.currentState.validate()) {
      print('invalid form!!');
      print(_formKey.currentState.fields['name'].currentState.isValid);
      print(_formKey.currentState.fields['fathersSurname'].currentState.isValid);
      print(_formKey.currentState.fields['mothersSurname'].currentState.isValid);
      print(_formKey.currentState.fields['birthday'].currentState.isValid);
      print(_formKey.currentState.fields['nationality'].currentState.isValid);
      print(_formKey.currentState.fields['phone'].currentState.isValid);
      print(_formKey.currentState.fields['email'].currentState.isValid);
      print(_formKey.currentState.fields['homeAddress'].currentState.isValid);
      print(_formKey.currentState.fields['taxIdNumber'].currentState.isValid);
      print(_formKey.currentState.fields['accountNumber'].currentState.isValid);
      print(_formKey.currentState.fields['bankName'].currentState.isValid);
      print(_formKey.currentState.fields['bankAddress'].currentState.isValid);
      setState(() => submitAvailable = false);
      return;
    }

    if (widget.formData.idFront.isEmpty ||
        gender.isEmpty ||
        countryOfBirth.isEmpty ||
        widget.formData.selfie.isEmpty ||
        widget.formData.proofPermanentAddress.isEmpty) {
      print('invalid controls!!');
      print(widget.formData.idFront.isEmpty);
      print(gender.isEmpty);
      print(countryOfBirth.isEmpty);
      print(widget.formData.selfie.isEmpty);
      print(widget.formData.proofPermanentAddress.isEmpty);
      print(widget.formData.termsAndConditions.isEmpty);
      setState(() => submitAvailable = false);
      return;
    }

    print('valid!!');
    setState(() => submitAvailable = true);
  }

  void submit() {
    final fields = _formKey.currentState.fields;
    final requirements = [
      if (!widget.excludeFilled)
        RequirementRequest(
          id: 50,
          values: [ElementValue(value: fields['homeAddress'].currentState.value, index: ElementIndex.address)],
        ),
      if (!widget.excludeFilled)
        RequirementRequest(
          id: 51,
          values: [ElementValue(value: fields['taxIdNumber'].currentState.value, index: ElementIndex.taxIdNumber)],
        ),
      RequirementRequest(
        id: 61,
        values: [
          ElementValue(value: fields['accountNumber'].currentState.value, index: ElementIndex.accountNumber),
          ElementValue(value: fields['bankName'].currentState.value, index: ElementIndex.bankName),
          ElementValue(value: fields['bankAddress'].currentState.value, index: ElementIndex.address),
        ],
      ),
      RequirementRequest(
        id: 76,
        values: [ElementValue(value: countryOfBirth, index: ElementIndex.countryOfBirth)],
      ),
      RequirementRequest(
        id: 46,
        values: [ElementValue(value: gender, index: ElementIndex.gender)],
      ),
    ];

    widget.onSubmit?.call(requirements);
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FormSectionTitle(title: AppStrings.REQUESTED_INFORMATION.tr()),
          if (!widget.excludeFilled)
            Column(
              children: [
                _formField('name', AppStrings.NAME.tr(), disabled: true, required: true),
                _formField('fathersSurname', AppStrings.FATHERS_SURNAME.tr(), disabled: true, required: true),
                _formField('mothersSurname', AppStrings.MOTHERS_SURNAME.tr(), disabled: true, required: true),
                _formField('birthday', AppStrings.BIRTHDAY.tr(), disabled: true, required: true),
                Select(
                  label: AppStrings.GENDER.tr() + ' *',
                  placeholder: AppStrings.GENDER.tr() + ' *',
                  options: [
                    SelectItem(title: AppStrings.MALE.tr()),
                    SelectItem(title: AppStrings.FEMALE.tr()),
                    SelectItem(title: AppStrings.NOT_ANSWER.tr()),
                  ],
                  onChange: (value) {
                    setState(() => gender = value);
                    validate();
                  },
                  value: gender,
                ),
                SizedBox(height: 8.h),
                Select(
                  label: AppStrings.COUNTRY_OF_BIRTH.tr() + ' *',
                  placeholder: AppStrings.COUNTRY_OF_BIRTH.tr() + ' *',
                  options: widget.countries.map((country) => SelectItem(title: country.code3)).toList(),
                  onChange: (value) {
                    setState(() => countryOfBirth = value);
                    validate();
                  },
                  value: countryOfBirth,
                ),
                _formField('nationality', AppStrings.NATIONALITY.tr(), disabled: true, required: true),
                _formField('phone', AppStrings.PHONE.tr(), disabled: true),
                _formField('email', AppStrings.EMAIL_ADDRESS.tr(), disabled: true),
                _formField('homeAddress', AppStrings.COMPLETE_HOME_ADDRESS.tr(), required: true),
                _formField('taxIdNumber', AppStrings.TAX_ID_NUMBER.tr(), required: true),
              ],
            ),
          _formField(
            'accountNumber',
            AppStrings.ACCOUNT_NUMBER.tr(),
            validators: [
              FormBuilderValidators.maxLength(18),
            ],
          ),
          _formField(
            'bankName',
            AppStrings.NAME_OF_THE_BANK.tr(),
            validators: [
              FormBuilderValidators.maxLength(255),
            ],
          ),
          _formField(
            'bankAddress',
            AppStrings.BANK_BRANCH_ADDRESS.tr(),
            validators: [
              FormBuilderValidators.maxLength(255),
            ],
          ),
          SizedBox(height: 20.h),
          FormSectionTitle(title: AppStrings.REQUESTED_DOCUMENTS.tr()),
          SizedBox(height: 10.h),
          if (!widget.excludeFilled)
            DocumentFieldsGroup(
              title: AppStrings.OFFICIAL_ID.tr(),
              frontId: widget.formData.idFront,
              backId: widget.formData.idBack,
              selfieId: widget.formData.selfie,
              disabled: widget.formData.idFront.isNotEmpty && widget.formData.selfie.isNotEmpty,
              onSubmit: (idFront, idBack, selfie) {
                widget.onDocumentChange?.call(RequirementRequest(
                  id: 64,
                  values: [
                    ElementValue(index: ElementIndex.idFront, value: idFront),
                    ElementValue(index: ElementIndex.idBack, value: idBack),
                    ElementValue(index: ElementIndex.selfiePhoto, value: selfie),
                  ],
                ));
              },
            ),
          if (!widget.excludeFilled)
            DocumentField(
              title: AppStrings.PROOF_OF_PERMANENT_ADDRESS.tr() + ' *',
              fileId: widget.formData.proofPermanentAddress,
              disabled: widget.formData.proofPermanentAddress.isNotEmpty,
              onDocumentChange: (path) => widget.onDocumentChange?.call(
                RequirementRequest(
                  id: 70,
                  values: [ElementValue(index: ElementIndex.proofPermanentAddress, value: path)],
                ),
              ),
            ),
          DocumentField(
            title: AppStrings.PROOF_OF_TAX_ID_NUMBER.tr() + '*',
            fileId: widget.formData.proofTaxId,
            onDocumentChange: (path) => widget.onDocumentChange?.call(
              RequirementRequest(
                id: 67,
                values: [ElementValue(index: ElementIndex.proofTaxIdNumber, value: path)],
              ),
            ),
          ),
          DocumentField(
            title: AppStrings.PROOF_OF_INCOME_STATEMENT.tr() + '*',
            fileId: widget.formData.proofIncomeStatement,
            onDocumentChange: (path) => widget.onDocumentChange?.call(
              RequirementRequest(
                id: 72,
                values: [ElementValue(index: ElementIndex.proofIncomeStatement, value: path)],
              ),
            ),
          ),
          DocumentField(
            title: AppStrings.LAST_BANK_ACCOUNT_STATEMENT.tr() + '*',
            fileId: widget.formData.lastBankAccountStatement,
            onDocumentChange: (path) => widget.onDocumentChange?.call(
              RequirementRequest(
                id: 73,
                values: [ElementValue(index: ElementIndex.lastBankAccountStatement, value: path)],
              ),
            ),
          ),
          _affidavitScreenButton(),
          if (widget.formData.termsAndConditions.isEmpty) SizedBox(height: 30.h),
          if (widget.formData.termsAndConditions.isEmpty)
            Button(
              title: AppStrings.SIGN_HERE.tr(),
              onPressed: widget.formData.name.isNotEmpty && widget.formData.fathersSurname.isNotEmpty
                  ? () => Get.to(SignatureScreen(onDone: () => Get.close(2)))
                  : null,
            ),
          SizedBox(height: 30.h),
          Button(
            title: AppStrings.SEND.tr(),
            onPressed: submitAvailable ? () => submit() : null,
          ),
        ],
      ),
    );
  }

  Widget _formField(
    String attribute,
    String label, {
    bool required = false,
    int maxLines = 1,
    List<FormFieldValidator> validators = const [],
    bool disabled = false,
  }) {
    return FormBuilderTextField(
      readOnly: disabled,
      attribute: attribute,
      maxLines: maxLines,
      style: TextStyle(color: disabled ? AppColors.primaryText.withOpacity(.7) : AppColors.primaryText),
      decoration: InputDecoration(
        labelText: label + '${required ? ' *' : ''}',
        labelStyle: TextStyle(
          fontSize: 14.ssp,
          color: disabled ? AppColors.secondaryText : AppColors.primaryText,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryText),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryText),
        ),
        errorStyle: const TextStyle(fontSize: 0, height: 0),
      ),
      onChanged: (value) => validate(),
      validators: !disabled && required
          ? [
              FormBuilderValidators.required(errorText: ErrorStrings.FIELD_IS_REQUIRED.tr()),
              ...validators,
            ]
          : validators,
    );
  }

  Widget _affidavitScreenButton() {
    return GestureDetector(
      onTap: () {
        Get.to(AffidavitScreen(affidavit: widget.formData.affidavit)).then((load) {
          if (load != null && load) {
            widget.onExternalUpdate?.call();
          }
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              AppStrings.AFFIDAVIT.tr() + '*',
              style: TextStyle(
                color: AppColors.primaryText,
                fontSize: 15.ssp,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: SvgPicture.asset(IconsSVG.arrowRightIOSStyle),
          ),
        ],
      ),
    );
  }
}

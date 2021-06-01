import 'package:Velmie/common/widgets/app_buttons/button.dart';
import 'package:Velmie/common/widgets/select.dart';
import 'package:Velmie/flows/kyc_flow/models/corporate_customer_profile.dart';
import 'package:Velmie/flows/kyc_flow/models/requirement_request.dart';
import 'package:Velmie/flows/kyc_flow/models/tiers_result.dart';
import 'package:Velmie/flows/kyc_flow/screens/affidavit_screen.dart';
import 'package:Velmie/flows/kyc_flow/widgets/document_field.dart';
import 'package:Velmie/flows/kyc_flow/widgets/document_fields_group.dart';
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

class CorporateProfileForm extends StatefulWidget {
  final CorporateCustomerProfile formData;
  final bool excludeFilled;
  final Function(List<RequirementRequest> requirements) onSubmit;
  final Function(RequirementRequest requirement) onDocumentChange;
  final List<CountryEntity> countries;
  final Function onExternalUpdate;

  const CorporateProfileForm({
    @required this.formData,
    this.excludeFilled = false,
    this.onSubmit,
    this.onExternalUpdate,
    this.onDocumentChange,
    this.countries = const [],
  }) : assert(formData != null);

  @override
  _CorporateProfileFormState createState() => _CorporateProfileFormState();
}

class _CorporateProfileFormState extends State<CorporateProfileForm> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  String nationality;
  bool submitAvailable = false;
  DateTime date;

  @override
  void initState() {
    nationality = widget.formData.nationality;
    date = widget.formData.incorporateDate.isNotEmpty ? DateTime.parse(widget.formData.incorporateDate) : null;

    Future.microtask(() {
      _formKey.currentState.fields['companyName']?.currentState?.didChange(widget.formData.companyName);
      _formKey.currentState.fields['sourceOfFunds'].currentState.didChange(widget.formData.sourceOfFunds);
      _formKey.currentState.fields['taxIdNumber']?.currentState?.didChange(widget.formData.taxIdNumber);
      _formKey.currentState.fields['companyAddress']?.currentState?.didChange(widget.formData.address);
      _formKey.currentState.fields['phone']?.currentState?.didChange(widget.formData.phone);
      _formKey.currentState.fields['email']?.currentState?.didChange(widget.formData.email);
      _formKey.currentState.fields['incorporateDate']?.currentState?.didChange(date);
      _formKey.currentState.fields['website']?.currentState?.didChange(widget.formData.website);
      _formKey.currentState.fields['representativeName']?.currentState
          ?.didChange(widget.formData.legalRepresentativeName);
      _formKey.currentState.fields['representativeAddress']?.currentState
          ?.didChange(widget.formData.legalRepresentativeAddress);
      _formKey.currentState.fields['accountNumber']?.currentState?.didChange(widget.formData.accountNumber);
      _formKey.currentState.fields['bankName']?.currentState?.didChange(widget.formData.bankName);
      _formKey.currentState.fields['bankAddress']?.currentState?.didChange(widget.formData.bankAddress);

      validate();
    });

    super.initState();
  }

  void validate() {
    if (!_formKey.currentState.validate()) {
      setState(() => submitAvailable = false);
      return;
    }

    if (widget.formData.idFront.isEmpty ||
        widget.formData.selfie.isEmpty ||
        nationality.isEmpty ||
        date == null ||
        widget.formData.proofCompanyPermanentAddress.isEmpty ||
        widget.formData.termsAndConditions.isEmpty) {
      setState(() => submitAvailable = false);
      return;
    }

    setState(() => submitAvailable = true);
  }

  void submit() {
    final fields = _formKey.currentState.fields;
    final requirements = [
      RequirementRequest(
        id: 47,
        values: [ElementValue(value: nationality, index: ElementIndex.nationality)],
      ),
      RequirementRequest(
        id: 53,
        values: [
          ElementValue(value: fields['sourceOfFunds'].currentState.value, index: ElementIndex.sourceOfFundsCompany)
        ],
      ),
      RequirementRequest(
        id: 51,
        values: [ElementValue(value: fields['taxIdNumber'].currentState.value, index: ElementIndex.taxIdNumber)],
      ),
      RequirementRequest(
        id: 56,
        values: [
          ElementValue(
            value: fields['incorporateDate'].currentState.value.toString(),
            index: ElementIndex.companyDateIncorporated,
          )
        ],
      ),
      RequirementRequest(
        id: 54,
        values: [ElementValue(value: fields['website'].currentState.value, index: ElementIndex.website)],
      ),
      if (fields['representativeAddress'] != null)
        RequirementRequest(
          id: 60,
          values: [
            ElementValue(value: fields['representativeAddress'].currentState.value, index: ElementIndex.address)
          ],
        ),
      RequirementRequest(
        id: 61,
        values: [
          ElementValue(value: fields['accountNumber'].currentState.value, index: ElementIndex.accountNumber),
          ElementValue(value: fields['bankName'].currentState.value, index: ElementIndex.bankName),
          ElementValue(value: fields['bankAddress'].currentState.value, index: ElementIndex.address),
        ],
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
          if (!widget.excludeFilled) _formField('companyName', AppStrings.COMPANY_NAME.tr(), disabled: true),
          _formField('sourceOfFunds', AppStrings.YOUR_SOURCE_FUNDS.tr(), required: true),
          SizedBox(height: 8.h),
          Select(
            label: AppStrings.NATIONALITY.tr() + ' *',
            placeholder: 'Select your nationality',
            options: widget.countries.map((country) => SelectItem(title: country.code3)).toList(),
            onChange: (value) {
              setState(() => nationality = value);
              validate();
            },
            value: nationality,
          ),
          _formField('taxIdNumber', AppStrings.TAX_ID_NUMBER.tr(), required: true),
          if (!widget.excludeFilled)
            _formField('companyAddress', AppStrings.COMPANY_ADDRESS_STREET_AND_NUMBER.tr(), disabled: true),
          if (!widget.excludeFilled) _formField('phone', AppStrings.COMPANY_PHONE_NUMBER.tr(), disabled: true),
          if (!widget.excludeFilled) _formField('email', AppStrings.EMAIL_ADDRESS.tr(), disabled: true),
          FormBuilderDateTimePicker(
              decoration: InputDecoration(
                labelText: AppStrings.DATE_OF_COMPANY_INCORPORATED.tr() + ' *',
                labelStyle: const TextStyle(color: AppColors.primaryText),
              ),
              attribute: 'incorporateDate',
              inputType: InputType.date,
              initialValue: date,
              format: DateFormat('yyyy-MM-dd'),
              onChanged: (value) {
                date = value;
                validate();
              }),
          _formField('website', AppStrings.COMPANY_WEBSITE.tr(), required: false, validators: [
            FormBuilderValidators.maxLength(255),
          ]),
          if (!widget.excludeFilled)
            _formField(
              'representativeName',
              AppStrings.LEGAL_REPRESENTATIVE_NAME.tr(),
              disabled: true,
            ),
          if (!widget.excludeFilled)
            _formField(
              'representativeAddress',
              AppStrings.ADDRESS_OF_THE_REPRESENTATIVE.tr(),
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
            AppStrings.ADDRESS.tr(),
            validators: [
              FormBuilderValidators.maxLength(255),
            ],
          ),
          SizedBox(height: 20.h),
          FormSectionTitle(title: AppStrings.REQUESTED_DOCUMENTS.tr()),
          SizedBox(height: 10.h),
          if (!widget.excludeFilled)
            DocumentFieldsGroup(
              title: AppStrings.OFFICIAL_ID_OF_THE_REPRESENTATIVE.tr(),
              frontId: widget.formData.idFront,
              backId: widget.formData.idBack,
              selfieId: widget.formData.selfie,
              disabled: widget.formData.idFront.isNotEmpty && widget.formData.selfie.isNotEmpty,
              onSubmit: (idFront, idBack, selfie) {
                widget.onDocumentChange?.call(RequirementRequest(
                  id: 65,
                  values: [
                    ElementValue(index: ElementIndex.idFront, value: idFront),
                    ElementValue(index: ElementIndex.idBack, value: idBack),
                    ElementValue(index: ElementIndex.selfiePhoto, value: selfie),
                  ],
                ));
              },
            ),
          DocumentField(
            title: AppStrings.ARTICLES_OF_INCORPORATION.tr(),
            fileId: widget.formData.articleIncorporation,
            onDocumentChange: (path) => widget.onDocumentChange?.call(RequirementRequest(
              id: 66,
              values: [ElementValue(index: ElementIndex.articleIncorporation, value: path)],
            )),
          ),
          if (!widget.excludeFilled)
            DocumentField(
              title: AppStrings.PROOF_OF_PERMANENT_ADDRESS_FOR_THE_COMPANY.tr() + ' *',
              fileId: widget.formData.proofCompanyPermanentAddress,
              disabled: widget.formData.proofCompanyPermanentAddress.isNotEmpty,
              onDocumentChange: (path) => widget.onDocumentChange?.call(RequirementRequest(
                id: 69,
                values: [ElementValue(index: ElementIndex.proofPermanentAddressCompany, value: path)],
              )),
            ),
          DocumentField(
            title: AppStrings.LEGAL_PROOF_OF_TAX_ID_NUMBER.tr() + ' *',
            fileId: widget.formData.proofTaxId,
            onDocumentChange: (path) => widget.onDocumentChange?.call(RequirementRequest(
              id: 67,
              values: [ElementValue(index: ElementIndex.proofTaxIdNumber, value: path)],
            )),
          ),
          DocumentField(
            title: AppStrings.AFFIDAVIT_PROVIDING_DETAILED_ACCOUNT.tr(),
            fileId: widget.formData.accountAffidavit,
            onDocumentChange: (path) => widget.onDocumentChange?.call(RequirementRequest(
              id: 71,
              values: [ElementValue(index: ElementIndex.affidavitAccount, value: path)],
            )),
          ),
          DocumentField(
            title: AppStrings.PROOF_OF_INCOME_STATEMENT.tr() + ' *',
            fileId: widget.formData.proofIncomeStatement,
            onDocumentChange: (path) => widget.onDocumentChange?.call(RequirementRequest(
              id: 72,
              values: [ElementValue(index: ElementIndex.proofIncomeStatement, value: path)],
            )),
          ),
          DocumentField(
            title: AppStrings.LAST_BANK_ACCOUNT_STATEMENT.tr() + ' *',
            fileId: widget.formData.lastBankAccountStatement,
            onDocumentChange: (path) => widget.onDocumentChange?.call(RequirementRequest(
              id: 73,
              values: [ElementValue(index: ElementIndex.lastBankAccountStatement, value: path)],
            )),
          ),
          DocumentField(
            title: AppStrings.PROOF_OF_ADDRESS.tr(),
            fileId: widget.formData.proofPermanentAddressRepresentative,
            onDocumentChange: (path) => widget.onDocumentChange?.call(RequirementRequest(
              id: 68,
              values: [ElementValue(index: ElementIndex.proofPermanentAddressRepresentative, value: path)],
            )),
          ),
          DocumentField(
            title: AppStrings.OFFICIAL_ID_BENEFICIAL_OWNERS.tr(),
            fileId: widget.formData.beneficialId,
            onDocumentChange: (path) => widget.onDocumentChange?.call(RequirementRequest(
              id: 62,
              values: [ElementValue(index: ElementIndex.beneficialOfficialId, value: path)],
            )),
          ),
          DocumentField(
            title: AppStrings.PROOF_OF_PERMANENT_ADDRESS_BENEFICIAL_OWNERS.tr(),
            fileId: widget.formData.beneficialProofPermanentAddress,
            onDocumentChange: (path) => widget.onDocumentChange?.call(RequirementRequest(
              id: 63,
              values: [ElementValue(index: ElementIndex.beneficialProofPermanentAddress, value: path)],
            )),
          ),
          DocumentField(
            title: AppStrings.QUESTIONNAIRE_OF_ORIGIN_AND_DESTINATION_OF_FUNDS.tr(),
            fileId: widget.formData.questionnaire,
            onDocumentChange: (path) => widget.onDocumentChange?.call(RequirementRequest(
              id: 75,
              values: [ElementValue(index: ElementIndex.questionnaire, value: path)],
            )),
          ),
          _affidavitScreenButton(),
          if (widget.formData.termsAndConditions.isEmpty) SizedBox(height: 30.h),
          if (widget.formData.termsAndConditions.isEmpty)
            Button(
              title: AppStrings.SIGN_HERE.tr(),
              onPressed: widget.formData.legalRepresentativeName.isNotEmpty
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
      attribute: attribute,
      maxLines: maxLines,
      readOnly: disabled,
      onChanged: (value) => validate(),
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
      validators: required
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

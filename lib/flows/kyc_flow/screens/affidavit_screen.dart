import 'package:Velmie/common/widgets/app_bars/base_app_bar.dart';
import 'package:Velmie/common/widgets/app_buttons/button.dart';
import 'package:Velmie/common/widgets/info_widgets.dart';
import 'package:Velmie/common/widgets/loader/progress_loader.dart';
import 'package:Velmie/flows/kyc_flow/cubit/affidavit_cubit.dart';
import 'package:Velmie/flows/kyc_flow/models/affidavit.dart';
import 'package:Velmie/flows/kyc_flow/repository/kyc_repository.dart';
import 'package:Velmie/resources/colors/app_colors.dart';
import 'package:Velmie/resources/strings/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class AffidavitScreen extends StatefulWidget {
  final Affidavit affidavit;

  const AffidavitScreen({this.affidavit});

  @override
  _AffidavitScreenState createState() => _AffidavitScreenState();
}

class _AffidavitScreenState extends State<AffidavitScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController fullNameCtrl = TextEditingController();
  final TextEditingController otherFundsSourcesCtrl = TextEditingController();
  final TextEditingController addressCtrl = TextEditingController();
  final TextEditingController curpCtrl = TextEditingController();
  final TextEditingController nationalityCtrl = TextEditingController();
  final TextEditingController taxIdCtrl = TextEditingController();
  final TextEditingController dateCtrl = TextEditingController();
  final TextEditingController placeCtrl = TextEditingController();

  @override
  void initState() {
    final affidavit = widget.affidavit;
    if (affidavit != null) {
      fullNameCtrl.text = affidavit.fullName;
      otherFundsSourcesCtrl.text = affidavit.comment;
      addressCtrl.text = affidavit.address;
      curpCtrl.text = affidavit.curp;
      nationalityCtrl.text = affidavit.nationality;
      taxIdCtrl.text = affidavit.taxId;
      dateCtrl.text = affidavit.date == null || affidavit.date.isEmpty
          ? DateFormat('yyyy-MM-dd').format(DateTime.now())
          : affidavit.date;
      placeCtrl.text = affidavit.place;
    }

    super.initState();
  }

  String localizationStringFromOption(String option) => 'affidavit_$option';

  Widget _plainText(String text) => Text(text, style: TextStyle(fontSize: 14.ssp, color: AppColors.primaryText));

  String validatorRequired(String value) {
    if (value.isEmpty) {
      return ErrorStrings.FIELD_IS_REQUIRED.tr();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AffidavitCubit>(
      create: (context) => AffidavitCubit(
        context.read<KycRepository>(),
        affidavit: widget.affidavit,
      )..fundSourcesChanged(widget.affidavit.fundTypesList),
      child: Scaffold(
        appBar: BaseAppBar(titleString: AppStrings.AFFIDAVIT_SHORT.tr()),
        body: BlocConsumer<AffidavitCubit, AffidavitState>(
          listener: (context, state) {
            if (state.status == AffidavitStatus.success) {
              showToast(context, AppStrings.SUCCESS.tr());
              Get.back(result: true);
            }
            if (state.status == AffidavitStatus.error) {
              showToast(context, ErrorStrings.SOMETHING_WENT_WRONG.tr());
              Get.back();
            }
          },
          builder: (context, state) {
            if (state.status == AffidavitStatus.saving) {
              return Center(child: progressLoader());
            }

            return SingleChildScrollView(
              child: SafeArea(
                minimum: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          AppStrings.AFFIDAVIT_TITLE.tr(),
                          style: TextStyle(fontSize: 16.ssp, color: AppColors.primaryText),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        children: [
                          _plainText(AppStrings.AFFIDAVIT_ME.tr()),
                          Container(
                            width: 200.w,
                            child: TextFormField(
                              controller: fullNameCtrl,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              style: TextStyle(fontSize: 14.ssp, color: AppColors.primaryText),
                              decoration: InputDecoration(
                                hintText: AppStrings.AFFIDAVIT_ME_PLACEHOLDER.tr(),
                                hintStyle: TextStyle(fontSize: 14.ssp),
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
                              ),
                              validator: validatorRequired,
                            ),
                          ),
                          _plainText(','),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _plainText(AppStrings.AFFIDAVIT_TEXT_1.tr()),
                      const SizedBox(height: 12),
                      _plainText(AppStrings.AFFIDAVIT_SOURCES_DESCRIPTION.tr()),
                      const SizedBox(height: 12),
                      MultiSelectBottomSheetField(
                        buttonText: Text(
                          AppStrings.AFFIDAVIT_ACTIVITIES.tr(),
                          style: TextStyle(fontSize: 14.ssp, color: AppColors.primaryText),
                        ),
                        title: Text(
                          AppStrings.AFFIDAVIT_ACTIVITIES.tr(),
                          style: TextStyle(fontSize: 14.ssp, color: AppColors.primaryText),
                        ),
                        buttonIcon: const Icon(Icons.keyboard_arrow_down),
                        decoration: const BoxDecoration(),
                        selectedColor: AppColors.primary,
                        initialValue: state.fundSources,
                        validator: (_) => state.fundSources == null || state.fundSources.isEmpty
                              ? ErrorStrings.FIELD_IS_REQUIRED.tr()
                              : null,
                        autovalidateMode: AutovalidateMode.always,
                        items: widget.affidavit.fundTypesOptions
                            .map((option) => MultiSelectItem(option, localizationStringFromOption(option).tr()))
                            .toList(),
                        chipDisplay: MultiSelectChipDisplay(
                          items: state.fundSources
                                  ?.map((source) => MultiSelectItem(
                                        source,
                                        localizationStringFromOption(source).tr(),
                                      ))
                                  ?.toList() ??
                              [],
                          chipColor: AppColors.primary,
                          textStyle: TextStyle(fontSize: 12.ssp, color: AppColors.onPrimary),
                        ),
                        onConfirm: (List<dynamic> values) {
                          List<dynamic> options = values;
                          if (values.isNotEmpty && values.first.toString().isEmpty) {
                            options = values.sublist(1);
                          }
                          context.read<AffidavitCubit>().fundSourcesChanged(options);
                        },
                      ),
                      if (state.fundSourcesEnumerationRequired)
                        TextFormField(
                          controller: otherFundsSourcesCtrl,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          enabled: true,
                          style: TextStyle(fontSize: 14.ssp, color: AppColors.primaryText),
                          decoration: InputDecoration(
                            hintText: AppStrings.AFFIDAVIT_OTHERS.tr() + '*',
                            hintStyle: TextStyle(fontSize: 14.ssp),
                          ),
                          validator: state.fundSourcesEnumerationRequired ? validatorRequired : null,
                        ),
                      const SizedBox(height: 12),
                      _plainText(AppStrings.AFFIDAVIT_TEXT_2.tr()),
                      const SizedBox(height: 12),
                      _plainText(AppStrings.AFFIDAVIT_TEXT_3.tr()),
                      const SizedBox(height: 24),
                      Text(
                        AppStrings.AFFIDAVIT_PERSONAL_INFORMATION.tr(),
                        style: TextStyle(
                          fontSize: 14.ssp,
                          color: AppColors.primaryText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: fullNameCtrl,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        enabled: false,
                        style: TextStyle(fontSize: 14.ssp, color: AppColors.primaryText),
                        decoration: InputDecoration(
                          hintText: AppStrings.AFFIDAVIT_FULL_NAME.tr() + '*',
                          hintStyle: TextStyle(fontSize: 14.ssp),
                        ),
                        validator: validatorRequired,
                      ),
                      TextFormField(
                        controller: addressCtrl,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        style: TextStyle(fontSize: 14.ssp, color: AppColors.primaryText),
                        decoration: InputDecoration(
                          hintText: AppStrings.AFFIDAVIT_ADDRESS.tr() + '*',
                          hintStyle: TextStyle(fontSize: 14.ssp),
                        ),
                        validator: validatorRequired,
                      ),
                      TextFormField(
                        controller: curpCtrl,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        style: TextStyle(fontSize: 14.ssp, color: AppColors.primaryText),
                        decoration: InputDecoration(
                          hintText: AppStrings.AFFIDAVIT_CURP.tr() + '*',
                          hintStyle: TextStyle(fontSize: 14.ssp),
                        ),
                        validator: validatorRequired,
                      ),
                      TextFormField(
                        controller: nationalityCtrl,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        style: TextStyle(fontSize: 14.ssp, color: AppColors.primaryText),
                        decoration: InputDecoration(
                          hintText: AppStrings.AFFIDAVIT_NATIONALITY.tr() + '*',
                          hintStyle: TextStyle(fontSize: 14.ssp),
                        ),
                        validator: validatorRequired,
                      ),
                      TextFormField(
                        controller: taxIdCtrl,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        style: TextStyle(fontSize: 14.ssp, color: AppColors.primaryText),
                        decoration: InputDecoration(
                          hintText: AppStrings.AFFIDAVIT_TAX_ID.tr() + '*',
                          hintStyle: TextStyle(fontSize: 14.ssp),
                        ),
                        validator: validatorRequired,
                      ),
                      TextFormField(
                        controller: dateCtrl,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        enableInteractiveSelection: false,
                        showCursor: false,
                        onTap: () {
                          DatePicker.showDatePicker(
                            context,
                            onConfirm: (date) => dateCtrl.text = DateFormat('yyyy-MM-dd').format(date),
                            onChanged: (date) => dateCtrl.text = DateFormat('yyyy-MM-dd').format(date),
                            locale: LocaleType.es,
                          );
                        },
                        style: TextStyle(fontSize: 14.ssp, color: AppColors.primaryText),
                        decoration: InputDecoration(
                          hintText: AppStrings.AFFIDAVIT_DATE.tr() + '*',
                          hintStyle: TextStyle(fontSize: 14.ssp),
                        ),
                        validator: validatorRequired,
                      ),
                      TextFormField(
                        controller: placeCtrl,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        style: TextStyle(fontSize: 14.ssp, color: AppColors.primaryText),
                        decoration: InputDecoration(
                          hintText: AppStrings.AFFIDAVIT_PLACE.tr() + '*',
                          hintStyle: TextStyle(fontSize: 14.ssp),
                        ),
                        validator: validatorRequired,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Button(
                              title: AppStrings.CANCEL.tr(),
                              onPressed: () => Get.back(),
                            ),
                          ),
                          SizedBox(width: 24.w),
                          Expanded(
                            child: Button(
                              title: AppStrings.SAVE.tr(),
                              onPressed: () {
                                if (!_formKey.currentState.validate()) {
                                  return;
                                }

                                context.read<AffidavitCubit>().updateAffidavit(Affidavit(
                                      fullName: fullNameCtrl.text,
                                      comment: otherFundsSourcesCtrl.text,
                                      address: addressCtrl.text,
                                      curp: curpCtrl.text,
                                      fundTypes: state.fundSources.join('.'),
                                      nationality: nationalityCtrl.text,
                                      taxId: taxIdCtrl.text,
                                      date: dateCtrl.text.replaceAll('-', '/'),
                                      place: placeCtrl.text,
                                    ));
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

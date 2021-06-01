import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:Velmie/common/widgets/app_bars/base_app_bar.dart';
import '../../../resources/icons/icons_svg.dart';
import '../../../resources/strings/app_strings.dart';
import '../../../resources/themes/need_to_refactor_and_remove/app_colors_old.dart';
import '../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:Velmie/resources/colors/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:Velmie/common/widgets/app_buttons/button.dart';
import '../../../resources/themes/app_text_theme.dart';
import '../../../resources/colors/custom_color_scheme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Velmie/flows/sign_up_flow/cubit/sign_up_cubit.dart';
import 'package:Velmie/resources/errors/app_common_error.dart';
import 'package:Velmie/common/widgets/info_widgets.dart';



class CheckOutAllObject {
  final String path;

  CheckOutAllObject({this.path});
}


class CheckOutAllScreen extends StatefulWidget {
  final String countNumber;
  CheckOutAllScreen(
    {
      Key key,
      this.countNumber
    }
  ) : super(key: key);

  @override
  _CheckOutAllScreenState createState() => _CheckOutAllScreenState();
}

class _CheckOutAllScreenState extends State<CheckOutAllScreen> {
  final _form = GlobalKey<FormBuilderState>();
  String _chosenValue;
  bool submitAvailable = false;

  BaseAppBar _appBar() => BaseAppBar(
    titleString: AppStrings.CASH_OUT.tr(),
    titleColor: Colors.black,     
    leading:  CupertinoButton(
      padding: EdgeInsets.only(left: 8.w, right: 4.w),
      child: SvgPicture.asset(
        IconsSVG.cross,
        color:  Colors.black,
      ),
      onPressed:  () => Get.back(),
    ),
  );


  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
    
    
    listenWhen: (previous, current) =>
          previous.step != current.step || previous.proofOfResidenceErrorCode != current.proofOfResidenceErrorCode,
      listener: (context, state) {
        if (state.proofOfResidenceErrorCode != null) {
          print('Error al guardar');
          // showAlertDialog(
          //   context,
          //   title: AppStrings.ERROR.tr(),
          //   description: CommonErrors[state.proofOfResidenceErrorCode]?.tr() ?? ErrorStrings.SOMETHING_WENT_WRONG.tr(),
          //   onPress: () => Get.close(1),
          // );
        }
        if (state.step == SignUpStep.signature) {
          //   showAlertDialog(
          //     context,
          //     title: AppStrings.SUCCESS.tr(),
          //     description: AppStrings.SUCCESS_VOUCHER.tr(),
          //     onPress: () => Get.close(2),
          // );
           print('Exito al guardar los datos');
          // Get.to(SignatureScreen(
          //   onDone: () => Get.to(const PassCodeScreen(status: PassCodeStatus.signInCreate)),
          //   showSkipButton: true,
          // ));
        }
      },
      child: Scaffold(
       appBar: _appBar(),
       body:FormBuilder(
          key: _form,
      child: ListView(children: [
      
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
           
            Column(
              children: [
                 Padding(
             padding: const EdgeInsets.only(left: 15.0, right: 15.0),
             child: Text(AppStrings.CASH_OUT_TITLE.tr(), style: Get.textTheme.headline1Bold
            .copyWith(
              color: Get.theme.colorScheme.onBackground,
              fontWeight: FontWeight.w700,
              fontSize: 30.0),),
           ),
           Padding(
             padding: const EdgeInsets.only(left: 15.0, right: 15.0),
             child: Text(AppStrings.CASH_OUT_SUBTITLE.tr(), style: Get.textTheme.headline5
            .copyWith(color: Get.theme.colorScheme.midShade),),
           ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: _formField('titular', AppStrings.CASH_OUT_TITULAR.tr(), disabled: false, required: true),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: _formField('banco', AppStrings.CASH_OUT_BANCO.tr(), required: true),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: _formField('cuenta', AppStrings.CASH_OUT_CUENTA.tr(), required: true),
                ),
                Padding(
                  padding:const EdgeInsets.only( right: 15.0, top: 15.0) ,
                  child: _selectMoney(),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: _formField('cuanta_ext', 'CLABE INTERBANCARIA / SWIFT / ABA' ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: _formField('referencia', AppStrings.CASH_OUT_REFERENCIA.tr()),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: _circleInfo(),
                ),
                 Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Text(AppStrings.CASH_OUT_SALDO.tr() + '\$ 15,000.00 USD', style: Get.textTheme.headline5
            .copyWith(color: Get.theme.colorScheme.primary) ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 18.0, bottom: 10.0),
                  child: Container(
                    width: 304.0,
                    height: 45.0,
                     decoration: BoxDecoration(
                        color: Get.theme.colorScheme.primaryVariant,
                        shape: BoxShape.circle,
                      ),
                    child: Button(
                      title: AppStrings.SEND.tr(),
                      onPressed:  () {
                        
                        print(_form.currentState.fields['titular'].currentState.value);
                        print(_form.currentState.validate());
                          //   "userUid":"56c4bc5a-2d55-45a0-9c04-2111ec29cdb9",				
                          // "bankName":"Azteca",
                          // "accountNumber":"11223334455667788",
                          // "type":"CLABE",
                          // "referencesAdditional":"Nothings Else Mathers"
                        if(_form.currentState.validate()) {
                          context.read<SignUpCubit>().sendCashOut(
                            bankName:_form.currentState.fields['banco'].currentState.value,
                            accountNumber:_form.currentState.fields['cuenta'].currentState.value,
                            type: _chosenValue,
                            referencesAdditional:_form.currentState.fields['referencia'].currentState.value,
                            numberRef: _form.currentState.fields['cuanta_ext'].currentState.value ?? null,
                          );
                        }else {
                          showToast(context, 'Debe completar los campos requeridos');
                        }

                      },
                    ),
                  ),
                ), 
              ],
            ),
         

        ],
      ),
      ],)
      
      

    ),
    ),
    );
  }

  Widget _circleInfo() {
    return Container(
      child: Row(
            children: [
              Expanded(
                flex: 5,
                child:Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(AppStrings.CASH_OUT_INVERSION.tr(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 20.0),),
                ),
              ),
              Expanded(
                flex: 4,
                child:_formField('mount', '100,000', required: true),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text('USD', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 20.0),),
                ),
              ),
            ]
          
          // TableRow(
          //   children: [
          //     Text('Inversión mínima'),
          //   ]
          // ),
          // TableRow(
          //   children: [
          //     Text('USD', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 20.0),),
          //   ]
          // )
        
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
      style: TextStyle(color: disabled ? AppColors.primaryText.withOpacity(.3) : AppColors.primaryText),
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

  void validate() {
    print('validate!!');
    // if (!_formKey.currentState.validate()) {
    //   print('invalid form!!');
    //   print(_formKey.currentState.fields['name'].currentState.isValid);
    //   print(_formKey.currentState.fields['fathersSurname'].currentState.isValid);
    //   print(_formKey.currentState.fields['mothersSurname'].currentState.isValid);
    //   print(_formKey.currentState.fields['birthday'].currentState.isValid);
    //   print(_formKey.currentState.fields['nationality'].currentState.isValid);
    //   print(_formKey.currentState.fields['phone'].currentState.isValid);
    //   print(_formKey.currentState.fields['email'].currentState.isValid);
    //   print(_formKey.currentState.fields['homeAddress'].currentState.isValid);
    //   print(_formKey.currentState.fields['taxIdNumber'].currentState.isValid);
    //   print(_formKey.currentState.fields['accountNumber'].currentState.isValid);
    //   print(_formKey.currentState.fields['bankName'].currentState.isValid);
    //   print(_formKey.currentState.fields['bankAddress'].currentState.isValid);
    //   setState(() => submitAvailable = false);
    //   return;
    // }

    // if (widget.formData.idFront.isEmpty ||
    //     gender.isEmpty ||
    //     countryOfBirth.isEmpty ||
    //     widget.formData.selfie.isEmpty ||
    //     widget.formData.proofPermanentAddress.isEmpty) {
    //   print('invalid controls!!');
    //   print(widget.formData.idFront.isEmpty);
    //   print(gender.isEmpty);
    //   print(countryOfBirth.isEmpty);
    //   print(widget.formData.selfie.isEmpty);
    //   print(widget.formData.proofPermanentAddress.isEmpty);
    //   print(widget.formData.termsAndConditions.isEmpty);
    //   setState(() => submitAvailable = false);
    //   return;
    // }

    // print('valid!!');
    setState(() => submitAvailable = true);
  }




  Widget _selectMoney() {
    
    String _icon;
    return 
      Container(
        // padding: EdgeInsets.only(top: 20.0),
        // alignment: Alignment.centerLeft,

        child: Column(
          children: [
             Center(
        child: Container(
          width: 350.0,
          decoration: BoxDecoration(
            
            color: Colors.grey.withAlpha(50)
          ),
          // padding: const EdgeInsets.all(20.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<String>(
                value: _chosenValue,
                elevation: 12,
                style: TextStyle(color: Colors.red),
                icon: Icon(Icons.arrow_drop_down, color: Get.theme.colorScheme.primary,),
                iconSize: 35,
                underline: SizedBox(),
                items: <String>[
                  'CLABE',
                  'SWIFT',
                  'ABA',
                ].map<DropdownMenuItem<String>>((String value) {
 
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Row(children: [         
                      Text(value, style: TextStyle(color: Colors.black),),

                    ]),
                  );
                }).toList(),
                hint: Text(
                  "Seleccione el tipo de cuenta",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                onChanged: (String value) {
                  setState(() {
                    _chosenValue = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    
          ],
        ),
      );
  } 

}
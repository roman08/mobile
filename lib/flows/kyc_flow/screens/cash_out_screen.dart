import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:Velmie/resources/strings/app_strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Velmie/resources/colors/app_colors.dart';

import '../../../common/models/list/list_item_entity.dart';

import 'package:Velmie/common/widgets/app_bars/base_app_bar.dart';
import '../../../resources/icons/icons_svg.dart';
import '../../../resources/strings/app_strings.dart';
import '../../../resources/themes/need_to_refactor_and_remove/app_colors_old.dart';
import '../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';


import 'package:Velmie/common/widgets/app_buttons/button.dart';


import '../../products/screens/check_out_all_screen.dart';

import 'package:provider/provider.dart';
import 'package:Velmie/flows/dashboard_flow/bloc/dashboard_bloc.dart';
import 'package:Velmie/flows/dashboard_flow/entities/wallet_list_wrapper.dart';
import 'package:Velmie/common/widgets/info_widgets.dart';

class _CashOutScreenStyle {
  final TextStyle titleTextStyle;
  final TextStyle itemTitleStyle;
  final TextStyle itemTitleRedStyle;
  final TextStyle itemSubtitleStyle;
  final TextStyle usernameInitialsStyle;
  final TextStyle sheetActionTextStyle;
  final TextStyle sheetCancelTextStyle;
  final AppColorsOld colors;

  _CashOutScreenStyle({
    this.titleTextStyle,
    this.itemTitleStyle,
    this.itemTitleRedStyle,
    this.itemSubtitleStyle,
    this.usernameInitialsStyle,
    this.sheetActionTextStyle,
    this.sheetCancelTextStyle,
    this.colors,
  });

  factory _CashOutScreenStyle.fromOldTheme(AppThemeOld theme) {
    return _CashOutScreenStyle(
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

class CashOutScreen extends StatefulWidget {
  @override
  _CashOutScreenState createState() => _CashOutScreenState();
}

class _CashOutScreenState extends State<CashOutScreen> {
  final _CashOutScreenStyle _style = _CashOutScreenStyle.fromOldTheme(AppThemeOld.defaultTheme());
  String produtName;
  String countNumber;
  String icon;
  bool status = false;

  List<CheckBoxListTileModel> checkBoxListTileModel =
      CheckBoxListTileModel.getUsers();
  
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
    final bloc = Provider.of<DashboardBloc>(context);
    return new Scaffold(
      appBar: _appBar(),
      body: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
                    StreamBuilder<List<Wallet>>(
            stream: bloc.walletListObservable,
            builder: (context, snapshot) {
             
              if (snapshot.hasData) {
                return Column(
                  children: <Widget>[
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      child: Divider(
                        color: Colors.grey[500],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SingleChildScrollView(
                      child: Container(
                        height: 450,
                        child: ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            
                            switch (snapshot.data[index].description) {
                            case 'Evolve':
                                icon = IconsSVG.evolve;
                              break;
                            case 'Performance +':
                                icon = IconsSVG.performance;
                              break;
                            case 'Dynamic':
                                icon = IconsSVG.dynamics;
                              break;
                            default:
                          }
           
                            return new Card(
                              child: new Container(
                                padding: new EdgeInsets.all(10.0),
                                child: Column(
                                  children: <Widget>[
                                    new CheckboxListTile(
                                        activeColor: Colors.pink[300],
                                        dense: true,
                                        //font change
                                        title: new Text(
                                          snapshot.data[index].description,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.5),
                                        ),
                                        value: snapshot.data[index].isChecked,
                                        secondary: Container(
                                          width: 40,
                                          height: 40,
                                          margin: EdgeInsets.only(right: 14.w),
                                          decoration: BoxDecoration(color: AppColorsOld.defaultColors().brackgroundIcons, shape: BoxShape.circle),
                                          alignment: Alignment.center,
                    
                                          
                                          child: SvgPicture.asset(
                                            icon
                                          ),
                                        ),
                                        onChanged: (bool val) {
                                          countNumber = snapshot.data[index].number;
                                              setState(() {
                                                for (var i = 0; i < snapshot.data.length ; i++) {
                                                  snapshot.data[i].isChecked = false;
                                                }
                                                snapshot.data[index].isChecked = true;
                                                status = true;
                                              });
                                          // itemChange(val, index,countNumber, snapshot);
                                        })
                                  ],
                                ),
                              ),
                            );
                          }
                        ),
                      )
                    ),
                    // _walletSlider(context, snapshot.data),
                    // _sliderIndicator(snapshot.data),
                  ],
                );
              } else {
                // TODO: Better to use shimmering loading. Need to discuss with team
                // logger.i("Wallet list loading");
                return Text('Joalsd');
              }
            }
          ),
          Padding(
            padding: const EdgeInsets.only(top:8.0, bottom: 8.0),
            child: Button(
              title: 'Continuar',
              onPressed:  () {
                if (status) {
                  Get.to(CheckOutAllScreen(
                    countNumber:countNumber)
                  );
                } else {
                  showToast(context, 'Debe seleccinar una cuenta');
                }
                
              },
            ),
          ),
          ],
        ),
      ),
    ),

    );
  }

  void itemChange(bool val, int index, String countNumber, snapshot) {
    setState(() {

      print(countNumber);
      
      checkBoxListTileModel[0].isCheck = false;
      checkBoxListTileModel[1].isCheck = false;
      checkBoxListTileModel[2].isCheck = false;

      checkBoxListTileModel[index].isCheck = val;
    });
  }
}


class CheckBoxListTileModel {
  int userId;
  String img;
  String title;
  bool isCheck;

  CheckBoxListTileModel({this.userId, this.img, this.title, this.isCheck});

  static List<CheckBoxListTileModel> getUsers() {
    return <CheckBoxListTileModel>[
      CheckBoxListTileModel(
          userId: 1,
          img: IconsSVG.evolve,
          title: "Iversión Evolve",
          isCheck: false),
      CheckBoxListTileModel(
          userId: 2,
          img: IconsSVG.dynamics,
          title: "Iversión Dynamic",
          isCheck: false),
      CheckBoxListTileModel(
          userId: 3,
          img: IconsSVG.performance,
          title: "Iversión Performance+",
          isCheck: false),
    ];
  }
}
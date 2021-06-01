import 'package:Velmie/common/utils/ensure_localization_switched.dart';
// import 'package:Velmie/common/widgets/info_widgets.dart';
import 'package:Velmie/flows/dashboard_flow/cubit/investment_accounts_cubit.dart';
// import 'package:Velmie/resources/colors/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:Velmie/common/widgets/app_buttons/button.dart';

// import 'package:Velmie/flows/sign_up_flow/screens/id_documents_screen.dart';

// import '../../../common/widgets/app_bars/base_app_bar.dart';
// import '../../../common/widgets/loader/loading_header.dart';
import '../../../common/widgets/payments_method/entity/payment_method_entity.dart';
// import '../../../common/widgets/payments_method/payments_method.dart';
// import '../../../resources/colors/custom_color_scheme.dart';
import '../../../resources/icons/icons_svg.dart';
import '../../../resources/strings/app_strings.dart';
import '../../../resources/themes/need_to_refactor_and_remove/app_colors_old.dart';
import '../../../resources/themes/need_to_refactor_and_remove/app_text_styles_old.dart';
import '../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';
import '../../kyc_flow/cubit/kyc_cubit.dart';
import '../../kyc_flow/cubit/kyc_state.dart';
// import '../../kyc_flow/index.dart';
// import '../../transfer_money/request/request_money_screen.dart';
// import '../../transfer_money/send/send_money_screen.dart';
// import '../../../flows/kyc_flow/screens/send_voucher_screen.dart';

import '../../../resources/icons/icons_png.dart';
import '../../dashboard_flow/bloc/dashboard_bloc.dart';
import 'package:Velmie/common/widgets/info_widgets.dart';

class _EvolveScreenStyle {
  final TextStyle kycAlertTextStyle;
  final TextStyle kycAlertBoldTextStyle;
  final AppColorsOld colors;
  final AppTextStylesOld textStyles;

  _EvolveScreenStyle({
    this.kycAlertTextStyle,
    this.kycAlertBoldTextStyle,
    this.colors,
    this.textStyles,
  });

  factory _EvolveScreenStyle.fromOldTheme(AppThemeOld theme) {
    return _EvolveScreenStyle(
      colors: theme.colors,
      kycAlertTextStyle: theme.textStyles.r14.copyWith(color: theme.colors.white, fontWeight: FontWeight.bold),
      kycAlertBoldTextStyle: theme.textStyles.m14.copyWith(color: theme.colors.darkShade),
      textStyles: theme.textStyles,
    );
  }
}

class EvolveScreen extends StatefulWidget {

  void onRequest(BuildContext context, int conditionId, String currency) {
    context.read<InvestmentAccountsCubit>().requestAccount(
        optionId: conditionId,
        currency: currency,
    );
  }
  const EvolveScreen();

  @override
  EvolveScreenState createState() => EvolveScreenState();
}

class EvolveScreenState extends State<EvolveScreen> {
  DashboardBloc _dashboardBloc;
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  final _EvolveScreenStyle _style = _EvolveScreenStyle.fromOldTheme(AppThemeOld.defaultTheme());
  String _chosenValue;

  // @override
  // void initState() {
  //   super.initState();
  //   context.read<KycCubit>().fetch();
  //   context.read<InvestmentAccountsCubit>().init();
  //   // _dashboardBloc.loadWallets();
  //   // _dashboardBloc.getUserData();
  // }

  // void _onRefresh() async {
  //   context.read<KycCubit>().fetch();
  //   context.read<InvestmentAccountsCubit>().init();
  //   // _dashboardBloc.loadWallets();
  //   // _dashboardBloc.getUserData();
  //   _refreshController.refreshCompleted();
  //   _refreshController.loadComplete();
  // }

  @override
  Widget build(BuildContext context) {
    ensureLocalizationSwitched(context);

    final appTheme = Provider.of<AppThemeOld>(context, listen: false);
    return BlocListener<InvestmentAccountsCubit, InvestmentAccountsState>(
      
      listener: (context, state) {
        // if (state?.additionalKycRequired == true) {
        //   Get.to(const CustomerProfileScreen(excludeFilled: true));
        // }

        if (state?.acountEvolve == true) {
          showToast(context, AppStrings.INVESTMENT_ACCOUNT_REQUESTED.tr());
          Get.back();
        }
      },
      
      child:Scaffold(
        backgroundColor: appTheme.colors.brackgroundGeneral,
        appBar: _appBar(context),
        body: ListView(
          children: [
            _circleInfo(),
            _moneyInfo(),
            _detailSecction1(),
            _detailSecction2(),
            _selectMoney(),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: Button(
                title: 'Continue',
                onPressed:  () {
                  widget.onRequest(context, 1, _chosenValue);
                },
              ),
            ),
          ],
        ),
      )
    );
  }

  Widget _appBar(BuildContext context) {   return
    AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: SvgPicture.asset(
                       IconsSVG.evolve,
                      color:  Get.theme.colorScheme.onPrimary,
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Text('Inversión Evolve',
                    style: Get.textTheme.headline4.copyWith(
                      color: Get.theme.colorScheme.onPrimary,
                    ),
                  ),
            ),
          ),
        ],
      ),
      centerTitle: true,
      toolbarHeight: 48.h,
      elevation: null,
      // flexibleSpace: Container(),
      backgroundColor:  Get.theme.colorScheme.primary,
      actions:null,
      leading:  CupertinoButton(
                  padding: EdgeInsets.only(left: 8.w, right: 4.w),
                  child: SvgPicture.asset(
                     IconsSVG.cross,
                    color:  Get.theme.colorScheme.onPrimary,
                  ),
                  onPressed:  () => Get.back(),
                ),
      bottom: null,
    );

  }


  Widget _cardInfo(String texto, String titulo, String cantidad) {
    return Container(
      margin: EdgeInsets.only(left:15.0, right: 15.0, bottom: 0.0),
      height: 250.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(texto, style: TextStyle(color: Get.theme.colorScheme.primary, fontSize: 22.0), textAlign: TextAlign.center),
          CircleAvatar(
            radius: 65.0,
            backgroundColor: Get.theme.colorScheme.primary,
            child: 
              CircleAvatar(
                child: 
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(titulo, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25.0)),
                      Text(cantidad, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 25.0))
                    ],
                  ),
                  
                radius: 63.0,
                backgroundColor: Colors.white,
              )
          )
        ],
      )
    );
  }

  Widget _circleInfo() {
    String titulo = "\$20 k";
    String text = "USD";
    String titulo2 = "\$499";
    return Container(
      child: Table(
        children: [
          TableRow(
            children: [
              _cardInfo('Inversión mínima', titulo, text),
              _cardInfo('Costo anual + IVA', titulo2, text),
            ]
          )
        ],
      ),
    );
  }

  Widget _moneyInfo() {
    return 
      Container(
        // padding: EdgeInsets.only(top: 20.0),
        alignment: Alignment.topCenter,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Tipo de moneda', style:TextStyle(color: Get.theme.colorScheme.primary, fontWeight: FontWeight.w700, fontSize: 22.0)),
            Container(child: Image.asset(IconsPNG.currencyEvolve))
          ],
        ),
      );
  }

  Widget _detailSecction1() {
    return 
    Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Container(
        height: 100.0,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Table(
              children: [
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, left: 15.0),
                      child: Text('Liquidez', style: TextStyle(color: Colors.black, fontSize: 20.0)),
                    ),
                    Text('Inversión a la vista, disponibilidad de 48 horas.', style: TextStyle(color: Colors.black, fontSize: 20.0)),
                  ]
                )
              ],
            ),
          ],
        )
      ),
    );
  }

  Widget _detailSecction2() {
    return 
      Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Container(
          height: 100.0,
          
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Table(
                children: [
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0, left: 15.0),
                        child: Text('Rendimiento', style: TextStyle(color: Colors.black, fontSize: 20.0)),
                      ),
                      Text('No aplica', style: TextStyle(color: Colors.black, fontSize: 20.0)),
                    ]
                  )
                ],
              ),
            ],
          )
        ),
      );
  }

  Widget _selectMoney() {
    String _icon;
    return 
      Container(
        // padding: EdgeInsets.only(top: 20.0),
        alignment: Alignment.topCenter,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Seleccione su moneda de inversión', style:TextStyle(color: Get.theme.colorScheme.primary, fontWeight: FontWeight.w700, fontSize: 22.0)),
             Center(
        child: Container(
          width: 350.0,
          decoration: BoxDecoration(
            
            color: Colors.grey.withAlpha(50)
          ),
          // padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<String>(
                value: _chosenValue,
                elevation: 12,
                style: TextStyle(color: Colors.red),
                icon: Icon(Icons.arrow_drop_down, color: Get.theme.colorScheme.primary,),
                iconSize: 35,
                underline: SizedBox(),
                items: <String>[
                  'USD',
                ].map<DropdownMenuItem<String>>((String value) {
                  switch (value) {
                      case 'USD':
                          _icon = IconsSVG.usd;
                        break;
                      default:
                    }
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Row(children: [
                      SvgPicture.asset(
                          _icon
                      ),            
                      Text(value, style: TextStyle(color: Colors.black),),

                    ]),
                  );
                }).toList(),
                hint: Text(
                  "Seleccione su moneda de inversión",
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

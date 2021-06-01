import 'package:flutter/material.dart';

import 'package:Velmie/common/passcode/pass_code_screen.dart';
import 'package:Velmie/common/passcode/passcode_widget/pass_code_widget.dart';
import 'package:Velmie/common/widgets/app_bars/base_app_bar.dart';
import 'package:Velmie/common/widgets/app_buttons/button.dart';
import 'package:Velmie/common/widgets/info_widgets.dart';
import 'package:Velmie/flows/sign_up_flow/cubit/sign_up_cubit.dart';
import 'package:Velmie/flows/sign_up_flow/screens/signature_screen.dart';
import 'package:Velmie/flows/sign_up_flow/widgets/document_loader.dart';
import 'package:Velmie/resources/errors/app_common_error.dart';
import 'package:Velmie/resources/strings/app_strings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import '../../../../resources/icons/icons_png.dart';
import '../../../products/screens/evolve_screen.dart';
import '../../../products/screens/dynamic_screen.dart';
import '../../../products/screens/performance_screen.dart';



class ProductListScreen extends StatelessWidget {
  const ProductListScreen({Key key}) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: BaseAppBar(
        titleString: AppStrings.PRODUCT_LIST.tr(),
        titleColor: Colors.black,
        onBackPress: () {
          // context.read<SignUpCubit>().stepChanged(SignUpStep.idDocuments);
          Get.back();
        },
      ),
      body: ListView(
        padding: EdgeInsets.all(10.0),
        children: <Widget>[
          _cardTipo2('Evolve',IconsPNG.evolve),
          SizedBox(height: 30.0),
         
          _cardTipo2('Dynamic',IconsPNG.dinamic),
          SizedBox(height: 30.0),
         
          _cardTipo2('Performance',IconsPNG.performance),
        ],
      ),
    );
  }


  Widget _cardTipo2(String name, String path) {
    final card = Container(
      child: Column(
       children: <Widget>[
         
       Image.asset(path),
       ],
      ),
    );
    return GestureDetector(
      onTap: (){
        print(name);
        switch (name) {
          case 'Evolve':
            Get.to(EvolveScreen());
            break;
          case 'Dynamic':
            Get.to(DynamicScreen());
            break;
          case 'Performance':
            Get.to(PerformanceScreen());
            break;
          default:
        }
        
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular((20.0)),
              color: Colors.white,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  spreadRadius: 2.0,
                  offset: Offset(2.0, 10.0)
                )
              ]
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: card,  
            ),
          ),
        ],
      ),
    );
  }
}







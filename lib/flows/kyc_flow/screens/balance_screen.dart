import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:Velmie/common/widgets/app_bars/base_app_bar.dart';
import '../../../resources/icons/icons_svg.dart';
import '../../../resources/strings/app_strings.dart';
import 'package:flutter_svg/svg.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BalanceScreen extends StatefulWidget {
  BalanceScreen({Key key}) : super(key: key);

  @override
  _BalanceScreenState createState() => _BalanceScreenState();
}


  BaseAppBar _appBar() => BaseAppBar(
    titleString: 'Saldos',
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


class _BalanceScreenState extends State<BalanceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Container(
      child: Column(
        children: [
          Table(
            children: [
              
              TableRow(
                children: [
                 Padding(
                   padding: const EdgeInsets.only(top: 15.0, bottom: 15.0 ),
                   child: Text('0002ch4021', style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w400)),
                 ),
                 
                ]
              ),
              TableRow(
                children: [
                 Padding(
                   padding: const EdgeInsets.only( bottom: 15.0 ),
                   child: Text('Cuenta evolve USD', style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w400)),
                 ),
                ]
              ),
              TableRow(
                children: [
                 Padding(
                   padding: const EdgeInsets.only(bottom: 15.0),
                   child: Center(child: Text('\$23,729.68', style: TextStyle(color: Get.theme.colorScheme.primary, fontSize: 25.0, fontWeight: FontWeight.w700))),
                 ),
                ]
              ),
              TableRow(
                children: [
                 Padding(
                   padding: const EdgeInsets.only(bottom: 15.0),
                   child: Center(child: Text('Detalle de la cuenta', style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w400))),
                 ),
                ]
              ),
              TableRow(
                children: [
                 Center(child: Text('ÚLTIMAS TRANSACCIONES', style: TextStyle(color: Get.theme.colorScheme.primary, fontSize: 25.0, fontWeight: FontWeight.w700))),
                ]
              ),
              
            ],
          ),
          SizedBox(height:20.0),
          Table(
            children: [
              TableRow(
                children: [
                 Text('16 de abril de 2021', style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w400)),
                 Container()
                ]
              ),
              TableRow(
                children: [
                 Text('Cuenta abierta', style: TextStyle(color: Colors.black, fontSize: 25.0, fontWeight: FontWeight.w700)),
                 Column(
                   mainAxisAlignment:  MainAxisAlignment.end,
                   children: [
                     Text('\$24,308.52', style: TextStyle(color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.w700)),
                   ],
                 ),
                ]
              ),
              TableRow(
                children: [
                  Text('Deposito directo', style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w400)),
                 Container()
                ]
              ),
            ],
          ),
          SizedBox(height:20.0),
          Table(
            children: [
              TableRow(
                children: [
                 Text('17 de abril de 2021', style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w400)),
                 Container()
                ]
              ),
              TableRow(
                children: [
                 Text('Cuenta abierta', style: TextStyle(color: Colors.black, fontSize: 25.0, fontWeight: FontWeight.w700)),
                 Column(
                   mainAxisAlignment:  MainAxisAlignment.end,
                   children: [
                     Text('-\$499.00', style: TextStyle(color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.w700)),
                   ],
                 ),
                ]
              ),
              TableRow(
                children: [
                  Text('Tarifa', style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w400)),
                 Container()
                ]
              ),
            ],
          ),
          SizedBox(height:20.0),
          Table(
            children: [
              TableRow(
                children: [
                 Text('17 de abril de 2021', style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w400)),
                 Container()
                ]
              ),
              TableRow(
                children: [
                 Text('16% IVA', style: TextStyle(color: Colors.black, fontSize: 25.0, fontWeight: FontWeight.w700)),
                 Column(
                   mainAxisAlignment:  MainAxisAlignment.end,
                   children: [
                     Text('-\$79.84', style: TextStyle(color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.w700)),
                   ],
                 ),
                ]
              ),
            ],
          ),
        ],
      ),
    ),
    );
  }

  Widget _textTitle() {
    return  
    Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text('0002ch4021', style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w400)),
          );
  }
}
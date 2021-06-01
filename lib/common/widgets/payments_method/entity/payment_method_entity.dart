import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class PaymentsMethodEntity {
  PaymentsMethodEntity({this.title, this.icon, this.onPressed, this.isEnable = true});

  final String title;
  final String icon;
  final VoidCallback onPressed;
  final bool isEnable;
}

import 'package:flutter/widgets.dart';

class ListItemEntity {
  ListItemEntity({this.title, this.icon, this.onClick, this.subtitle});

  final String title;
  final String subtitle;
  final Widget icon;
  final VoidCallback onClick;
}

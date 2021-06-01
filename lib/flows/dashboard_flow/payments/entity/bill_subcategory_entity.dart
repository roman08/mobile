import 'package:flutter/widgets.dart';

import 'title_serchable.dart';

class BillSubcategoryEntity extends TitleSearchable {
  BillSubcategoryEntity({this.title, this.icon});

  @override
  final String title;
  final Widget icon;
}

import 'package:flutter/widgets.dart';

import 'bill_subcategory_entity.dart';
import 'title_serchable.dart';

class BillCategoryEntity extends TitleSearchable {
  BillCategoryEntity({this.title, this.icon, this.subcategory = const []});

  @override
  final String title;
  final Widget icon;
  final List<BillSubcategoryEntity> subcategory;
}

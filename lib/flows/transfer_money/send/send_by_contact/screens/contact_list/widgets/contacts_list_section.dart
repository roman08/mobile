import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../resources/colors/custom_color_scheme.dart';
import '../../../../../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';

class ContactsListSectionForm {
  final String title;

  ContactsListSectionForm({this.title});
}

class ContactsListSection extends StatelessWidget {
  final ContactsListSectionForm form;

  const ContactsListSection({
    Key key,
    @required this.form,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: double.infinity,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 4),
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Text(
        form.title,
        style: Get.textTheme.headline6.copyWith(
          color: Get.theme.colorScheme.midShade,
        )
      ),
    );
  }
}

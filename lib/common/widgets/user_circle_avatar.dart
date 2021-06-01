import 'package:Velmie/flows/transfer_money/send/send_by_contact/entities/app_contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../resources/colors/custom_color_scheme.dart';
import '../../resources/themes/app_text_theme.dart';

class UserCircleAvatar extends StatelessWidget {
  const UserCircleAvatar(this.contact);

  final AppContact contact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.w,
      height: 40.w,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.background.withAlpha(25),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: contact.avatar == null || contact.avatar.isEmpty
          ? Text(
              contact.userInitials,
              style: Get.textTheme.headline6Bold.copyWith(
                color: Get.theme.colorScheme.primaryText,
              ),
            )
          : Image.memory(
              contact.avatar,
              fit: BoxFit.cover,
            ),
    );
  }
}

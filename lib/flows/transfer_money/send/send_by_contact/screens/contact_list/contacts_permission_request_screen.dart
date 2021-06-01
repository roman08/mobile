import 'dart:math';

import 'package:Velmie/resources/colors/app_colors.dart';
import 'package:Velmie/resources/icons/icons_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../../../common/widgets/app_buttons/button.dart';
import '../../../../../../resources/colors/custom_color_scheme.dart';
import '../../../../../../resources/strings/app_strings.dart';
import '../../../../../../resources/themes/app_text_theme.dart';
import '../../bloc/contacts_list_bloc.dart';

class ContactListPermissionsRequestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            _dismissButton(context),
            const Spacer(),
            Expanded(
              flex: 4,
              child: _centerImage(context),
            ),
            const Spacer(),
            _information(context),
            const Spacer(),
            _button(context),
          ],
        ),
      ),
    );
  }

  Widget _dismissButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        margin: EdgeInsets.only(left: 8.w, top: 13.h),
        width: double.infinity,
        alignment: Alignment.centerLeft,
        child: Icon(
          Icons.close,
          size: 26,
          color: Get.theme.colorScheme.onBackground,
        ),
      ),
    );
  }

  Widget _centerImage(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CircleAvatar(
          radius: 100.w,
          backgroundColor: AppColors.elementBackground.withOpacity(0.1),
          child: Container(
            height: 100.w,
            width: 100.w,
            child: SvgPicture.asset(
              IconsSVG.users,
              color: AppColors.primary,
            ),
          ),
        );
      },
    );
  }

  Widget _information(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 40),
      child: Column(
        children: <Widget>[
          Text(
            AppStrings.CONNECT_ADDRESS_BOOK.tr(),
            style: Get.theme.textTheme.headline4Bold.copyWith(
              color: Get.theme.colorScheme.primaryText,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.EXPLANATION_TEXT_WHY_ASK_AND_WHERE.tr(),
            style: Get.theme.textTheme.headline5.copyWith(
              color: Get.theme.colorScheme.boldShade,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _button(BuildContext context) {
    return Button(
      onPressed: () {
        final permissionsBloc = Provider.of<ContactsListBloc>(context, listen: false);
        permissionsBloc.requestPermissions();
      },
      title: AppStrings.CONNECT_CONTACT_BOOK.tr(),
    );
  }
}

import 'package:Velmie/common/utils/ensure_localization_switched.dart';
import 'package:Velmie/common/widgets/app_bars/base_app_bar.dart';
import 'package:Velmie/resources/colors/app_colors.dart';
import 'package:Velmie/resources/strings/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContactsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ensureLocalizationSwitched(context);

    return Scaffold(
      appBar: BaseAppBar(
        titleString: AppStrings.CONTACT_US.tr(),
        titleColor:  Colors.black,
      ),
      body: SafeArea(
        minimum: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 20.h),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Text(
              AppStrings.IF_YOU_NEED_SOME_ASSISTANCE.tr(),
              style: TextStyle(color: AppColors.primaryText, fontSize: 18.ssp),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40.h),
            Text(
              AppStrings.EMAIL.tr(),
              style: TextStyle(color: AppColors.primaryText, fontSize: 18.ssp),
            ),
            SizedBox(height: 5.h),
            Text(
              'support@confialink.com',
              style: TextStyle(color: AppColors.secondaryText, fontSize: 18.ssp),
            ),
          ],
        ),
      ),
    );
  }
}

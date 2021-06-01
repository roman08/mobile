import 'package:Velmie/common/utils/ensure_localization_switched.dart';
import 'package:Velmie/flows/sign_in_flow/screens/sign_in_screen/sign_in_screen.dart';
import 'package:Velmie/flows/sign_up_flow/screens/sign_up_screen/sign_up_screen.dart';
import 'package:Velmie/resources/colors/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

import '../../../common/widgets/app_buttons/button.dart';
import '../../../resources/colors/custom_color_scheme.dart';
import '../../../resources/icons/icons_png.dart';
import '../../../resources/strings/app_strings.dart';

class WelcomeScreen extends StatelessWidget {
  final PageController _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    ensureLocalizationSwitched(context);

    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.only(bottom: ScreenUtil.screenHeight <= 600 ? 40.h : 60.h),
        child: Column(
          children: <Widget>[
            Expanded(
              child: PageView(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: _pageController,
                onPageChanged: (int index) {
                  _currentPageNotifier.value = index;
                },
                children: [
                  PageContentWidget(
                    imagePath: IconsPNG.bienvenida,
                    title: '',
                    description: '',
                  ),
                  PageContentWidget(
                    imagePath: IconsPNG.bienvenida2,
                    title: '',
                    description: '',
                  ),
                  PageContentWidget(
                    imagePath: IconsPNG.bienvenida3,
                    title: '',
                    description: '',
                  ),
                ],
              ),
            ),
            // Medias imagenes slider  sube/baja originales = 16, 32
            SizedBox(height: ScreenUtil.screenHeight <= 600 ? 4.h : 8.h),
            CirclePageIndicator(
              itemCount: 3,
              dotColor: Get.theme.colorScheme.boldShade.withOpacity(0.5),
              dotSpacing: 12.w,
              size: 5.w,
              selectedSize: 8.w,
              selectedDotColor: Get.theme.colorScheme.primary,
              currentPageNotifier: _currentPageNotifier,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(24.w, ScreenUtil.screenHeight <= 600 ? 24.h : 40.h, 24.w, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Button(
                      title: AppStrings.SIGN_IN.tr(),
                      onPressed: () => Get.to(SignInScreen()),
                    ),
                  ),
                  SizedBox(width: 24.w),
                  Expanded(
                    child: Button(
                      title: AppStrings.SIGN_UP.tr(),
                      color: Get.theme.colorScheme.onPrimary,
                      onPressColor: Get.theme.colorScheme.primaryExtraLight,
                      shadowColor: AppColors.primary,
                      textColor: Get.theme.colorScheme.primary,
                      onPressed: () => Get.to(SignUpScreen()),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PageContentWidget extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const PageContentWidget({
    this.imagePath,
    this.title,
    this.description,
  });

  @override
  Widget build(BuildContext context) => Container(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(child: Image.asset(imagePath)),
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.all(0.0),
                  child: Text(
                    description,
                    textAlign: TextAlign.center,
                    style: Get.textTheme.headline5.copyWith(
                      color: Get.theme.colorScheme.boldShade,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              // Pading botones
              padding: EdgeInsets.only(top: 1.h),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 26.ssp,
                  color: AppColors.primaryText,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
}

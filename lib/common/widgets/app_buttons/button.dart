import 'package:Velmie/common/bloc/loader_bloc.dart';
import 'package:Velmie/resources/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../resources/colors/custom_color_scheme.dart';

// ignore: must_be_immutable
class Button extends StatelessWidget {
  Button({
    this.title,
    this.onPressed,
    this.color,
    this.onPressColor,
    this.shadowColor,
    this.textColor,
    this.disabledTextColor,
    this.isSupportLoading = false,
  }) {
    color = this.color ?? Get.theme.colorScheme.primary;
    onPressColor = this.onPressColor ?? Get.theme.colorScheme.primaryVariant.withOpacity(0.4);
    shadowColor = this.shadowColor ?? AppColors.primary.withOpacity(0.2);
    textColor = this.textColor ?? Get.theme.colorScheme.onPrimary;
    disabledTextColor = (this.disabledTextColor ?? Get.theme.colorScheme.primaryVariant).withOpacity(0.5);
  }

  final String title;
  final VoidCallback onPressed;
  Color color;
  Color onPressColor;
  Color shadowColor;
  Color textColor;
  Color disabledTextColor;
  final bool isSupportLoading;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoaderBloc, LoaderState>(
      buildWhen: (previous, current) => (previous != current) && isSupportLoading,
      builder: (context, state) => Container(
        decoration: BoxDecoration(boxShadow: [
          if (onPressed == null)
            BoxShadow(
              color: Get.theme.colorScheme.background,
            )
          else
            BoxShadow(
              color: AppColors.primary.withOpacity(0.5),
              blurRadius: 16,
              offset: const Offset(0, 5), // changes position of shadow
            )
        ]),
        child: MaterialButton(
          color: color,
          elevation: 0,
          highlightElevation: 0,
          splashColor: Colors.transparent,
          highlightColor: onPressColor,
          disabledColor: AppColors.primary.withOpacity(.3),
          disabledTextColor: AppColors.primaryText,
          onPressed: onPressed != null
              ? () {
                  if (state != LoaderState.buttonLoadState) {
                    onPressed();
                  }
                }
              : null,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26.0.h)),
          child: Container(
            height: 48.h,
            alignment: Alignment.center,
            child: (isSupportLoading && state == LoaderState.buttonLoadState)
                ? _loadProgressIndicator()
                : buttonTitle(title),
          ),
        ),
      ),
    );
  }

  Widget _loadProgressIndicator() => SizedBox(
        height: 20.w,
        width: 20.w,
        child: CircularProgressIndicator(
          strokeWidth: 1.w,
          valueColor: AlwaysStoppedAnimation<Color>(Get.theme.colorScheme.primary),
          backgroundColor: Get.theme.colorScheme.primaryExtraLight,
        ),
      );

  Widget buttonTitle(String title) => Text(
        title,
        maxLines: 1,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: Get.textTheme.button.copyWith(color: onPressed == null ? disabledTextColor : textColor),
      );
}

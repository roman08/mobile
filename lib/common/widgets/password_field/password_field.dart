import 'package:Velmie/resources/icons/icons_svg.dart';
import 'package:Velmie/resources/strings/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import '../../../resources/colors/custom_color_scheme.dart';

import 'cubit/password_field_cubit.dart';

class PasswordField extends StatelessWidget {
  const PasswordField({
    @required this.onChanged,
    this.onFieldSubmitted,
    this.focusNode,
    this.errorText,
    this.signInMode = false,
    this.labelText = AppStrings.PASSWORD,
  });

  final Function onChanged;
  final Function onFieldSubmitted;
  final FocusNode focusNode;
  final String errorText;

  /// Field's placeholder
  /// Defaults to AppStrings.PASSWORD
  /// [labelText] isn't shown in [signInMode]
  final String labelText;

  /// Sets:
  /// [textInputAction] to TextInputAction.done
  /// [floatingLabelBehavior] to FloatingLabelBehavior.never
  /// Specifies [hintText]
  /// And removes overridden bottom border
  final bool signInMode;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PasswordFieldCubit>(
      create: (_) => PasswordFieldCubit(),
      child: BlocBuilder<PasswordFieldCubit, PasswordFieldState>(
        buildWhen: (previous, current) =>
            previous.obscurePassword != current.obscurePassword,
        builder: (context, state) => TextFormField(
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          textInputAction:
              signInMode ? TextInputAction.done : TextInputAction.next,
          focusNode: focusNode,
          obscureText: state.obscurePassword,
          decoration: InputDecoration(
            enabledBorder: signInMode ? null : UnderlineInputBorder(
              borderSide: BorderSide(color: Get.theme.colorScheme.lightShade),
            ),
            suffixIcon: GestureDetector(
              onTap: () =>
                  context.read<PasswordFieldCubit>().changePasswordVisibility(),
              child: IconButton(
                padding: const EdgeInsets.symmetric(vertical: 0),
                alignment: Alignment.bottomRight,
                icon: SvgPicture.asset(
                  state.obscurePassword
                      ? IconsSVG.eyeOff
                      : IconsSVG.eye,
                  color: Get.theme.colorScheme.midShade,
                  height: 30.h,
                  width: 30.w,
                ),
              ),
            ),
            hintText: signInMode ? labelText.tr() : null,
            floatingLabelBehavior: signInMode
                ? FloatingLabelBehavior.never
                : FloatingLabelBehavior.auto,
            labelText: labelText.tr(),
            errorText: errorText,
          ),
        ),
      ),
    );
  }
}

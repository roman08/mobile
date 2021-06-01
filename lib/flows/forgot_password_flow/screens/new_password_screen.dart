import 'package:Velmie/common/repository/user_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:network_utils/resource.dart';
import 'package:provider/provider.dart';

import '../../../common/utils/validator.dart';
import '../../../common/widgets/app_bars/base_app_bar.dart';
import '../../../common/widgets/app_buttons/button.dart';
import '../../../common/widgets/fab_utils.dart';
import '../../../common/widgets/info_widgets.dart';
import '../../../common/widgets/keyboard_utils.dart';
import '../../../common/widgets/loader/progress_loader.dart';
import '../../../resources/colors/custom_color_scheme.dart';
import '../../../resources/icons/icons_svg.dart';
import '../../../resources/strings/app_strings.dart';
import '../../../resources/themes/app_text_theme.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  const CreateNewPasswordScreen({
    @required this.email,
  });

  final String email;

  @override
  CreateNewPasswordScreenState createState() => CreateNewPasswordScreenState();
}

class CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final _emailInputController = TextEditingController();
  final _verificationCodeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _emailFieldKey = GlobalKey<FormFieldState>();
  final _verificationCodeKey = GlobalKey<FormFieldState>();
  final _passwordFieldKey = GlobalKey<FormFieldState>();
  final _confirmPasswordFieldKey = GlobalKey<FormFieldState>();

  final _confirmPasswordFocusNode = FocusNode();

  bool _obscurePasswordText = true;
  bool _obscureConfirmPasswordText = true;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    _emailInputController.text = widget.email;

    return Scaffold(
      appBar: _isLoading ? null : _appBar(),
      body: SafeArea(
        child: _isLoading
            ? progressLoader()
            : SingleChildScrollView(
                padding:
                    EdgeInsets.fromLTRB(24.w, 0, 24.w, FAB_BOTTOM_PADDING.h),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 30.h),
                    _title(),
                    SizedBox(height: 16.h),
                    _subTitle(),
                    SizedBox(height: 24.h),
                    _emailField(context),
                    SizedBox(height: 14.h),
                    _verificationCodeField(context),
                    SizedBox(height: 14.h),
                    _passwordField(context),
                    SizedBox(height: 14.h),
                    _confirmPasswordField(context),
                  ],
                ),
              ),
      ),
      floatingActionButton: _isLoading
          ? const SizedBox()
          : Container(
              child: _button(),
              padding: EdgeInsets.fromLTRB(
                  24.w, 0, 24.w, isKeyboardVisible(context) ? 16.h : 40.h),
            ),
      floatingActionButtonLocation: const CenterBottomFabLocation(),
    );
  }

  Widget _button() =>
      Button(title: AppStrings.SUBMIT.tr(), onPressed: () => _validateForm());

  void _validateForm() {
    FocusScope.of(context).unfocus();
    final isValidPassword = _passwordFieldKey.currentState.validate();
    final isValidConfirmPassword =
        _confirmPasswordFieldKey.currentState.validate();
    final isVerificationCodeValid = _verificationCodeKey.currentState.validate();

    if (isValidPassword && isValidConfirmPassword && isVerificationCodeValid) {
      createNewPassword();
    }
  }

  void createNewPassword() {
    final UserRepository userRepository =
        Provider.of<UserRepository>(context, listen: false);
    userRepository
        .createNewPassword(
            code: _verificationCodeController.text.trim(),
            password: _passwordController.text.trim())
        .listen((resource) {
      switch (resource.status) {
        case Status.success:
          showAlertDialog(context,
              title: AppStrings.SUCCESS.tr(),
              description: AppStrings.PASSWORD_HAS_BEEN_CREATED.tr(),
              onPress: () => Get.close(4));
          break;
        case Status.loading:
          showLoading(true);
          break;
        case Status.error:
          showLoading(false);
          String errorText = '';

          switch(resource.errors.first.code) {
            case 'INVALID_CONFIRMATION_CODE': errorText = 'Invalid verification code';
                break;
            default: errorText = 'Something went wrong';
            break;
          }

          showToast(context, errorText);
          break;
      }
    });
  }

  void showLoading(bool isShow) {
    setState(() {
      _isLoading = isShow;
    });
  }

  BaseAppBar _appBar() => const BaseAppBar(
        backIconPath: IconsSVG.cross,
      );

  Widget _title() => Text(
        AppStrings.CREATE_NEW_PASSWORD.tr(),
        style: Get.textTheme.headline1Bold
            .copyWith(
              color: Get.theme.colorScheme.onBackground,
              fontWeight: FontWeight.w700,
              fontSize: 30.0),
      );

  Widget _subTitle() => Text(
        AppStrings.FILL_FIELDS_TO_CREATE_PASSWORD.tr(),
        style: Get.textTheme.headline5
            .copyWith(color: Get.theme.colorScheme.midShade),
      );
  
  Widget _verificationCodeField(BuildContext context) {
    return TextFormField(
      key: _verificationCodeKey,
      scrollPadding: EdgeInsets.symmetric(vertical: FAB_INPUT_SCROLL_PADDING.h),
      decoration: InputDecoration(labelText: AppStrings.VERIFICATION_CODE.tr()),
      textInputAction: TextInputAction.next,
      controller: _verificationCodeController,
        validator: (String password) {
          if (password.isEmpty) {
            return ErrorStrings.FIELD_IS_REQUIRED.tr();
          }
          return null;
        }
    );
  }
  

  Widget _emailField(BuildContext context) {
    return TextFormField(
      key: _emailFieldKey,
      scrollPadding: EdgeInsets.symmetric(vertical: FAB_INPUT_SCROLL_PADDING.h),
      decoration: InputDecoration(labelText: AppStrings.EMAIL_ADDRESS.tr()),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      controller: _emailInputController,
      enabled: false,
    );
  }

  Widget _passwordField(BuildContext context) {
    final Validator validator = Provider.of<Validator>(context);
    return TextFormField(
        key: _passwordFieldKey,
        scrollPadding:
            EdgeInsets.symmetric(vertical: FAB_INPUT_SCROLL_PADDING.h),
        controller: _passwordController,
        onFieldSubmitted: (_) =>
            FocusScope.of(context).requestFocus(_confirmPasswordFocusNode),
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.visiblePassword,
        obscureText: _obscurePasswordText,
        decoration: InputDecoration(
          labelText: AppStrings.NEW_PASSWORD.tr(),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _obscurePasswordText = !_obscurePasswordText;
              });
            },
            child: IconButton(
              padding: const EdgeInsets.symmetric(vertical: 0),
              alignment: Alignment.bottomRight,
              icon: SvgPicture.asset(
                _obscurePasswordText ? IconsSVG.eyeOff : IconsSVG.eye,
                color: Get.theme.colorScheme.midShade,
                height: 36.h,
                width: 36.w,
              ),
            ),
          ),
        ),
        validator: (String password) {
          if (password.isEmpty) {
            return ErrorStrings.FIELD_IS_REQUIRED.tr();
          } else if (password.length < 8) {
            return ErrorStrings.SHOULD_BE_MINIMUM_EIGHT_CHARACTERS.tr();
          } else if (!validator.isValidPassword(password)) {
            return ErrorStrings.PASSWORD_REQUIREMENTS.tr();
          } else if (_passwordController.text !=
              _confirmPasswordController.text) {
            return ErrorStrings.PASSWORD_MISMATCH.tr();
          }
          return null;
        });
  }

  Widget _confirmPasswordField(BuildContext context) {
    final Validator validator = Provider.of<Validator>(context);
    return TextFormField(
        key: _confirmPasswordFieldKey,
        scrollPadding:
            EdgeInsets.symmetric(vertical: FAB_INPUT_SCROLL_PADDING.h),
        focusNode: _confirmPasswordFocusNode,
        controller: _confirmPasswordController,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.visiblePassword,
        obscureText: _obscureConfirmPasswordText,
        decoration: InputDecoration(
          labelText: AppStrings.CONFIRM_NEW_PASSWORD.tr(),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _obscureConfirmPasswordText = !_obscureConfirmPasswordText;
              });
            },
            child: IconButton(
              padding: const EdgeInsets.symmetric(vertical: 0),
              alignment: Alignment.bottomRight,
              icon: SvgPicture.asset(
                _obscureConfirmPasswordText ? IconsSVG.eyeOff : IconsSVG.eye,
                color: Get.theme.colorScheme.midShade,
                height: 36.h,
                width: 36.w,
              ),
            ),
          ),
        ),
        validator: (String password) {
          if (password.isEmpty) {
            return ErrorStrings.FIELD_IS_REQUIRED.tr();
          } else if (password.length < 8) {
            return ErrorStrings.SHOULD_BE_MINIMUM_EIGHT_CHARACTERS.tr();
          } else if (!validator.isValidPassword(password)) {
            return ErrorStrings.PASSWORD_REQUIREMENTS.tr();
          } else if (_passwordController.text !=
              _confirmPasswordController.text) {
            return ErrorStrings.PASSWORD_MISMATCH.tr();
          }
          return null;
        });
  }
}

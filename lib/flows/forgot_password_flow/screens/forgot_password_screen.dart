import 'package:Velmie/common/repository/user_repository.dart';
import 'package:Velmie/flows/forgot_password_flow/screens/new_password_screen.dart';
import 'package:Velmie/resources/errors/app_common_error.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:network_utils/resource.dart';
import 'package:provider/provider.dart';

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

class ForgotPasswordScreen extends StatefulWidget {
  @override
  ForgotPasswordScreenState createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _inputFieldKey = GlobalKey<FormFieldState>();
  final _inputController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: _isLoading ? null : _appBar(),
        body: SafeArea(
          child: _isLoading
              ? progressLoader()
              : SingleChildScrollView(
                  padding:
                      EdgeInsets.fromLTRB(24.w, 0, 24.w, FAB_BOTTOM_PADDING.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 30.h),
                      _title(),
                      SizedBox(height: 16.h),
                      _subTitle(),
                      SizedBox(height: 24.h),
                      _inputField(),
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

  Widget _button() =>
      Button(title: AppStrings.NEXT.tr(), onPressed: () => _validateForm());

  void _validateForm() {
    FocusScope.of(context).unfocus();
    if (_inputFieldKey.currentState.validate()) {
      _forgotPassword();
    }
  }

  void _forgotPassword() {
    final UserRepository userRepository =
        Provider.of<UserRepository>(context, listen: false);
    final String inputString = _inputController.text.trim();
    userRepository.forgotPassword(inputString).listen((resource) {
      switch (resource.status) {
        case Status.success:
          showLoading(false);
          Get.to(CreateNewPasswordScreen(email: inputString));
          break;
        case Status.loading:
          showLoading(true);
          break;
        case Status.error:
          showLoading(false);
          showToast(context, CommonErrors[resource.errors.first.code]?.tr());
          break;
      }
    });
  }

  Widget _appBar() => const BaseAppBar(
        backIconPath: IconsSVG.cross,
      );

  Widget _title() => Text(
    AppStrings.REQUEST_PASSWORD_RESET.tr(),
    style: TextStyle(
      fontSize: 25.0,
      color: Get.theme.colorScheme.onBackground,
      fontWeight: FontWeight.w700
    ),     
  );

  Widget _subTitle() => Text(
        AppStrings.WE_SEND_YOU_EMAIL_OR_SMS.tr(),
        style: Get.textTheme.headline5
            .copyWith(color: Get.theme.colorScheme.midShade),
      );

  Widget _inputField() => TextFormField(
        key: _inputFieldKey,
        scrollPadding:
            EdgeInsets.symmetric(vertical: FAB_INPUT_SCROLL_PADDING.h),
        decoration: InputDecoration(labelText: AppStrings.EMAIL_OR_PHONE.tr()),
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        controller: _inputController,
        validator: (String value) {
          if (value.isEmpty) {
            return ErrorStrings.FIELD_IS_REQUIRED.tr();
          }
          return null;
        },
      );

  void showLoading(bool isShow) {
    setState(() {
      _isLoading = isShow;
    });
  }
}

import 'package:Velmie/common/repository/user_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:network_utils/resource.dart' as network_utils;
import 'package:network_utils/resource.dart';
import 'package:provider/provider.dart';

import 'package:Velmie/resources/app_constants.dart';
import '../../app.dart';
import '../../resources/strings/app_strings.dart';
import '../../resources/themes/app_text_theme.dart';
import 'app_bars/base_app_bar.dart';
import 'app_buttons/countdown_timer_button.dart';
import 'info_widgets.dart';

enum ConfirmationType { registration, password }

enum CodeReceiverType { sms, email }

class VerifyCodeScreen extends StatefulWidget {
  final ConfirmationType confirmationType;
  final CodeReceiverType receiverType;
  final String receiver;
  final Function onSkipPressed;
  final Function onSuccess;
  final bool canBack;
  final bool canSkip;

  const VerifyCodeScreen({
    @required this.confirmationType,
    @required this.receiverType,
    @required this.receiver,
    this.onSkipPressed,
    this.onSuccess,
    this.canBack,
    this.canSkip,
  });

  @override
  VerifyCodeScreenState createState() => VerifyCodeScreenState();
}

class VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final TextEditingController _inputController = TextEditingController();

  @override
  void initState() {
    if (widget.confirmationType == ConfirmationType.registration) {
      _sendCode();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async => widget.canBack,
        child: Scaffold(
          appBar: _appBar(context),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 48.h, 24.w, 0),
                  child: Column(
                    children: <Widget>[
                      _bodyText(context),
                      SizedBox(height: 32.h),
                      SizedBox(
                        width: ScreenUtil.screenWidth * 0.6,
                        child: _inputField(context),
                      ),
                      SizedBox(height: 55.h),
                      Container(
                        width: ScreenUtil.screenWidth * 0.65,
                        padding: EdgeInsets.only(bottom: 30.h),
                        child: CountdownTimerButton(
                          title: AppStrings.GET_NEW_CODE.tr(),
                          timerTitle: AppStrings.GET_NEW_CODE_IN.tr(),
                          countdownSeconds: REQUEST_NEW_CODE_DELAY_SECONDS,
                          onPressed: () => _sendCode(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  Widget _appBar(BuildContext context) => BaseAppBar(
        titleString: AppStrings.CONFIRMATION.tr(),
        isShowBack: widget.canBack,
        titleColor: Colors.black,
        backIconColor: Colors.black,
        // actions: [
        //   if (widget.canSkip) FlatButton(onPressed: () => widget.onSkipPressed(), child: Text(AppStrings.SKIP.tr()))
        // ],
      );

  Widget _bodyText(BuildContext context) {
    final String bodyText = widget.receiverType == CodeReceiverType.email
        ? AppStrings.CODE_SENT_TO_YOUR_EMAIL.tr()
        : AppStrings.CODE_SENT_TO_NUMBER.tr();

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: '$bodyText\n',
          style: Get.textTheme.headline5.copyWith(
            color: Get.theme.colorScheme.onBackground,
            fontWeight: FontWeight.w400,
          ),
          children: <TextSpan>[
            TextSpan(
              text: widget.receiver ?? '?',
              style: Get.textTheme.headline5Bold.copyWith(
                color: Get.theme.colorScheme.onBackground,
                height: 1.5,
              ),
            )
          ]),
    );
  }

  Widget _inputField(BuildContext context) {
    return TextFormField(
      onChanged: (String value) {
        if (value.length == VERIFICATION_CODE_LENGTH) {
          _verifyCode();
        }
      },
      
      controller: _inputController,
      textAlign: TextAlign.center,
      autofocus: true,
      maxLength: VERIFICATION_CODE_LENGTH,
      // maxLengthEnforced: true,
      decoration: InputDecoration(
        counterText: '',
        hintText: AppStrings.VERIFICATION_CODE.tr(),
      ),
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.characters,
    );
  }

  Future<void> _sendCode() async {
    switch (widget.confirmationType) {
      case ConfirmationType.registration:
        _resendRegistrationCode();
        break;
      case ConfirmationType.password:
        _resendResetPasswordCode();
        break;
      default:
        logger.d("Smth went wrong");
        break;
    }
  }

  void _resendRegistrationCode() async {
    final UserRepository userRepository = Provider.of<UserRepository>(context, listen: false);
    Stream<network_utils.Resource<void, String>> request;
    if (widget.receiverType == CodeReceiverType.sms) {
      request = userRepository.sendRegistrationSmsCode();
    } else {
      request = userRepository.sendRegistrationEmailCode();
    }

    request.listen((resource) {
      switch (resource.status) {
        case Status.success:
          break;
        case Status.loading:
          break;
        case Status.error:
          showToast(context, resource.errors?.first?.message ?? 'smth went wrong');
          break;
      }
    });
  }

  void _resendResetPasswordCode() async {
    final UserRepository userRepository = Provider.of<UserRepository>(context, listen: false);
    userRepository.forgotPassword(widget.receiver).listen((resource) {
      switch (resource.status) {
        case Status.success:
          break;
        case Status.loading:
          break;
        case Status.error:
          showToast(context, resource.errors?.first?.message ?? 'smth went wrong');
          break;
      }
    });
  }

  void _verifyCode() {
    final UserRepository userRepository = Provider.of<UserRepository>(context, listen: false);
    switch (widget.confirmationType) {
      case ConfirmationType.registration:
        _verifyRegistrationSmsCode(userRepository);
        break;
      case ConfirmationType.password:
        _verifyResetPasswordCode(userRepository);
        break;
      default:
        logger.d("Smth went wrong");
        break;
    }
  }

  void _verifyRegistrationSmsCode(UserRepository userRepository) async {
    Stream<network_utils.Resource<void, String>> request;
    if (widget.receiverType == CodeReceiverType.sms) {
      request = userRepository.checkRegistrationSmsCode(_inputController.text.trim());
    } else {
      request = userRepository.checkRegistrationEmailCode(_inputController.text.trim());
    }

    request.listen((resource) {
      switch (resource.status) {
        case Status.success:
          widget.onSuccess();
          break;
        case Status.loading:
          break;
        case Status.error:
          _inputController.clear();
          showToast(context, ErrorStrings.ERROR_INVALID_CONFIRMATION_CODE.tr());
          break;
      }
    });
  }

  void _verifyResetPasswordCode(UserRepository userRepository) async {
    userRepository.checkResetPasswordCode(_inputController.text.trim()).listen((resource) {
      switch (resource.status) {
        case Status.success:
          // Get.to(CreateNewPasswordScreen(_inputController.text.trim()));
          break;
        case Status.loading:
          break;
        case Status.error:
          _inputController.clear();
          showToast(context, ErrorStrings.ERROR_INVALID_CONFIRMATION_CODE.tr());
          break;
      }
    });
  }
}

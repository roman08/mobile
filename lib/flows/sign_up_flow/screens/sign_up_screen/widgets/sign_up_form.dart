import 'package:Velmie/common/enums/language.dart';
import 'package:Velmie/common/widgets/app_buttons/button.dart';
import 'package:Velmie/common/widgets/checkbox_acceptance.dart';
import 'package:Velmie/common/widgets/info_widgets.dart';
import 'package:Velmie/common/widgets/password_field/password_field.dart';
import 'package:Velmie/common/widgets/select.dart';
import 'package:Velmie/common/widgets/verify_code_screen.dart';
import 'package:Velmie/flows/sign_up_flow/screens/id_documents_screen.dart';
import 'package:Velmie/flows/sign_up_flow/cubit/sign_up_cubit.dart';
import 'package:Velmie/flows/sign_up_flow/screens/terms_and_conditions_screen.dart';
import 'package:Velmie/resources/errors/app_common_error.dart';
import 'package:Velmie/resources/errors/app_field_errors.dart';
import 'package:Velmie/resources/strings/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'country_code_picker/phone_field.dart';
import 'email_field.dart';


import 'package:Velmie/common/passcode/pass_code_screen.dart';
import 'package:Velmie/common/passcode/passcode_widget/pass_code_widget.dart';


import 'package:Velmie/flows/sign_up_flow/cubit/sign_up_cubit.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _nicknameFocusNode = FocusNode();

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _phoneFocusNode.dispose();
    _nicknameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.locale;

    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state.step == SignUpStep.verification) {
          _startVerification(context, state);
        } else if (state.status.isSubmissionFailure && state.backendErrors.common != null) {
          showAlertDialog(
            context,
            title: AppStrings.ERROR.tr(),
            description: CommonErrors[state.backendErrors.common]?.tr(),
            onPress: () => Get.close(1),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: <Widget>[
              _emailField(),
              SizedBox(height: 14.h),
              _passwordField(),
              SizedBox(height: 14.h),
              _confirmPasswordField(),
              SizedBox(height: 14.h),
              _phoneField(),
              SizedBox(height: 24.h),
              _languageField(),
              SizedBox(height: 24.h),
              _userTypeField(),
              SizedBox(height: 24.h),
              BlocBuilder<SignUpCubit, SignUpState>(
                buildWhen: (previous, current) =>
                    previous.termsAndConditionsAccepted != current.termsAndConditionsAccepted ||
                    current.status.isSubmissionFailure,
                builder: (context, state) => CheckboxAcceptance(
                  title: AppStrings.I_ACCEPT.tr(),
                  link: AppStrings.TERMS_AND_CONDITIONS.tr(),
                  onLinkTap: () => Get.to(TermsAndConditionsScreen()),
                  onChange: (value) => context.read<SignUpCubit>().termsAndConditionsAcceptanceChanged(value),
                  value: state.termsAndConditionsAccepted ?? false,
                ),
              ),
            ],
          ),
          _signUpButton(),
        ],
      ),
    );
  }

  Widget _emailField() {
    String _getEmailError(SignUpState state) {
      if (state.email.error != null && !state.email.pure) {
        return state.email.error;
      }
      if (state.backendErrors.email != null && state.status.isSubmissionFailure) {
        return FieldErrors[state.backendErrors.email]?.tr();
      }
      return null;
    }

    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.email != current.email || current.status.isSubmissionFailure,
      builder: (context, state) => EmailField(
        onChanged: (email) => context.read<SignUpCubit>().emailChanged(email),
        onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_passwordFocusNode),
        focusNode: _emailFocusNode,
        errorText: _getEmailError(state),
      ),
    );
  }

  Widget _passwordField() {
    String _getPasswordError(SignUpState state) {
      if (state.password.error != null && !state.password.pure) {
        return state.password.error;
      }
      if (state.backendErrors.password != null && state.status.isSubmissionFailure) {
        return FieldErrors[state.backendErrors.password]?.tr();
      }
      return null;
    }

    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.password != current.password || current.status.isSubmissionFailure,
      builder: (context, state) => PasswordField(
        onChanged: (password) => context.read<SignUpCubit>().passwordChanged(password),
        onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_confirmPasswordFocusNode),
        focusNode: _passwordFocusNode,
        errorText: _getPasswordError(state),
      ),
    );
  }

  Widget _confirmPasswordField() {
    String _getConfirmPasswordError(SignUpState state) {
      if (state.confirmPassword.error != null && !state.confirmPassword.pure) {
        return state.confirmPassword.error;
      }
      if (!state.confirmPassword.pure && state.password.value != state.confirmPassword.value) {
        return ErrorStrings.PASSWORD_MISMATCH.tr();
      }
      if (state.backendErrors.confirmPassword != null && state.status.isSubmissionFailure) {
        return FieldErrors[state.backendErrors.confirmPassword]?.tr();
      }
      return null;
    }

    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) =>
          previous.confirmPassword != current.confirmPassword || current.status.isSubmissionFailure,
      builder: (context, state) => PasswordField(
        labelText: AppStrings.REPEAT_PASSWORD,
        onChanged: (confirmPassword) => context.read<SignUpCubit>().confirmPasswordChanged(confirmPassword),
        onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_phoneFocusNode),
        focusNode: _confirmPasswordFocusNode,
        errorText: _getConfirmPasswordError(state),
      ),
    );
  }

  Widget _phoneField() {
    String _getPhoneError(SignUpState state) {
      if (state.phone.error != null && !state.phone.pure) {
        return state.phone.error;
      }
      if (state.backendErrors.phoneNumber != null && state.status.isSubmissionFailure) {
        return FieldErrors[state.backendErrors.phoneNumber]?.tr();
      }
      return null;
    }

    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) =>
          previous.phone != current.phone ||
          previous.dialCode != current.dialCode ||
          current.status.isSubmissionFailure,
      builder: (context, state) => PhoneField(
        onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_nicknameFocusNode),
        focusNode: _phoneFocusNode,
        errorText: _getPhoneError(state),
        initialCountryCode: DEFAULT_DIAL_CODE,
        onCountryCodeChanged: (dialCode) => context.read<SignUpCubit>().dialCodeChanged(dialCode),
        onPhoneChanged: (phone) => context.read<SignUpCubit>().phoneChanged(phone),
        label: AppStrings.PHONE_NUMBER_10_DIGITS.tr(),
      ),
    );
  }

  Widget _languageField() {
    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (context, state) => Select(
        label: AppStrings.SYSTEM_LANGUAGE.tr(),
        options: Language.values.map((language) => SelectItem(title: language.name)).toList(),
        onChange: (value) {
          final language = Language.values.firstWhere((language) => language.name == value);
          final locale = context.supportedLocales.firstWhere((element) => element.languageCode == language.code);
          context.read<SignUpCubit>().languageChanged(locale.languageCode);
          context.locale = locale;
        },
        value: Language.values
            .firstWhere(
              (language) => language.code == context.locale.languageCode,
              orElse: () => Language.english,
            )
            .name,
      ),
    );
  }

  Widget _userTypeField() {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) =>
          previous.isCorporate != current.isCorporate || current.status.isSubmissionFailure,
      builder: (context, state) {
        return Select(
          label: AppStrings.PROFILE_TYPE.tr(),
          options: [
            SelectItem(title: AppStrings.INDIVIDUAL.tr()),
            SelectItem(title: AppStrings.CORPORATE.tr()),
          ],
          value:
              state.isCorporate == null || !state.isCorporate ? AppStrings.INDIVIDUAL.tr() : AppStrings.CORPORATE.tr(),
          onChange: (value) => context.read<SignUpCubit>().accountTypeChanged(value == AppStrings.CORPORATE.tr()),
        );
      },
    );
  }

  Widget _signUpButton() {
    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (context, state) {
        return Button(
          title: AppStrings.CONTINUE.tr(),
          onPressed: state.status.isValidated && state.termsAndConditionsAccepted
              ? () {
                  FocusScope.of(context).unfocus();
                  context.read<SignUpCubit>().signUpRequest();
                }
              : null,
          isSupportLoading: true,
        );
      },
    );
  }

  void _startVerification(BuildContext context, SignUpState state) {
    final verifyPhoneScreen = VerifyCodeScreen(
      confirmationType: ConfirmationType.registration,
      receiverType: CodeReceiverType.sms,
      receiver: state.phoneNumber,
      onSuccess: () {
        // context.read<SignUpCubit>().stepChanged(SignUpStep.idDocuments);
        // return Get.to(IdDocumentsScreen());
        return Get.to(const PassCodeScreen(status: PassCodeStatus.signInCreate));
        //  context.read<SignUpCubit>().signInUserAndGoToSetPasscode();
      },
      onSkipPressed: () {
        // context.read<SignUpCubit>().stepChanged(SignUpStep.idDocuments);
        // return Get.to(IdDocumentsScreen());
        return Get.to(const PassCodeScreen(status: PassCodeStatus.signInCreate));
        // context.read<SignUpCubit>().signInUserAndGoToSetPasscode();
      },
      canBack: true,
      canSkip: true,
    );

    // Adds additional screen where the user can verify himself by code sent
    // to email
    final verifyEmailScreen = VerifyCodeScreen(
      confirmationType: ConfirmationType.registration,
      receiverType: CodeReceiverType.email,
      receiver: state.email.value.trim(),
      onSkipPressed: () {
        Get.to(verifyPhoneScreen);
      },
      onSuccess: () {
        Get.to(verifyPhoneScreen);
      },
      canBack: false,
      canSkip: true,
    );

    Get.to(verifyEmailScreen);
  }
}

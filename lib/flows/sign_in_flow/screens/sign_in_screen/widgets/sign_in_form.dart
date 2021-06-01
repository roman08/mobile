import 'package:Velmie/common/bloc/loader_bloc.dart';
import 'package:Velmie/common/repository/user_repository.dart';
import 'package:Velmie/common/session/cubit/session_cubit.dart';
import 'package:Velmie/common/widgets/app_buttons/button.dart';
import 'package:Velmie/common/widgets/app_buttons/flat_button.dart';
import 'package:Velmie/common/widgets/info_widgets.dart';
import 'package:Velmie/common/widgets/password_field/password_field.dart';
import 'package:Velmie/flows/forgot_password_flow/screens/forgot_password_screen.dart';
import 'package:Velmie/flows/sign_in_flow/screens/sign_in_screen/cubit/sign_in_cubit.dart';
import 'package:Velmie/flows/sign_in_flow/screens/sign_in_screen/widgets/login_field.dart';
import 'package:Velmie/flows/sign_in_flow/screens/sign_in_screen/widgets/page_title.dart';
import 'package:Velmie/resources/errors/app_common_error.dart';
import 'package:Velmie/resources/strings/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:get/get.dart';

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignInCubit>(
      create: (_) => SignInCubit(
        context.read<UserRepository>(),
        context.read<LoaderBloc>(),
      ),
      child: BlocListener<SignInCubit, SignInState>(
        listener: (context, state) {
          if (state.status.isSubmissionSuccess) {
            context.read<SessionCubit>().sessionCreatingPassCodeEvent();
            Get.back();
          }
          if (state.status.isSubmissionFailure && state.backendErrors.common != null) {
            showAlertDialog(
              context,
              title: AppStrings.ERROR.tr(),
              description: CommonErrors[state.backendErrors.common]?.tr() ?? ErrorStrings.SOMETHING_WENT_WRONG.tr(),
              onPress: () => Get.close(1),
            );
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: <Widget>[
                PageTitle(),
                SizedBox(height: 40.h),
                _loginField(context),
                SizedBox(height: 30.h),
                _passwordField(context),
                SizedBox(height: 30.h),
                AppFlatButton(
                  text: AppStrings.FORGOT_PASSWORD.tr(),
                  onPressed: () => Get.to(ForgotPasswordScreen()),
                ),
              ],
            ),
            _signInButton(context),
          ],
        ),
      ),
    );
  }

  Widget _loginField(BuildContext context) {
    String _getLoginError(SignInState state) {
      if (state.login.error != null && !state.login.pure) {
        return state.login.error;
      }
      if (state.backendErrors.login != null && state.status.isSubmissionFailure) {
        return state.backendErrors.login;
      }
      return null;
    }

    return BlocBuilder<SignInCubit, SignInState>(
      buildWhen: (previous, current) => previous.login != current.login || current.status.isSubmissionFailure,
      builder: (context, state) => LoginField(
        onChanged: (login) => context.read<SignInCubit>().loginChanged(login),
        onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_passwordFocusNode),
        focusNode: _emailFocusNode,
        errorText: _getLoginError(state),
      ),
    );
  }

  Widget _passwordField(BuildContext context) {
    String _getPasswordError(SignInState state) {
      if (state.password.error != null && !state.password.pure) {
        return state.password.error;
      }
      if (state.backendErrors.password != null && state.status.isSubmissionFailure) {
        return state.backendErrors.password;
      }
      return null;
    }

    return BlocBuilder<SignInCubit, SignInState>(
      buildWhen: (previous, current) => previous.password != current.password || current.status.isSubmissionFailure,
      builder: (context, state) => PasswordField(
        onChanged: (password) => context.read<SignInCubit>().passwordChanged(password),
        onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
        focusNode: _passwordFocusNode,
        errorText: _getPasswordError(state),
        signInMode: true,
      ),
    );
  }

  Widget _signInButton(BuildContext context) {
    return BlocBuilder<SignInCubit, SignInState>(
      builder: (context, state) => Button(
        title: AppStrings.SIGN_IN.tr(),
        onPressed: () {
          FocusScope.of(context).unfocus();
          context.read<SignInCubit>().signInRequest();
        },
        isSupportLoading: true,
      ),
    );
  }
}

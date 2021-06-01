import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import 'common/passcode/pass_code_screen.dart';
import 'common/passcode/passcode_widget/pass_code_widget.dart';
import 'common/session/cubit/session_cubit.dart';
import 'common/session/cubit/session_state.dart';
import 'common/session/session_repository.dart';
import 'flows/biometric_flow/biometric_tracker_screen.dart';
import 'flows/dashboard_flow/bloc/bottom_navigation/bottom_navigation_bloc.dart';
import 'flows/dashboard_flow/destination_view.dart';
import 'flows/kyc_flow/index.dart';
import 'flows/sign_in_flow/screens/welcome_screen.dart';
import 'resources/themes/app_theme.dart';

Logger logger = Logger(
  printer: PrettyPrinter(),
);

// ignore: must_be_immutable
class App extends StatelessWidget {
  static const Duration _timer_duration = Duration(seconds: 10);

  Timer _timer;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(width: 375, height: 812, allowFontScaling: true);

    final sessionRepository = context.watch<SessionRepository>();
    restartTimer(context, sessionRepository);

    return Listener(
      onPointerUp: (PointerEvent details) {
        sessionRepository.updateLastInteractionTime();
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: BlocListener<SessionCubit, SessionState>(
          listener: (context, state) {
            switch (state.runtimeType) {
              case LogOutSessionState:
                Get.offAll(WelcomeScreen());
                context
                    .read<BottomNavigationCubit>()
                    .navigateTo(Navigation.overview);
                break;
              case SignInPassCodeSessionState:
                Get.to(const PassCodeScreen(
                  status: PassCodeStatus.signInCreate,
                ));
                break;
              case SignUpPassCodeSessionState:
                Get.offAll(const PassCodeScreen(
                  status: PassCodeStatus.signUpCreate,
                ));
                break;
              case PinVerificationSessionState:
                Get.to(const PassCodeScreen(
                  status: PassCodeStatus.verification,
                ));
                break;
              case BioVerificationSessionState:
                Get.to(const BiometricTrackerScreen(
                  status: PassCodeStatus.verification,
                ));
                break;
              default:
                break;
            }
          },
          child: GetMaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            debugShowCheckedModeBanner: false,
            /// TODO: Need to refactor and remove. App used NO context navigation used 'Get' package
            routes: {
              ...KYC().routes,
            },
            home: LayoutBuilder(builder: (context, constraints) {
              return _getHomeScreen(context, sessionRepository);
            }),
            theme: AppTheme.lightTheme,
          ),
        ),
      ),
    );
  }

  void restartTimer(BuildContext context, SessionRepository sessionRepository) {
    _timer?.cancel();
    _timer = Timer.periodic(
        _timer_duration,
            (Timer t) => {
          if (sessionRepository.isBlocked)
            context.read<SessionCubit>().sessionVerificationEvent(),
        });
  }

  Widget _getHomeScreen(
      BuildContext context,
      SessionRepository sessionRepository,
      ) {
    final state = context.bloc<SessionCubit>().state;

    switch (state.runtimeType) {
      case BioVerificationSessionState:
        return const BiometricTrackerScreen(
          status: PassCodeStatus.signInVerification,
        );
      case PinVerificationSessionState:
        return const PassCodeScreen(
          status: PassCodeStatus.signInVerification,
        );
        break;
      case SignInPassCodeSessionState:
        return const PassCodeScreen(
          status: PassCodeStatus.signInCreate,
        );
        break;
      default:
        return WelcomeScreen();
    }
  }
}
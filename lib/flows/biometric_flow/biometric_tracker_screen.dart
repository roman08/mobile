import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

import '../../common/passcode/passcode_widget/pass_code_widget.dart';
import '../../common/session/cubit/session_cubit.dart';
import '../../resources/strings/app_strings.dart';
import '../dashboard_flow/dashboard_flow.dart';

class BiometricTrackerScreen extends StatefulWidget {
  final PassCodeStatus status;

  const BiometricTrackerScreen({
    Key key,
    this.status,
  }) : super(key: key);

  @override
  _BiometricTrackerScreenState createState() => _BiometricTrackerScreenState();
}

class _BiometricTrackerScreenState extends State<BiometricTrackerScreen> {
  LocalAuthentication localAuth = LocalAuthentication();
  BiometricType type = BiometricType.face;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 500), () async {
      final list = await localAuth.getAvailableBiometrics();
      final type = list.first;

      if (type != BiometricType.iris) {
        final bool didAuthenticate = await localAuth.authenticateWithBiometrics(
          localizedReason: type == BiometricType.face
              ? BiometricStrings.BIOMETRIC_FACE__ID_ALERT.tr()
              : BiometricStrings.BIOMETRIC_TOUCH_ID_ALERT.tr(),
        );

        if (didAuthenticate) {
          switch (this.widget.status) {
            case PassCodeStatus.signInVerification:
              context.read<SessionCubit>().sessionVerificationSuccessEvent();
              Get.offAll(DashboardFlow());
              break;
            case PassCodeStatus.verification:
              context.read<SessionCubit>().sessionVerificationSuccessEvent();
              Get.back();
              break;
            default:
              break;
          }
        }
      } else {
        Get.back();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(),
    );
  }
}

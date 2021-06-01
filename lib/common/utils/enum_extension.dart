import 'package:local_auth/local_auth.dart';

extension EnumConverter on String {
  BiometricType parseBiometricType() {
    return BiometricType.values
        .singleWhere((element) => element.toString().split('.').last == this);
  }
}

extension BiometricTypeExtenstosion on BiometricType {
  String toNameString() {
    return this.toString().split('.').last;
  }
}

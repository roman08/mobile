import 'package:device_info/device_info.dart';
import 'package:package_info/package_info.dart';

class DeviceUtils {
  static Future<AndroidDeviceInfo> androidDeviceInfo() async =>
      DeviceInfoPlugin().androidInfo;

  static Future<IosDeviceInfo> iosDeviceInfo() async =>
      DeviceInfoPlugin().iosInfo;

  static Future<PackageInfo> getPackageInfo() async =>
      await PackageInfo.fromPlatform();
}

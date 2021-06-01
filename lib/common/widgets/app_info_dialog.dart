import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

import '../../networking/environments.dart';
import '../utils/device_utils.dart';
import '../utils/flavors_utils.dart';

class DeviceInfoDialog extends StatelessWidget {
  const DeviceInfoDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.only(bottom: 8.0),
      title: Container(
        padding: const EdgeInsets.all(8.0),
        color: FlavorConfig.instance.values.bannerColor,
        child: const Text('Device Info'),
      ),
      titlePadding: const EdgeInsets.all(0),
      content: _getContent(),
    );
  }

  Widget _getContent() {
    if (Platform.isAndroid) {
      return _androidContent();
    }
    if (Platform.isIOS) {
      return _iOSContent();
    }
    return const Text("You're not on Android neither iOS");
  }

  String _getCurrentBuildMode() {
    String result = "Debug";
    if (kProfileMode) {
      result = "Profile";
    } else if (kReleaseMode) {
      result = "Release";
    }

    return result;
  }

  Widget _iOSContent() {
    return FutureBuilder(
        future: DeviceUtils.iosDeviceInfo(),
        builder: (context, AsyncSnapshot<IosDeviceInfo> snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          final IosDeviceInfo device = snapshot.data;
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _buildTile('Build mode:', _getCurrentBuildMode()),
                _buildTile('Flavor:', '${FlavorConfig.instance.name}'),
                _buildTile('API url:', '${Environments.current}'),
                getPackageInfo(),
                _buildTile('Physical device?:', '${device.isPhysicalDevice}'),
                _buildTile('Device:', '${device.name}'),
                _buildTile('Model:', '${device.model}'),
                _buildTile('System name:', '${device.systemName}'),
                _buildTile('System version:', '${device.systemVersion}'),
              ],
            ),
          );
        });
  }

  Widget _androidContent() {
    return FutureBuilder(
        future: DeviceUtils.androidDeviceInfo(),
        builder: (context, AsyncSnapshot<AndroidDeviceInfo> snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          final AndroidDeviceInfo device = snapshot.data;
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _buildTile('Build mode:', _getCurrentBuildMode()),
                _buildTile('Flavor:', '${FlavorConfig.instance.name}'),
                _buildTile('API url:', '${Environments.current}'),
                getPackageInfo(),
                _buildTile('Physical device?:', '${device.isPhysicalDevice}'),
                _buildTile('Manufacturer:', '${device.manufacturer}'),
                _buildTile('Model:', '${device.model}'),
                _buildTile('Android version:', '${device.version.release}'),
                _buildTile('Android SDK:', '${device.version.sdkInt}'),
              ],
            ),
          );
        });
  }

  FutureBuilder<PackageInfo> getPackageInfo() {
    return FutureBuilder(
        future: DeviceUtils.getPackageInfo(),
        builder: (context, AsyncSnapshot<PackageInfo> snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          final PackageInfo packageInfo = snapshot.data;
          return Column(
            children: <Widget>[
              _buildTile('Build number (version):',
                  '${packageInfo.buildNumber} (${packageInfo.version})'),
              _buildTile('Package:', '${packageInfo.packageName}')
            ],
          );
        });
  }

  Widget _buildTile(String key, String value) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Text(
              '$key ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Flexible(child: Text(value))
          ],
        ),
      );
}

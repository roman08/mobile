import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

import '../utils/device_utils.dart';
import '../utils/flavors_utils.dart';
import 'app_info_dialog.dart';

class FlavorBanner extends StatelessWidget {
  const FlavorBanner();

  @override
  Widget build(BuildContext context) {
    if (FlavorConfig.isDev() || FlavorConfig.isStage()) {
      return _buildBanner(context);
    } else {
      return const SizedBox();
    }
  }

  Widget _buildBanner(BuildContext context) => FutureBuilder(
      future: DeviceUtils.getPackageInfo(),
      builder: (context, AsyncSnapshot<PackageInfo> snapshot) {
        if (snapshot.hasData) {
          return GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: Banner(
                message: snapshot.data?.version ?? '?',
                textDirection: Directionality.of(context),
                layoutDirection: Directionality.of(context),
                location: BannerLocation.topEnd,
                color: FlavorConfig.instance.values.bannerColor,
              ),
              onLongPress: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        const DeviceInfoDialog());
              });
        } else {
          return const SizedBox();
        }
      });
}

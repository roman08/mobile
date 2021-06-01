import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';

import 'app.dart';
import 'common/cache/cache.dart';
import 'common/cache/cache_control_policy.dart';
import 'common/cache/cache_repository.dart';
import 'common/secure_repository.dart';
import 'common/session/session.dart';
import 'common/session/session_repository.dart';
import 'common/utils/flavors_utils.dart';
import 'flows/app_flow.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ),
  );

  final SessionRepository sessionRepository = SessionRepository(
    Session(),
    SecureRepository(),
    CacheRepository(cache: Cache(cacheControlPolicy: CacheControlPolicy())),
  );
  await sessionRepository.initSessionFromStorage();
  PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
    FlavorConfig.checkFlavorType(packageInfo.appName);
  }).whenComplete(() => runApp(AppFlow(
    child: App(),
    sessionRepository: sessionRepository,
  )));
}

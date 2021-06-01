import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../app.dart';

enum Flavor { DEV, STAGE, PROD }

class FlavorValues {
  FlavorValues({@required this.bannerColor});

  final Color bannerColor;

  /// Add other flavor specific values, e.g resources, URLs, databases
}

class FlavorConfig {
  final Flavor flavor;
  final String name;
  final FlavorValues values;
  static FlavorConfig _instance;

  static void checkFlavorType(String appName) {
    if (appName.startsWith("DEV")) {
      FlavorConfig(
        flavor: Flavor.DEV,
        values: FlavorValues(
          bannerColor: Colors.deepPurpleAccent,
        ),
      );
    } else if (appName.startsWith("STAGE")) {
      FlavorConfig(
        flavor: Flavor.STAGE,
        values: FlavorValues(
          bannerColor: Colors.green,
        ),
      );
    } else {
      FlavorConfig(
        flavor: Flavor.PROD,
        values: FlavorValues(
          bannerColor: Colors.transparent,
        ),
      );
    }
  }

  factory FlavorConfig({
    @required Flavor flavor,
    @required FlavorValues values,
  }) {
    final String flavorString = flavor.toString().split('.').last;
    logger.d('Flavor: $flavorString');
    _instance ??= FlavorConfig._internal(
      flavor,
      flavorString,
      values,
    );
    return _instance;
  }

  FlavorConfig._internal(this.flavor, this.name, this.values);

  static FlavorConfig get instance => _instance;

  static bool isDev() => _instance.flavor == Flavor.DEV;

  static bool isStage() => _instance.flavor == Flavor.STAGE;

  static bool isProd() => _instance.flavor == Flavor.PROD;
}

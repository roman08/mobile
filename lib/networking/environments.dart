import '../common/utils/flavors_utils.dart';

class Environments {
  Environments(this.baseUrl);

  final String baseUrl;

  static Environments get current {
    var url = Environments.dev();
    if (FlavorConfig.isStage()) {
      url = Environments.stage();
    } else if (FlavorConfig.isProd()) {
      url = Environments.prod();
    }

    return url;
  }

  // API DEV
  // https://api.dev.confialink.com/ 
  // API QA
  // https://apiqa.master.confialink.com/
  factory Environments.dev() => Environments('https://api.dev.confialink.com/');

  factory Environments.stage() => Environments('https://api.dev.confialink.com/');

  factory Environments.prod() => Environments('https://api.dev.confialink.com/');

  @override
  String toString() => baseUrl;
}

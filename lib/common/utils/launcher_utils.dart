import 'package:url_launcher/url_launcher.dart';

import '../../app.dart';

Future<void> launchUrl(String url) async {
  if (await canLaunch(url)) {
    await launch(url,
        forceSafariVC: true, forceWebView: false, enableJavaScript: true);
  } else {
    logger.e("Could not launch url: $url");
    throw "Could not launch url: $url";
  }
}

Future<void> call(String phoneNumber) async {
  final String telephoneUrl = 'tel:$phoneNumber';

  if (await canLaunch(telephoneUrl)) {
    await launch(telephoneUrl);
  } else {
    logger.e("Could not phone number: $phoneNumber");
    throw "Could not phone number: $phoneNumber";
  }
}

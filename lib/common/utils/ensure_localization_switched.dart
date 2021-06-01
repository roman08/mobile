import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart';

void ensureLocalizationSwitched(BuildContext context) {
  // Without this line switching languages can work incorrectly
  context.locale;
}
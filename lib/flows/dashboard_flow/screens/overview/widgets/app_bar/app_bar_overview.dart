import 'package:Velmie/common/utils/ensure_localization_switched.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../../../resources/colors/custom_color_scheme.dart';
import '../../../../../../resources/strings/app_strings.dart';
import '../../../../../../resources/themes/app_text_theme.dart';
import '../../../../bloc/dashboard_bloc.dart';

class AppBarOverview extends StatelessWidget {
  const AppBarOverview();

  @override
  Widget build(BuildContext context) {
    ensureLocalizationSwitched(context);

    final bloc = Provider.of<DashboardBloc>(context);
    return StreamBuilder<String>(
        stream: bloc.nicknameObservable,
        builder: (context, snapshot) {
          String nickName = '';
          if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot.data.isNotEmpty) {
            nickName = snapshot.data;
          }
          return Row(
            children: <Widget>[
              const Spacer(),
              _avatar(context, nickName),
              const SizedBox(width: 10),
              Text('${AppStrings.HELLO.tr()}, ',
                  style: Get.textTheme.headline5
                      .copyWith(color: Get.theme.colorScheme.onPrimary)),
              Text('$nickName!',
                  style: Get.textTheme.headline5Bold
                      .copyWith(color: Get.theme.colorScheme.onPrimary)),
              const Spacer(),
              // _overflowButton(context),
            ],
          );
        });
  }

  Widget _avatar(BuildContext context, String username) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
          color: Get.theme.colorScheme.extraLightShade, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(
        username.isNotEmpty ? username[0] : "?",
        style: Get.textTheme.headline5Bold.copyWith(
          color: Get.theme.colorScheme.boldShade,
          height: 1,
        ),
      ),
    );
  }
}

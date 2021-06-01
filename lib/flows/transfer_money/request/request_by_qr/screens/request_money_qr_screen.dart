import 'package:Velmie/resources/colors/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/app_bars/base_app_bar.dart';
import '../../../../../common/widgets/app_buttons/button.dart';
import '../../../../../common/widgets/loader/progress_loader.dart';
import '../../../../../resources/strings/app_strings.dart';
import '../../../../../resources/themes/need_to_refactor_and_remove/app_colors_old.dart';
import '../../../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';
import '../bloc/qr_form/qr_request_form_cubit.dart';
import '../bloc/request_by_qr/request_money_qr_cubit.dart';
import '../bloc/request_by_qr/request_money_qr_state.dart';
import 'request_money_generate_qr_screen.dart';
import 'widgets/qr_request_form.dart';

class _RequestMoneyScreenStyle {
  final TextStyle titleTextStyle;
  final AppColorsOld colors;
  final TextStyle cancelButtonStyle;

  _RequestMoneyScreenStyle({
    this.titleTextStyle,
    this.colors,
    this.cancelButtonStyle,
  });

  factory _RequestMoneyScreenStyle.fromOldTheme(AppThemeOld theme) {
    return _RequestMoneyScreenStyle(
      titleTextStyle: theme.textStyles.m18.copyWith(color: theme.colors.darkShade),
      colors: theme.colors,
      cancelButtonStyle: theme.textStyles.r16.copyWith(color: AppColors.primary),
    );
  }
}

class RequestMoneyByQrScreen extends StatelessWidget {
  RequestMoneyByQrScreen(this._requestMoneyQrBloc) {
    _requestMoneyQrBloc.requestAccount();
  }

  final _RequestMoneyScreenStyle style = _RequestMoneyScreenStyle.fromOldTheme(AppThemeOld.defaultTheme());

  final RequestByQrCubit _requestMoneyQrBloc;

  @override
  Widget build(BuildContext context) {
    final appBar = _appBar();
    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: BlocBuilder<RequestByQrCubit, RequestMoneyState>(
          cubit: _requestMoneyQrBloc,
          builder: (_, state) {
            if (state is RequestMoneyInitState) {
              return progressLoader();
            } else {
              return MultiBlocProvider(
                providers: [
                  BlocProvider(create: (BuildContext context) => QrRequestFormCubit()),
                  BlocProvider.value(value: _requestMoneyQrBloc)
                ],
                child: Container(
                  height: double.infinity,
                  child: SingleChildScrollView(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height -
                          appBar.preferredSize.height -
                          MediaQuery.of(context).padding.top,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 39),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            QrRequestForm(state.wallets),
                            const Spacer(),
                            Button(
                              onPressed: state is CompletedState
                                  ? () => {Get.to(RequestMoneyGenerateQrScreen(state.recipientQREntity))}
                                  : null,
                              title: AppStrings.GENERATE_QR_CODE.tr(),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  BaseAppBar _appBar() => BaseAppBar(
        titleString: AppStrings.QR_CODE_DETAILS.tr(),
        centerTitle: true,
        backgroundColor: Get.theme.colorScheme.background,
        titleColor: Get.theme.colorScheme.onBackground,
        backIconColor: Get.theme.colorScheme.onBackground,
        actions: <Widget>[
          CupertinoButton(
            child: Text(AppStrings.CANCEL.tr(), style: style.cancelButtonStyle),
            onPressed: () => Get.back(),
          ),
        ],
      );
}

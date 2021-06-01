import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../../app.dart';
import '../../../../../../common/widgets/app_bars/base_app_bar.dart';
import '../../../../../../common/widgets/custom_switch.dart';
import '../../../../../../common/widgets/selection_list.dart';
import '../../../../../../resources/colors/custom_color_scheme.dart';
import '../../../../../../resources/icons/icons_svg.dart';
import '../../../../../../resources/strings/app_strings.dart';
import '../../../../../../resources/themes/need_to_refactor_and_remove/app_colors_old.dart';
import '../../../../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';
import '../../../../screens/common/widgets/wallet_list_item_placeholder.dart';
import '../../../../enities/common/wallet_entity.dart';
import '../../bloc/qr_form/qr_request_form_cubit.dart';
import '../../bloc/qr_form/qr_request_form_state.dart';
import '../../bloc/request_by_qr/request_money_qr_cubit.dart';

class _QrRequestFormScreenStyle {
  final String iconDropDown;
  final AppColorsOld colors;

  _QrRequestFormScreenStyle({
    this.iconDropDown,
    this.colors,
  });

  factory _QrRequestFormScreenStyle.fromOldTheme(AppThemeOld theme) {
    return _QrRequestFormScreenStyle(
        iconDropDown: IconsSVG.arrowDown, colors: theme.colors);
  }
}

class QrRequestForm extends StatelessWidget {
  QrRequestForm(this.accounts);

  final _QrRequestFormScreenStyle style =
      _QrRequestFormScreenStyle.fromOldTheme(AppThemeOld.defaultTheme());

  final _controllerWallet = TextEditingController();
  final List<WalletEntity> accounts;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QrRequestFormCubit, QRRequestFormState>(
        listenWhen: (previous, current) {
      return true;
    }, listener: (context, state) {
      if (state.isComplete) {
        context
            .read<RequestByQrCubit>()
            .completedState(state.wallet, state.amount, state.description);
      } else {
        context.read<RequestByQrCubit>().inCompletedState();
      }
    }, builder: (_, state) {
      final child = !state.isChecked
          ? Padding(
              padding: EdgeInsets.only(top: 14.h), child: _amountField(context))
          : const SizedBox();
      return Column(children: <Widget>[
        _walletField(context),
        SizedBox(height: 14.h),
        _openRequestField(context, state.isChecked),
        AnimatedSwitcher(
            duration: const Duration(milliseconds: 0), child: child),
        Padding(
            padding: const EdgeInsets.only(top: 14),
            child: _descriptionField(context)),
      ]);
    });
  }

  Widget _walletField(BuildContext context) {
    final state = context.read<QrRequestFormCubit>().state;
    _controllerWallet.text = state.wallet?.toSelectedItemString();

    // Set first wallet from list to walletInputField on the first screen loading
    if (accounts?.isNotEmpty == true && state.wallet == null) {
      context.read<QrRequestFormCubit>().chooseWallet(accounts[0]);
    }

    return TextFormField(
      controller: _controllerWallet,
      enableInteractiveSelection: false,
      readOnly: true,
      autofocus: false,
      onTap: () => Get.to(
        SelectionList(
            appBar: BaseAppBar(
              titleString: AppStrings.SELECT_WALLET.tr(),
              backIconPath: IconsSVG.cross,
            ),
            list: accounts,
            itemBuilder: (country) => WalletListItemPlaceholder(
                  wallet: country,
                  isSelected:
                      (country as WalletEntity).toSelectedItemString() ==
                          _controllerWallet.text,
                ),
            onSelected: (dynamic wallet) {
              logger.i(wallet.toString());
              context
                  .read<QrRequestFormCubit>()
                  .chooseWallet(wallet as WalletEntity);
            }),
      ),
      decoration: InputDecoration(
        labelText: AppStrings.WALLET_TO.tr(),
        suffixIconConstraints: const BoxConstraints(
          minWidth: 0,
        ),
        suffixIcon: Padding(
          padding: EdgeInsets.only(top: 16.h, right: 0),
          child: SvgPicture.asset(
            IconsSVG.arrowDown,
            alignment: Alignment.centerRight,
            color: Get.theme.colorScheme.midShade,
          ),
        ),
      ),
    );
  }

  Widget _openRequestField(BuildContext context, bool isChecked) {
    return TextFormField(
      initialValue: AppStrings.OPEN_REQUEST.tr(),
      enableInteractiveSelection: false,
      readOnly: true,
      autofocus: false,
      decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: style.colors.lightShade,
            ),
          ),
          labelText: '',
          helperText: AppStrings.OPEN_REQUEST_DESCRIPTION.tr(),
          suffix: CustomSwitch(
            value: isChecked,
            activeColor: style.colors.green,
            inactiveColor: style.colors.lightShade,
            onToggle: (bool isChecked) {
              context.read<QrRequestFormCubit>().openRequest(isChecked);
            },
          )),
    );
  }

  Widget _amountField(BuildContext context) {
    return TextFormField(
        decoration: InputDecoration(
          labelText: AppStrings.AMOUNT.tr(),
        ),
        keyboardType: TextInputType.number,
        onChanged: (value) {
          context
              .read<QrRequestFormCubit>()
              .changeAmount(value.isEmpty ? null : value.trim());
        });
  }

  Widget _descriptionField(BuildContext context) {
    return TextFormField(
        decoration: InputDecoration(
          labelText: AppStrings.DESCRIPTION.tr(),
        ),
        keyboardType: TextInputType.text,
        onChanged: (value) {
          context.read<QrRequestFormCubit>().changeDescription(value.trim());
        });
  }
}

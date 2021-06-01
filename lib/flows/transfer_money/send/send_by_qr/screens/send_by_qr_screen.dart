import 'dart:async';

import 'package:Velmie/resources/app_constants.dart';
import 'package:Velmie/resources/colors/app_colors.dart';
import 'package:api_error_parser/api_error_parser.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../../app.dart';
import '../../../../../common/session/session_repository.dart';
import '../../../../../common/widgets/app_bars/base_app_bar.dart';
import '../../../../../common/widgets/app_buttons/button.dart';
import '../../../../../common/widgets/fab_utils.dart';
import '../../../../../common/widgets/info_widgets.dart';
import '../../../../../common/widgets/loader/loader_screen.dart';
import '../../../../../common/widgets/selection_list.dart';
import '../../../../../common/widgets/success_screen.dart';
import '../../../../../resources/colors/custom_color_scheme.dart';
import '../../../../../resources/errors/app_error_code.dart';
import '../../../../../resources/icons/icons_svg.dart';
import '../../../../../resources/strings/app_strings.dart';
import '../../../../../resources/themes/app_text_theme.dart';
import '../../../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';
import '../../../../dashboard_flow/bloc/bottom_navigation/bottom_navigation_bloc.dart';
import '../../../../dashboard_flow/dashboard_flow.dart';
import '../../../../dashboard_flow/destination_view.dart';
import '../../../cubit/tbu/tbu_cubit.dart';
import '../../../cubit/tbu/tbu_state.dart';
import '../../../enities/common/common_preview_response.dart';
import '../../../enities/common/wallet_entity.dart';
import '../../../repository/transfers_repository.dart';
import '../../../request/request_by_qr/entity/transfer_qr_entity.dart';
import '../../../screens/common/widgets/wallet_list_item_placeholder.dart';
import '../bloc(REFACTOR_AND_REMOVE)/send_by_qr_bloc.dart';
import 'widgets/amount_qr_field.dart';

class SendByQrScreenStyle {
  final TextStyle titleTextStyle;
  final TextStyle cancelButtonStyle;
  final AmountQRFieldStyle amountStyle;
  final TextStyle totalLabelTextStyle;
  final TextStyle totalValueTextStyle;

  SendByQrScreenStyle({
    this.titleTextStyle,
    this.cancelButtonStyle,
    this.amountStyle,
    this.totalLabelTextStyle,
    this.totalValueTextStyle,
  });

  factory SendByQrScreenStyle.fromOldTheme(AppThemeOld theme) {
    return SendByQrScreenStyle(
      titleTextStyle: theme.textStyles.m18.copyWith(color: theme.colors.darkShade),
      cancelButtonStyle: theme.textStyles.r16.copyWith(color: AppColors.primary),
      amountStyle: AmountQRFieldStyle.fromOldTheme(theme),
      totalLabelTextStyle: theme.textStyles.m16,
      totalValueTextStyle: theme.textStyles.r16,
    );
  }
}

class SendByQrScreen extends StatefulWidget {
  final TransferByQrEntity sendByQREntity;

  const SendByQrScreen({this.sendByQREntity});

  @override
  _SendByQrScreenState createState() => _SendByQrScreenState();
}

class _SendByQrScreenState extends State<SendByQrScreen> {
  SendByQrScreenStyle _style;
  SendByQrBloc _bloc;
  final _controllerWallet = TextEditingController();
  final _controllerRecipient = TextEditingController();
  final _controllerPhone = TextEditingController();
  final _controllerAmount = TextEditingController();
  final _controllerDescription = TextEditingController();
  bool _submitAvailable = false;
  Timer _debounce;

  @override
  void initState() {
    super.initState();
    _style = SendByQrScreenStyle.fromOldTheme(Provider.of<AppThemeOld>(context, listen: false));
    final TransfersRepository sendMoneyRepository = Provider.of<TransfersRepository>(context, listen: false);
    final sessionRepository = Provider.of<SessionRepository>(context, listen: false);
    _bloc = SendByQrBloc(sendMoneyRepository, sessionRepository);
    _bloc.recipientWallet = widget.sendByQREntity.wallet;
    _bloc.getSenderWallets();
    setUpForm();
  }

  void onAmountChange(String amount) {
    if (_debounce?.isActive ?? false) {
      _debounce.cancel();
    }

    const timerDuration = Duration(milliseconds: DEFAULT_DEBOUNCE_TIME_MS);

    _debounce = Timer(timerDuration, () {
      if (amount?.isNotEmpty == true) {
        logger.i(amount);
        context.read<TbuCubit>().tbuPreviewRequest = _bloc.getTbuPreviewData(amount);
        context.read<TbuCubit>().truPreview();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TbuCubit, TbuState>(
      listener: (context, state) {
        if (state is TbuPreviewSuccessState) {
          _bloc.transactionPreview = state.data;
          _bloc.transactionPreviewObservable.add(state.data);
          _bloc.tfaRequired = state.data.tfaRequired;
        }

        if (state is TbuSuccessState) {
          context.read<BottomNavigationCubit>().navigateTo(Navigation.transactions);
          Get.off(generateSuccessScreen());
        }

        if (state is TbuErrorState) {
          _handleError(state.errors);
        }

        if (state is TbuPreviewErrorState) {
          _handleError(state.errors);
        }
      },
      builder: (context, state) {
        if (state is TbuLoadingState) {
          return const LoaderScreen();
        } else {
          return Scaffold(
            appBar: _appBar(),
            body: SafeArea(
              child: SingleChildScrollView(
                child: StreamBuilder<List<WalletEntity>>(
                  stream: _bloc.senderWalletsListObservable,
                  builder: (context, snapshot) {
                    return Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _walletField(context, snapshot),
                          SizedBox(height: 12.h),
                          _recipientField(context),
                          SizedBox(height: 12.h),
                          _phoneNumberField(context),
                          SizedBox(height: 12.h),
                          AmountQRField(
                            bloc: _bloc,
                            style: _style.amountStyle,
                            controller: _controllerAmount,
                            isEnable: widget.sendByQREntity.amount == null,
                            feeLoadInProgress: state is TbuPreviewLoadingState,
                            onAmountChange: onAmountChange,
                          ),
                          SizedBox(height: 12.h),
                          _descriptionField(context),
                          SizedBox(height: 24.h),
                          _button()
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        }
      },
    );
  }

  void _handleError(List<ParserMessageEntity> errors) {
    logger.e(errors?.first?.toString());
    String description = ErrorStrings.SOMETHING_WENT_WRONG.tr();
    switch (errors?.first?.code) {
      case AppErrorCode.limits_exceeded:
        description = ErrorStrings.KYC_LIMITS_EXCEEDED.tr();
        break;
      case AppErrorCode.invalid_wallet:
        description = ErrorStrings.ERROR_INVALID_WALLET.tr();
        break;
      case AppErrorCode.insufficient_funds:
        description = ErrorStrings.INSUFFICIENT_WALLET_BALANCE.tr();
        break;
      case AppErrorCode.deposit_not_allowed:
        description = ErrorStrings.DEPOSIT_NOT_ALLOWED.tr();
        break;
      case AppErrorCode.withdrawal_not_allowed:
        description = ErrorStrings.WITHDRAWALS_NOT_ALLOWED.tr();
        break;
      case AppErrorCode.invalid_account_owner:
        description = ErrorStrings.INVALID_ACCOUNT_OWNER.tr();
        break;
      case AppErrorCode.tfa_code_is_required:
        description = ErrorStrings.TFA_CODE_IS_REQUIRED.tr();
        break;
      case AppErrorCode.tfa_code_is_not_valid:
        description = ErrorStrings.TFA_CODE_IS_NOT_VALID.tr();
        break;
      case AppErrorCode.your_phone_number_is_empty:
        description = ErrorStrings.YOUR_PHONE_NUMBER_IS_EMPTY.tr();
        break;
      case AppErrorCode.your_phone_number_is_not_valid:
        description = ErrorStrings.YOUR_PHONE_NUMBER_IS_NOT_VALID.tr();
        break;
      case AppErrorCode.tfa_max_send_attempts_reached:
        description = ErrorStrings.TFA_MAX_SEND_ATTEMPTS_REACHED.tr();
        break;
      default:
        description = ErrorStrings.SOMETHING_WENT_WRONG.tr();
    }

    showAlertDialog(
      context,
      title: AppStrings.ALERT.tr(),
      description: description,
    );
  }

  void setUpForm() {
    // Wallets list field
    _bloc.senderWalletsListObservable.stream.listen((List<WalletEntity> senderAccount) {
      if (senderAccount.isNotEmpty) {
        // Set up recipient field
        _controllerRecipient.addListener(() {
          _bloc.recipient = _controllerRecipient.text;
        });
        _controllerRecipient.text = widget.sendByQREntity.username;

        // Set up phone number field
        _controllerPhone.addListener(() {
          _bloc.phoneNumber = _controllerPhone.text;
        });
        _controllerPhone.text = widget.sendByQREntity.phoneNumber;

        // Set up description field
        _controllerDescription.addListener(() {
          _bloc.description = _controllerDescription.text;
          setState(() {
            _submitAvailable = _controllerDescription.text.isNotEmpty && _controllerAmount.text.isNotEmpty;
          });
        });
        _controllerDescription.text = widget.sendByQREntity.description;

        // Set up amount field
        final String amount = widget.sendByQREntity.amount;
        if (amount != null && amount.isNotEmpty) {
          _controllerAmount.text = amount;
          context.read<TbuCubit>().tbuPreviewRequest = _bloc.getTbuPreviewData(amount);
          context.read<TbuCubit>().truPreview();
        }
      }
    });
  }

  Widget generateSuccessScreen() {
    final fee = _bloc.transactionPreview.details.isNotEmpty ? _bloc.transactionPreview.details[0].amount : '0';
    final String currencyCode = _bloc.transactionPreview.incomingCurrencyCode;

    final title = AppStrings.TRANSFER_SUCCESS_TITLE.tr(namedArgs: {
      "amount": _bloc.amount,
      "currencyCode1": currencyCode,
      "name": _bloc.recipient,
      "fee": fee,
      "currencyCode2": currencyCode,
    });

    final body = AppStrings.TRANSFER_SUCCESS_SUB_TITLE.tr();

    return SuccessScreen(
      title: title,
      body: body,
      canBack: false,
      onButtonPressed: () => Get.offAll(DashboardFlow()),
    );
  }

  BaseAppBar _appBar() => BaseAppBar(
        titleString: AppStrings.SEND_MONEY_BY_QR_CODE.tr(),
        actions: <Widget>[cancelButton()],
      );

  Widget _walletField(BuildContext context, AsyncSnapshot<List<WalletEntity>> snapshot) {
    // Set first wallet from list to walletInputField on the first screen loading
    if (snapshot.hasData) {
      // The following strings cause a critical error
      // setState() called during build.
      // TODO(any): implement state management in a single place
      // _controllerWallet.text = _bloc.senderWalletsList[0].toSelectedItemString();
      // _bloc.setSenderWallet(_bloc.senderWalletsList[0]);
    }

    return TextFormField(
      controller: _controllerWallet,
      enableInteractiveSelection: false,
      scrollPadding: EdgeInsets.symmetric(vertical: FAB_INPUT_SCROLL_PADDING.h),
      readOnly: true,
      autofocus: false,
      onTap: () => Get.to(
        SelectionList(
            appBar: BaseAppBar(
              titleString: AppStrings.SELECT_WALLET.tr(),
              backIconPath: IconsSVG.cross,
            ),
            list: snapshot.data,
            itemBuilder: (country) => WalletListItemPlaceholder(
                  wallet: country,
                  isSelected: (country as WalletEntity).toSelectedItemString() == _controllerWallet.text,
                ),
            onSelected: (dynamic wallet) {
              logger.w((wallet as WalletEntity).toString());
              _controllerWallet.text = wallet.toSelectedItemString();
              _bloc.setSenderWallet(wallet);
            }),
      ),
      decoration: InputDecoration(
        labelText: AppStrings.WALLET_FROM.tr(),
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

  Widget _recipientField(BuildContext context) {
    return TextFormField(
        controller: _controllerRecipient,
        scrollPadding: EdgeInsets.symmetric(vertical: FAB_INPUT_SCROLL_PADDING.h),
        enabled: false,
        decoration: InputDecoration(labelText: AppStrings.RECIPIENT.tr(), suffixIcon: iconLock()));
  }

  Widget _phoneNumberField(BuildContext context) {
    return TextFormField(
        controller: _controllerPhone,
        scrollPadding: EdgeInsets.symmetric(vertical: FAB_INPUT_SCROLL_PADDING.h),
        enabled: false,
        decoration: InputDecoration(labelText: AppStrings.PHONE_NUMBER.tr(), suffixIcon: iconLock()));
  }

  Widget _descriptionField(BuildContext context) {
    return TextFormField(
        controller: _controllerDescription,
        scrollPadding: EdgeInsets.symmetric(vertical: FAB_INPUT_SCROLL_PADDING.h),
        decoration: InputDecoration(labelText: AppStrings.DESCRIPTION.tr() + ' *'));
  }

  Widget iconLock() {
    return Padding(
      padding: EdgeInsets.only(top: 16.h, left: 32.w, right: 8.w),
      child: SvgPicture.asset(IconsSVG.lock),
    );
  }

  Widget _totalAmount(BuildContext context) {
    return StreamBuilder<CommonPreviewResponse>(
      stream: _bloc.transactionPreviewObservable,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final incomingAmount = snapshot.data.incomingAmount;
          final feeAmount = snapshot.data.details.isNotEmpty ? snapshot.data.details[0].amount : '0';
          final parsedIncomingAmount = double.tryParse(incomingAmount) ?? 0;
          final parsedFeeAmount = double.tryParse(feeAmount) ?? 0;
          final totalAmount = (parsedIncomingAmount - parsedFeeAmount).abs().toString();
          final incomingCurrencyCode = snapshot.data.incomingCurrencyCode;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '${AppStrings.TOTAL.tr()}: ',
                style: Get.textTheme.headline5.copyWith(color: Get.theme.colorScheme.onBackground),
              ),
              Text(
                '$totalAmount $incomingCurrencyCode',
                style: Get.textTheme.headline5Bold.copyWith(color: Get.theme.colorScheme.onBackground),
              )
            ],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget cancelButton() => CupertinoButton(
        padding: EdgeInsets.only(top: 2.h, left: 16.w, right: 16.w),
        color: Colors.transparent,
        child: Text(AppStrings.CANCEL.tr(), style: _style.cancelButtonStyle),
        onPressed: () => Get.back(),
      );

  Widget _button() {
    return StreamBuilder<CommonPreviewResponse>(
      stream: _bloc.transactionPreviewObservable,
      builder: (context, snapshot) {
        return Column(
          children: <Widget>[
            _totalAmount(context),
            SizedBox(height: 14.h),
            Button(
              onPressed: snapshot.hasData && _submitAvailable
                  ? () {
                      context.read<TbuCubit>().tbuRequest = _bloc.getTbuData();
                      context.read<TbuCubit>().tbu();
                    }
                  : null,
              title: AppStrings.SEND_MONEY.tr(),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controllerWallet.dispose();
    _controllerRecipient.dispose();
    _controllerPhone.dispose();
    _controllerAmount.dispose();
    _controllerDescription.dispose();
    _bloc.dispose();
    super.dispose();
  }
}

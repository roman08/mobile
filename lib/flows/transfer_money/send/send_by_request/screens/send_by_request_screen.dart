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
import '../../../../in_app_notifications/bloc/request_notifications_bloc.dart';
import '../../../cubit/tbu_request/tbu_request_cubit.dart';
import '../../../cubit/tbu_request/tbu_request_state.dart';
import '../../../enities/common/common_preview_response.dart';
import '../../../enities/common/wallet_entity.dart';
import '../../../repository/transfers_repository.dart';
import '../../../screens/common/widgets/wallet_list_item_placeholder.dart';
import '../bloc/send_by_request_bloc.dart';
import '../entities/transfer_link_entity.dart';
import 'widgets/amount_field.dart';

class SendByRequestScreenStyle {
  final TextStyle titleTextStyle;
  final TextStyle cancelButtonStyle;
  final TextStyle totalLabelTextStyle;
  final TextStyle totalValueTextStyle;
  final String lockIcon;
  final String iconDropDown;

  SendByRequestScreenStyle({
    this.titleTextStyle,
    this.cancelButtonStyle,
    this.totalLabelTextStyle,
    this.totalValueTextStyle,
    this.lockIcon,
    this.iconDropDown,
  });

  factory SendByRequestScreenStyle.fromOldTheme(AppThemeOld theme) {
    return SendByRequestScreenStyle(
      titleTextStyle: theme.textStyles.m18.copyWith(color: theme.colors.darkShade),
      cancelButtonStyle: theme.textStyles.r16.copyWith(color: AppColors.primary),
      totalLabelTextStyle: theme.textStyles.m16,
      totalValueTextStyle: theme.textStyles.r16,
      lockIcon: IconsSVG.lock,
      iconDropDown: IconsSVG.arrowDown,
    );
  }
}

class SendByRequestScreen extends StatefulWidget {
  final TransferByRequestEntity transferData;
  final RequestNotificationsBloc requestNotificationBloc;

  const SendByRequestScreen({this.transferData, this.requestNotificationBloc});

  @override
  _SendByRequestScreenState createState() => _SendByRequestScreenState();
}

class _SendByRequestScreenState extends State<SendByRequestScreen> {
  SendByRequestScreenStyle _style;
  SendByRequestBloc _bloc;
  final _controllerWallet = TextEditingController();
  final _controllerRecipient = TextEditingController();
  final _controllerPhone = TextEditingController();
  final _controllerAmount = TextEditingController();
  final _controllerDescription = TextEditingController();
  Timer _debounce;

  @override
  void initState() {
    super.initState();
    context.read<TbuRequestCubit>().emit(TbuRequestPreviewLoadingState());
    _style = SendByRequestScreenStyle.fromOldTheme(Provider.of<AppThemeOld>(context, listen: false));
    final TransfersRepository sendMoneyRepository = Provider.of<TransfersRepository>(context, listen: false);
    final SessionRepository _sessionRepository = Provider.of<SessionRepository>(context, listen: false);
    _bloc = SendByRequestBloc(
      sendMoneyRepository,
      _sessionRepository,
    );
    _bloc.moneyRequestId = widget.transferData.moneyRequestId;
    _bloc.currencyCode = widget.transferData.currencyCode;
    _bloc.getSenderWallets();
    _setUpForm();
  }

  void onAmountChange(String amount) {
    if (_debounce?.isActive ?? false) {
      _debounce.cancel();
    }

    const timerDuration = Duration(milliseconds: DEFAULT_DEBOUNCE_TIME_MS);

    _debounce = Timer(timerDuration, () {
      if (amount.isNotEmpty) {
        logger.i(amount);
        context.read<TbuRequestCubit>().tbuRequestPreviewData = _bloc.getTbuRequestPreviewData(amount);
        context.read<TbuRequestCubit>().truRequestPreview();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TbuRequestCubit, TbuRequestState>(
      listener: (context, state) {
        if (state is TbuRequestPreviewSuccessState) {
          _bloc.transactionPreview = state.data;
          _bloc.transactionPreviewObservable.add(state.data);
          _bloc.tfaRequired = state.data.tfaRequired;
        }

        if (state is TbuRequestSuccessState) {
          context.read<BottomNavigationCubit>().navigateTo(Navigation.transactions);
          Get.off(generateSuccessScreen());
        }

        if (state is TbuRequestPreviewErrorState) {
          _handleError(state.errors);
        }

        if (state is TbuRequestErrorState) {
          _handleError(state.errors);
        }
      },
      builder: (context, state) {
        if (state is TbuRequestLoadingState) {
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
                        children: <Widget>[
                          _walletField(context, snapshot),
                          const SizedBox(height: 12),
                          _recipientField(context),
                          const SizedBox(height: 12),
                          _phoneNumberField(context),
                          const SizedBox(height: 12),
                          AmountField(
                            bloc: _bloc,
                            controller: _controllerAmount,
                            isEnable: widget.transferData.amount == null,
                            feeLoadInProgress: state is TbuRequestPreviewLoadingState,
                            onAmountChange: onAmountChange,
                          ),
                          const SizedBox(height: 12),
                          _descriptionField(context),
                          const SizedBox(height: 24),
                          _button(),
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

  void _setUpForm() {
    // Wallets list field
    _bloc.senderWalletsListObservable.stream.listen((List<WalletEntity> senderAccount) {
      if (senderAccount.isNotEmpty) {
        // Set up recipient field
        _controllerRecipient.addListener(() {
          _bloc.recipient = _controllerRecipient.text;
        });
        _controllerRecipient.text = widget.transferData.username;

        // Set up phone number field
        _controllerPhone.addListener(() {
          _bloc.phoneNumber = _controllerPhone.text;
        });
        _controllerPhone.text = widget.transferData.phoneNumber;

        // Set up description field
        _controllerDescription.addListener(() {
          _bloc.description = _controllerDescription.text;
        });
        _controllerDescription.text = widget.transferData.description;

        // Set up amount field
        final String amount = widget.transferData.amount;
        if (amount != null && amount.isNotEmpty) {
          _controllerAmount.text = amount;
          context.read<TbuRequestCubit>().tbuRequestPreviewData = _bloc.getTbuRequestPreviewData(amount);
          context.read<TbuRequestCubit>().truRequestPreview();
        }
      }
    });
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

  Widget generateSuccessScreen({int closeScreen = 2}) {
    final fee = _bloc.transactionPreview.details.isNotEmpty ? _bloc.transactionPreview.details[0].amount : '0';
    final String currencyCode = _bloc.transactionPreview.incomingCurrencyCode;

    final title = AppStrings.YOU_SEND_AMOUNT_TO_RECIPIENT.tr(namedArgs: {
      "amount": _bloc.amount,
      "currencyCode1": currencyCode,
      "name": _bloc.recipient,
      "fee": fee,
      "currencyCode2": currencyCode,
    });

    final body = AppStrings.YOU_CAN_REVIEW_TRANSFER_TRANSACTION_HISTORY.tr();

    return SuccessScreen(
      title: title,
      body: body,
      canBack: false,
      onButtonPressed: () => Get.offAll(DashboardFlow()),
    );
  }

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
        floatingLabelBehavior: (snapshot.hasData) ? FloatingLabelBehavior.always : FloatingLabelBehavior.never,
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
        enabled: false,
        decoration: InputDecoration(labelText: AppStrings.RECIPIENT.tr(), suffixIcon: iconLock()));
  }

  Widget _phoneNumberField(BuildContext context) {
    return TextFormField(
        controller: _controllerPhone,
        enabled: false,
        decoration: InputDecoration(labelText: AppStrings.PHONE_NUMBER.tr(), suffixIcon: iconLock()));
  }

  Widget _descriptionField(BuildContext context) {
    return TextFormField(
        controller: _controllerDescription,
        enabled: false,
        decoration: InputDecoration(labelText: AppStrings.DESCRIPTION.tr(), suffixIcon: iconLock()));
  }

  Widget iconLock() {
    return Padding(
        padding: EdgeInsets.only(top: 16.h, left: 32.w, right: 8.w), child: SvgPicture.asset(_style.lockIcon));
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
        });
  }

  BaseAppBar _appBar() {
    return BaseAppBar(
      titleWidget: Text(
        AppStrings.SEND_BY_REQUEST.tr(),
        style: Get.textTheme.headline5.copyWith(color: Get.theme.colorScheme.onBackground, fontSize: 17.ssp),
      ),
      actions: <Widget>[cancelButton()],
    );
  }

  Widget cancelButton() {
    return CupertinoButton(
        padding: EdgeInsets.only(top: 2.h, left: 16.w, right: 16.w),
        color: Colors.transparent,
        child: Text(AppStrings.CANCEL.tr(), style: _style.cancelButtonStyle),
        onPressed: () => Get.back());
  }

  Widget _button() {
    return StreamBuilder<CommonPreviewResponse>(
      stream: _bloc.transactionPreviewObservable,
      builder: (context, snapshot) {
        return Column(
          children: <Widget>[
            _totalAmount(context),
            SizedBox(height: 14.h),
            Button(
              onPressed: snapshot.hasData
                  ? () {
                      context.read<TbuRequestCubit>().tbuRequestData = _bloc.getTbuData();
                      context.read<TbuRequestCubit>().tbuRequest();
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

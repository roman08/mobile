import 'dart:async';

import 'package:Velmie/resources/app_constants.dart';
import 'package:api_error_parser/api_error_parser.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../../../app.dart';
import '../../../../../../common/session/session_repository.dart';
import '../../../../../../common/widgets/app_bars/base_app_bar.dart';
import '../../../../../../common/widgets/app_buttons/button.dart';
import '../../../../../../common/widgets/info_widgets.dart';
import '../../../../../../common/widgets/loader/loader_screen.dart';
import '../../../../../../common/widgets/selection_list.dart';
import '../../../../../../common/widgets/success_screen.dart';
import '../../../../../../resources/colors/custom_color_scheme.dart';
import '../../../../../../resources/errors/app_error_code.dart';
import '../../../../../../resources/icons/icons_svg.dart';
import '../../../../../../resources/strings/app_strings.dart';
import '../../../../../../resources/themes/app_text_theme.dart';
import '../../../../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';
import '../../../../../dashboard_flow/bloc/bottom_navigation/bottom_navigation_bloc.dart';
import '../../../../../dashboard_flow/dashboard_flow.dart';
import '../../../../../dashboard_flow/destination_view.dart';
import '../../../../cubit/tbu/tbu_cubit.dart';
import '../../../../cubit/tbu/tbu_state.dart';
import '../../../../enities/common/common_preview_response.dart';
import '../../../../enities/common/wallet_entity.dart';
import '../../../../repository/transfers_repository.dart';
import '../../../../screens/common/widgets/wallet_list_item_placeholder.dart';
import '../../bloc/send_by_contact_bloc.dart';
import '../../contacts_list_flow.dart';
import '../../entities/app_contact.dart';
import 'widgets/amount_contact_field.dart';
import 'widgets/contact_detail_header.dart';

class SendByContactScreenStyle {
  final ContactDetailHeaderStyle headerStyle;
  final AmountFieldStyle amountStyle;
  final TextStyle totalLabelTextStyle;
  final TextStyle totalValueTextStyle;
  final String iconDropDown;

  SendByContactScreenStyle({
    this.headerStyle,
    this.amountStyle,
    this.totalLabelTextStyle,
    this.totalValueTextStyle,
    this.iconDropDown,
  });

  factory SendByContactScreenStyle.fromOldTheme(AppThemeOld theme) {
    return SendByContactScreenStyle(
      headerStyle: ContactDetailHeaderStyle.fromOldTheme(theme),
      amountStyle: AmountFieldStyle.fromOldTheme(theme),
      totalLabelTextStyle: theme.textStyles.m16,
      totalValueTextStyle: theme.textStyles.r16,
      iconDropDown: IconsSVG.arrowDown,
    );
  }
}

class SendByContactScreen extends StatefulWidget {
  final AppContact contact;

  final ContactFlowType flowType;

  const SendByContactScreen({
    @required this.contact,
    @required this.flowType,
  });

  @override
  _SendByContactScreenState createState() => _SendByContactScreenState();
}

class _SendByContactScreenState extends State<SendByContactScreen> {
  SendByContactScreenStyle _style;
  SendByContactBloc _bloc;
  final _controllerWallet = TextEditingController();
  final _controllerAmount = TextEditingController();
  final _controllerDescription = TextEditingController();
  bool submitAvailable = false;
  Timer _debounce;

  @override
  void initState() {
    super.initState();
    _style = SendByContactScreenStyle.fromOldTheme(Provider.of<AppThemeOld>(context, listen: false));
    final TransfersRepository transfersRepository = Provider.of<TransfersRepository>(context, listen: false);
    final sessionRepository = Provider.of<SessionRepository>(context, listen: false);
    _bloc = SendByContactBloc(
      transfersRepository,
      sessionRepository,
      widget.flowType,
    );
    setUpForm();
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
    _bloc.getWallets(widget.contact.uid);
    _bloc.contactUID = widget.contact.uid;
    _controllerDescription.addListener(() {
      _bloc.description = _controllerDescription.text;
      setState(() {
        submitAvailable = _controllerAmount.text.isNotEmpty &&
            _controllerDescription.text.isNotEmpty &&
            _controllerWallet.text.isNotEmpty;
      });
    });
    _controllerWallet.addListener(() {
      setState(() {
        submitAvailable = _controllerAmount.text.isNotEmpty &&
            _controllerDescription.text.isNotEmpty &&
            _controllerWallet.text.isNotEmpty;
      });
    });
    _controllerAmount.addListener(() {
      setState(() {
        submitAvailable = _controllerAmount.text.isNotEmpty &&
            _controllerDescription.text.isNotEmpty &&
            _controllerWallet.text.isNotEmpty;
      });
    });
  }

  void onAmountChange(String amount) {
    if (_debounce?.isActive ?? false) {
      _debounce.cancel();
    }

    const timerDuration = Duration(milliseconds: DEFAULT_DEBOUNCE_TIME_MS);

    _debounce = Timer(timerDuration, () {
      if (amount?.isNotEmpty == true) {
        logger.d(amount);
        context.read<TbuCubit>().tbuPreviewRequest = _bloc.getTbuPreviewData(amount);
        context.read<TbuCubit>().truPreview();
      }
    });
  }

  Widget generateSuccessScreen({int closeScreen = 2}) {
    final fee = _bloc.transactionPreview.details.isNotEmpty ? _bloc.transactionPreview.details[0].amount : '0';
    final String currencyCode = _bloc.transactionPreview.incomingCurrencyCode;

    final title = _bloc.flowType == ContactFlowType.send
        ? AppStrings.TRANSFER_SUCCESS_TITLE.tr(namedArgs: {
            "amount": _bloc.outgoingAmount,
            "currencyCode1": currencyCode,
            "name": widget.contact.name,
            "fee": fee,
            "currencyCode2": currencyCode,
          })
        : AppStrings.YOU_REQUESTED_AMOUNT.tr(namedArgs: {
            "amount": _bloc.outgoingAmount,
            "currencyCode1": currencyCode,
            "name": widget.contact.name,
            "fee": fee,
            "currencyCode2": currencyCode,
          });

    final body =
        _bloc.flowType == ContactFlowType.send ? AppStrings.TRANSFER_SUCCESS_SUB_TITLE.tr() : "";

    return SuccessScreen(
      title: title,
      body: body,
      canBack: false,
      onButtonPressed: () => Get.offAll(DashboardFlow()),
    );
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

        if (state is RequestFromContactSuccessState) {
          Get.off(generateSuccessScreen());
        }

        if (state is TbuErrorState) {
          _handleError(state.errors);
        }

        if (state is TbuPreviewErrorState) {
          _handleError(state.errors);
        }

        if (state is RequestFromContactErrorState) {
          _handleError(state.errors);
        }
      },
      builder: (context, state) {
        if (state is TbuLoadingState || state is RequestFromContactLoadingState) {
          return const LoaderScreen();
        } else {
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: StreamBuilder<List<WalletEntity>>(
                  stream: _bloc.senderWalletsListObservable,
                  builder: (context, snapshot) {
                    return Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
                      child: Column(
                        children: <Widget>[
                          ContactDetailHeader(
                            contact: widget.contact,
                            style: _style.headerStyle,
                          ),
                          SizedBox(height: 24.h),
                          _walletField(context, snapshot, _bloc.selectedSenderAccount),
                          SizedBox(height: 12.h),
                          AmountContactField(
                            bloc: _bloc,
                            style: _style.amountStyle,
                            controller: _controllerAmount,
                            isEnable: snapshot.hasData,
                            feeLoadInProgress: state is TbuPreviewLoadingState,
                            onAmountChange: onAmountChange,
                          ),
                          SizedBox(height: 12.h),
                          _descriptionField(context),
                          SizedBox(height: 24.h),
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

  Widget _walletField(BuildContext context, AsyncSnapshot<List<WalletEntity>> snapshot, WalletEntity senderAccount) {
    final String labelText =
        ((_bloc.flowType == ContactFlowType.send) ? AppStrings.WALLET_FROM : AppStrings.WALLET_TO).tr();

    // Set first wallet from list to walletInputField on the first screen loading
    if (snapshot.hasData) {
      // The following string causes a critical error
      // setState() called during build.
      // TODO(any): implement state management in a single place
      // _controllerWallet.text = senderAccount.toSelectedItemString();
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
              _controllerWallet.text = (wallet as WalletEntity).toSelectedItemString();
              _bloc.findRecipientWallet(wallet as WalletEntity);
              _controllerAmount.clear();
            }),
      ),
      decoration: InputDecoration(
        labelText: labelText,
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

  Widget _descriptionField(BuildContext context) {
    return TextFormField(
      controller: _controllerDescription,
      decoration: InputDecoration(
        labelText: AppStrings.DESCRIPTION.tr() + ' *',
      ),
      keyboardType: TextInputType.text,
    );
  }

  Widget _totalAmount() {
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

  Widget _button() {
    final String buttonText =
        (_bloc.flowType == ContactFlowType.send ? AppStrings.SEND_MONEY : AppStrings.REQUEST_MONEY).tr();

    return Column(children: <Widget>[
      _totalAmount(),
      SizedBox(height: 14.h),
      StreamBuilder<CommonPreviewResponse>(
          stream: _bloc.transactionPreviewObservable,
          builder: (context, snapshot) {
            return Button(
              onPressed: snapshot.hasData && submitAvailable ? () => _execute() : null,
              title: buttonText,
            );
          }),
    ]);
  }

  void _execute() {
    if (_bloc.flowType == ContactFlowType.send) {
      context.read<TbuCubit>().tbuRequest = _bloc.getTbuData();
      context.read<TbuCubit>().tbu();
    } else {
      context.read<TbuCubit>().requestFromContactData = _bloc.getRequestFromContactData();
      context.read<TbuCubit>().requestFromContact();
    }
  }

  @override
  void dispose() {
    _controllerDescription.dispose();
    _controllerAmount.dispose();
    _bloc.dispose();
    super.dispose();
  }
}

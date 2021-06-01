import 'package:Velmie/common/utils/ensure_localization_switched.dart';
import 'package:Velmie/common/widgets/info_widgets.dart';
import 'package:Velmie/flows/dashboard_flow/cubit/investment_accounts_cubit.dart';
import 'package:Velmie/resources/colors/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:Velmie/flows/sign_up_flow/screens/id_documents_screen.dart';

import '../../../../common/widgets/app_bars/base_app_bar.dart';
import '../../../../common/widgets/loader/loading_header.dart';
import '../../../../common/widgets/payments_method/entity/payment_method_entity.dart';
import '../../../../common/widgets/payments_method/payments_method.dart';
import '../../../../resources/colors/custom_color_scheme.dart';
import '../../../../resources/icons/icons_svg.dart';
import '../../../../resources/strings/app_strings.dart';
import '../../../../resources/themes/need_to_refactor_and_remove/app_colors_old.dart';
import '../../../../resources/themes/need_to_refactor_and_remove/app_text_styles_old.dart';
import '../../../../resources/themes/need_to_refactor_and_remove/app_theme_old.dart';
import '../../../kyc_flow/cubit/kyc_cubit.dart';
import '../../../kyc_flow/cubit/kyc_state.dart';
import '../../../kyc_flow/index.dart';
import '../../../transfer_money/request/request_money_screen.dart';
import '../../../transfer_money/send/send_money_screen.dart';
import '../../../../flows/kyc_flow/screens/send_voucher_screen.dart';
import '../../bloc/bottom_navigation/bottom_navigation_bloc.dart';
import '../../bloc/dashboard_bloc.dart';
import '../../destination_view.dart';
import 'widgets/app_bar/app_bar_overview.dart';
import 'widgets/wallets/wallets.dart';
import 'widgets/whats_new/whats_new.dart';
import '../../../../resources/icons/icons_png.dart';
import 'product_list_screen.dart';
import '../../../kyc_flow/screens/cash_out_screen.dart';

class _OverviewScreenStyle {
  final TextStyle kycAlertTextStyle;
  final TextStyle kycAlertBoldTextStyle;
  final AppColorsOld colors;
  final AppTextStylesOld textStyles;

  _OverviewScreenStyle({
    this.kycAlertTextStyle,
    this.kycAlertBoldTextStyle,
    this.colors,
    this.textStyles,
  });

  factory _OverviewScreenStyle.fromOldTheme(AppThemeOld theme) {
    return _OverviewScreenStyle(
      colors: theme.colors,
      kycAlertTextStyle: theme.textStyles.r14.copyWith(color: theme.colors.white, fontWeight: FontWeight.bold),
      kycAlertBoldTextStyle: theme.textStyles.m14.copyWith(color: theme.colors.darkShade),
      textStyles: theme.textStyles,
    );
  }
}

class OverviewScreen extends StatefulWidget {
  const OverviewScreen();

  @override
  OverviewScreenState createState() => OverviewScreenState();
}

class OverviewScreenState extends State<OverviewScreen> {
  DashboardBloc _dashboardBloc;
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  final _OverviewScreenStyle _style = _OverviewScreenStyle.fromOldTheme(AppThemeOld.defaultTheme());

  @override
  void initState() {
    super.initState();
    context.read<KycCubit>().fetch();
    context.read<InvestmentAccountsCubit>().init();
    _dashboardBloc = Provider.of<DashboardBloc>(context, listen: false);
    _dashboardBloc.loadWallets();
    _dashboardBloc.getUserData();
  }

  void _onRefresh() async {
    context.read<KycCubit>().fetch();
    context.read<InvestmentAccountsCubit>().init();
    _dashboardBloc.loadWallets();
    _dashboardBloc.getUserData();
    _refreshController.refreshCompleted();
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    ensureLocalizationSwitched(context);

    final appTheme = Provider.of<AppThemeOld>(context, listen: false);
    return Scaffold(
      backgroundColor: appTheme.colors.brackgroundGeneral,
      appBar: _appBar(context),
      body: SafeArea(
        child: SmartRefresher(
          controller: _refreshController,
          header: LoadingHeader(),
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _renderKYCAlert(),
                    _title(),
                    Wallets(style: WalletsStyle.fromOldTheme(appTheme)),
                    BlocBuilder<KycCubit, KycState>(
                      builder: (context, state) => PaymentsMethod(
                        payments: _getMostPopularPayments(state),
                        title:  AppStrings.INVESTMENT_PRODUCTS.tr(),
                        
                        // actionTitle: AppStrings.ALL.tr(),
                        // onPressed: () {
                        //   context.read<BottomNavigationCubit>().navigateTo(Navigation.payments);
                        // },
                      ),
                    ),
                    Image.asset(IconsPNG.currencies),
                    // WhatsNew(style: WhatsNewStyle.fromOldTheme(appTheme)),
                    BlocBuilder<KycCubit, KycState>(
                      builder: (context, state) => PaymentsMethod(
                        payments: _getMostPayments(state),
                        title: AppStrings.FINANCIAL_OPERATIONS.tr(),
                        // actionTitle: AppStrings.ALL.tr(),
                        // onPressed: () {
                        //   context.read<BottomNavigationCubit>().navigateTo(Navigation.payments);
                        // },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appBar(BuildContext context) => BaseAppBar(
        toolbarHeight: 48.h,
        titleWidget: const AppBarOverview(),
        backgroundColor: AppColors.primary,
        titleColor: Colors.amber,
        isShowBack: false,
      );

  Widget _title() {
    return Padding(
      padding: const EdgeInsets.only(left: 14.0, top: 34),
      child: Text(
        AppStrings.OVERVIEW.tr(), 
        style: _style.textStyles.m30.copyWith(
          color: _style.colors.darkShade, 
          fontWeight: FontWeight.bold,
          fontSize: 26.0
        )
      ),
    );
  }

  Widget _renderKYCAlert() {
    return BlocBuilder<KycCubit, KycState>(
      builder: (context, state) {
        if (state is SuccessState) {
          return state.currentTier.level > 0
              ? const SizedBox()
              : CupertinoButton(
                  minSize: 0,
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    // KYC().openAccountLevel(context);
                    return Get.to(IdDocumentsScreen());
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Container(
                      height: 69,
                      color: Get.theme.colorScheme.backgroundAlert,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  // SvgPicture.asset(IconsSVG.info, color: Get.theme.colorScheme.warning),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Expanded( 
                                    child: RichText(
                                      text: TextSpan(
                                        text: KYCStrings.ALERT_1.tr(),
                                        style: _style.kycAlertTextStyle,
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: ' ' + KYCStrings.ALERT_2.tr() + ' ',
                                            style: _style.kycAlertTextStyle,
                                          ),
                                          TextSpan(
                                            text: KYCStrings.ALERT_3.tr(),
                                            style: _style.kycAlertTextStyle,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                ],
                              ),
                            ),
                            SvgPicture.asset(
                              IconsSVG.arrowRightIOSStyle,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
        } else {
          return Container();
        }
      },
    );
  }

  List<PaymentsMethodEntity> _getMostPopularPayments(KycState kycState) {
    return [
      PaymentsMethodEntity(
        
        title: AppStrings.EVOLVE.tr(),
        icon: IconsSVG.evolve,
        onPressed: () {
          Get.to(ProductListScreen());
          // if (kycState is SuccessState && kycState.currentTier.level > 0) {
          //   Get.to(SendMoneyScreen());
          // } else {
          //   showToast(context, AppStrings.PLEASE_UPGRADE_YOUR_KYC_LEVEL.tr());
          // }
        },
      ),
      PaymentsMethodEntity(
        title: AppStrings.DYNAMIC.tr(),
        icon: IconsSVG.dynamics,
        onPressed: () {
          Get.to(ProductListScreen());
          // if (kycState is SuccessState && kycState.currentTier.level > 0) {
          //   Get.to(RequestMoneyScreen());
          // } else {
          //   showToast(context, AppStrings.PLEASE_UPGRADE_YOUR_KYC_LEVEL.tr());
          // }
        },
      ),
      PaymentsMethodEntity(
        title: AppStrings.PERFORMANCE.tr(),
        icon: IconsSVG.performance,
        onPressed: () {
          Get.to(ProductListScreen());
          // if (kycState is SuccessState && kycState.currentTier.level > 0) {
          //   Get.to(SendMoneyScreen());
          // } else {
          //   showToast(context, AppStrings.PLEASE_UPGRADE_YOUR_KYC_LEVEL.tr());
          // }
        },
      ),
    ];
  }

  List<PaymentsMethodEntity> _getMostPayments(KycState kycState) {
    return [
      PaymentsMethodEntity(
        title: AppStrings.CASH_IN.tr(),
        icon: IconsSVG.cashIn,
        // isEnable: false,
        onPressed: () {
          Get.to(SendVoucherScren());
          // if (kycState is SuccessState && kycState.currentTier.level > 0) {
          //   Get.to(SendVoucherScren());
          // } else {
          //   showToast(context, AppStrings.PLEASE_UPGRADE_YOUR_KYC_LEVEL.tr());
          // }
        },
      ),
      PaymentsMethodEntity(
        title: AppStrings.CASH_OUT.tr(),
        icon: IconsSVG.cashOut,
        isEnable: true,
        onPressed: () {
          Get.to(CashOutScreen());
          // if (kycState is SuccessState && kycState.currentTier.level > 0) {
          //   Get.to(CashOutScreen());
          // } else {
          //   showToast(context, AppStrings.PLEASE_UPGRADE_YOUR_KYC_LEVEL.tr());
          // }
        },
      ),
    ];
  }
}

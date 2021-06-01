import 'package:Velmie/common/widgets/app_bars/base_app_bar.dart';
import 'package:Velmie/common/widgets/app_buttons/button.dart';
import 'package:Velmie/common/widgets/info_widgets.dart';
import 'package:Velmie/common/widgets/loader/progress_loader.dart';
import 'package:Velmie/flows/cards_flow/cubit/cards_cubit.dart';
import 'package:Velmie/common/widgets/checkbox_acceptance.dart';
import 'package:Velmie/flows/cards_flow/enums/card_status.dart';
import 'package:Velmie/flows/cards_flow/screens/card_document_screen.dart';
import 'package:Velmie/resources/colors/app_colors.dart';
import 'package:Velmie/resources/strings/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class IssueCardScreen extends StatefulWidget {
  @override
  _IssueCardScreenState createState() => _IssueCardScreenState();
}

class _IssueCardScreenState extends State<IssueCardScreen> {
  @override
  void initState() {
    context.read<CardsCubit>().loadDocuments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        titleString: AppStrings.ISSUE_CARD.tr(),
      ),
      body: SafeArea(
        minimum: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 20.h),
        child: BlocConsumer<CardsCubit, CardsState>(
          listenWhen: (previous, current) => previous.cardStatus != current.cardStatus,
          listener: (context, state) {
            if (state.cardStatus == CardStatus.pending) {
              showToast(context, AppStrings.THE_CARD_REQUESTED.tr());
              Get.back();
            }
          },
          builder: (context, state) {
            if (state.documents == null) {
              return progressLoader();
            }

            return Column(
              children: [
                SizedBox(height: 20.h),
                Text(
                  AppStrings.THE_VISA_CARD_WILL_BE_ISSUED.tr(),
                  style: TextStyle(color: AppColors.primaryText, fontSize: 16.ssp),
                ),
                const Spacer(),
                CheckboxAcceptance(
                  value: state.termsAndConditionsAccepted,
                  onChange: (value) => context.read<CardsCubit>().toggleTermsAndConditions(),
                  title: AppStrings.I_ACCEPT.tr(),
                  link: AppStrings.TERMS_AND_CONDITIONS.tr(),
                  onLinkTap: () => Get.to(CardDocumentScreen(
                    title: AppStrings.TERMS_AND_CONDITIONS.tr(),
                    data: state.documents.termsAndConditions,
                  )),
                ),
                CheckboxAcceptance(
                  value: state.cardFeesAccepted,
                  onChange: (value) => context.read<CardsCubit>().toggleCardFees(),
                  title: AppStrings.I_HAVE_READ_THE_INFORMATION_ON.tr(),
                  link: AppStrings.CARD_RELATED_FEES.tr(),
                  onLinkTap: () => Get.to(CardDocumentScreen(
                    title: AppStrings.CARD_RELATED_FEES.tr(),
                    data: state.documents.fees,
                  )),
                ),
                SizedBox(height: 20.h),
                Button(
                  isSupportLoading: true,
                  title: AppStrings.ISSUE_THE_CARD.tr(),
                  onPressed: state.termsAndConditionsAccepted && state.cardFeesAccepted
                      ? () => context.read<CardsCubit>().requestCard()
                      : null,
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

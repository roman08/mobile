import 'package:Velmie/common/widgets/app_bars/base_app_bar.dart';
import 'package:Velmie/common/widgets/loader/progress_loader.dart';
import 'package:Velmie/flows/dashboard_flow/more/profile/cubit/terms_and_conditions_cubit.dart';
import 'package:Velmie/flows/kyc_flow/repository/kyc_repository.dart';
import 'package:Velmie/resources/strings/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileTermsAndConditionsScreen extends StatefulWidget {
  @override
  _ProfileTermsAndConditionsScreenState createState() => _ProfileTermsAndConditionsScreenState();
}

class _ProfileTermsAndConditionsScreenState extends State<ProfileTermsAndConditionsScreen> {
  PdfController pdfController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TermsAndConditionsCubit>(
      create: (_) => TermsAndConditionsCubit(kycRepository: context.read<KycRepository>())..init(),
      child: Scaffold(
        appBar: BaseAppBar(
          titleString: AppStrings.TERMS_AND_CONDITIONS.tr(),
          titleColor: Colors.black,),
        body: SafeArea(
          minimum: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 20.h),
          child: BlocConsumer<TermsAndConditionsCubit, TermsAndConditionsState>(
            listener: (context, state) {
              if (state.termsAndConditionsDocument != null) {
                setState(() {
                  pdfController = PdfController(
                    document: PdfDocument.openData(state.termsAndConditionsDocument),
                  );
                });
              }
            },
            builder: (context, state) => pdfController != null ? PdfView(controller: pdfController) : progressLoader(),
          ),
        ),
      ),
    );
  }
}

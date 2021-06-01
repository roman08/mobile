import 'package:Velmie/common/widgets/app_bars/base_app_bar.dart';
import 'package:Velmie/flows/sign_up_flow/cubit/sign_up_cubit.dart';
import 'package:Velmie/resources/strings/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  @override
  _TermsAndConditionsScreenState createState() => _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  PdfController pdfController;

  @override
  void initState() {
    final state = context.read<SignUpCubit>().state;
    if (state.termsAndConditionsDocument == null) {
      context.read<SignUpCubit>().loadTermsAndConditions();
    } else {
      pdfController = PdfController(
        document: PdfDocument.openData(state.termsAndConditionsDocument),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(titleString: AppStrings.TERMS_AND_CONDITIONS.tr(), titleColor: Colors.black,),
      body: SafeArea(
        minimum: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 20.h),
        child: BlocConsumer<SignUpCubit, SignUpState>(
          listener: (context, state) {
            if (state.termsAndConditionsDocument != null) {
              setState(() {
                pdfController = PdfController(
                  document: PdfDocument.openData(state.termsAndConditionsDocument),
                );
              });
            }
          },
          builder: (context, state) => pdfController != null ? PdfView(controller: pdfController) : const SizedBox(),
        ),
      ),
    );
  }
}

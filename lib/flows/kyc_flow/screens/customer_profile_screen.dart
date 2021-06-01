import 'package:Velmie/common/widgets/app_bars/base_app_bar.dart';
import 'package:Velmie/common/widgets/info_widgets.dart';
import 'package:Velmie/common/widgets/loader/progress_loader.dart';
import 'package:Velmie/flows/kyc_flow/cubit/kyc_cubit.dart';
import 'package:Velmie/flows/kyc_flow/cubit/kyc_state.dart';
import 'package:Velmie/flows/kyc_flow/models/corporate_customer_profile.dart';
import 'package:Velmie/flows/kyc_flow/models/individual_customer_profile.dart';
import 'package:Velmie/flows/kyc_flow/widgets/corporate_profile_form.dart';
import 'package:Velmie/flows/kyc_flow/widgets/individual_profile_form.dart';
import 'package:Velmie/resources/strings/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:Velmie/flows/kyc_flow/kyc_flow.dart';

class CustomerProfileScreen extends StatelessWidget {
  final bool excludeFilled;

  const CustomerProfileScreen({
    this.excludeFilled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(titleString: AppStrings.PROFILE.tr(), titleColor: Colors.black,),
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            minimum: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            child: BlocConsumer<KycCubit, KycState>(
              listener: (previous, current) {
                print('******//////// rutas turas');
                if (current is SuccessState && current.status == ProfileStatus.updated) {
                  showToast(context, AppStrings.SUCCESS.tr());
                  if (Get.previousRoute == '/requestinvestmentaccountscreen') {
                    // Get.back();
                    // print('hola mundo');
                    Get.to(const KycFlow());
                  }
                }
              },
              builder: (context, state) {
                if (state is SuccessState) {
                  if (state.userData.isCorporate) {
                    return CorporateProfileForm(
                      formData: CorporateCustomerProfile.fromTier(state.tiers.last),
                      excludeFilled: excludeFilled,
                      onSubmit: (requirements) =>
                          context.read<KycCubit>().updateRequirements(requirements: requirements),
                      onExternalUpdate: () => context.read<KycCubit>().fetch(),
                      onDocumentChange: (requirement) => context.read<KycCubit>().updateRequirement(
                            id: requirement.id,
                            requirement: requirement,
                          ),
                      countries: state.countries,
                    );
                  } else {
                    return IndividualProfileForm(
                      formData: IndividualCustomerProfile.fromTier(state.tiers.last),
                      excludeFilled: excludeFilled,
                      countries: state.countries,
                      onSubmit: (requirements) =>
                          context.read<KycCubit>().updateRequirements(requirements: requirements),
                      onExternalUpdate: () => context.read<KycCubit>().fetch(),
                      onDocumentChange: (requirement) => context.read<KycCubit>().updateRequirement(
                            id: requirement.id,
                            requirement: requirement,
                          ),
                    );
                  }
                } else if (state is LoadingState) {
                  return progressLoader();
                }

                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
  }
}

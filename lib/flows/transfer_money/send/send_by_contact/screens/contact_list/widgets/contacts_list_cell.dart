import 'package:Velmie/resources/colors/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../../../common/session/session_repository.dart';
import '../../../../../../../common/widgets/info_widgets.dart';
import '../../../../../../../common/widgets/user_circle_avatar.dart';
import '../../../../../../../resources/colors/custom_color_scheme.dart';
import '../../../../../../../resources/icons/icons_svg.dart';
import '../../../../../../../resources/strings/app_strings.dart';
import '../../../bloc/contacts_list_bloc.dart';
import '../../../contacts_list_flow.dart';
import '../../../entities/app_contact.dart';
import '../../send_by_contact/send_by_contact_screen.dart';

class ContactsListCellForm {
  final AppContact notification;

  ContactsListCellForm({this.notification});
}

class ContactsListCell extends StatelessWidget {
  final ContactsListCellForm form;
  final ContactsListBloc contactsListBLoC;

  const ContactsListCell({
    Key key,
    this.form,
    this.contactsListBLoC,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: double.infinity,
      child: InkWell(
        onTap: () {
          _openContactDetails(context);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            UserCircleAvatar(form.notification),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    form.notification.name,
                    style: Get.theme.textTheme.headline5.copyWith(
                      color: Get.theme.colorScheme.onBackground,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    form.notification.phoneNumber,
                    overflow: TextOverflow.ellipsis,
                    style: Get.textTheme.headline6.copyWith(
                      color: Get.theme.colorScheme.boldShade,
                    ),
                  )
                ],
              ),
            ),
            _appIcon(context),
          ],
        ),
      ),
    );
  }

  void _openContactDetails(BuildContext context) {
    if (!form.notification.isAppContact) {
      _showNonAppContactDialog(context);
      return;
    }
    final String currentUserPhone = context.read<SessionRepository>().userData.value.phoneNumber;

    if (form.notification.phoneNumber.replaceAll(" ", "").replaceAll("(", "").replaceAll(")", "").replaceAll("-", "") ==
        currentUserPhone) {
      showAlertDialog(
        context,
        title: AppStrings.ALERT.tr(),
        description: ErrorStrings.INVALID_ACCOUNT_OWNER.tr(),
      );
      return;
    }

    Get.to(SendByContactScreen(
      contact: form.notification,
      flowType: contactsListBLoC.flowType,
    ));
  }

  Widget _appIcon(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 24.0.w),
      child: Opacity(
        opacity: form.notification.isAppContact ? 1 : 0.3,
        child: Text(
          'K',
          style: TextStyle(
            fontSize: 26.ssp,
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            height: 1,
          ),
        ),
      ),
    );
  }

  void _showNonAppContactDialog(BuildContext context) {
    final bodyText =
        contactsListBLoC.flowType == ContactFlowType.send ? AppStrings.CANT_SENT_MONEY : AppStrings.CANT_REQUEST_MONEY;

    showAlertDialog(
      context,
      title: AppStrings.ALERT.tr(),
      description: bodyText.tr(),
    );
  }
}

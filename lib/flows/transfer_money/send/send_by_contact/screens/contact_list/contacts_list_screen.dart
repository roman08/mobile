import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../../../common/widgets/app_bars/base_app_bar.dart';
import '../../../../../../common/widgets/app_bars/search_bar.dart';
import '../../../../../../common/widgets/shimmering_effect/list_shimmering.dart';
import '../../../../../../resources/strings/app_strings.dart';
import '../../bloc/contacts_list_bloc.dart';
import '../../contacts_list_flow.dart';
import 'widgets/contacts_list_cell.dart';
import 'widgets/contacts_list_section.dart';

class ContactListScreen extends StatefulWidget {
  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  ContactsListBloc _contactsListBLoC;

  @override
  void initState() {
    super.initState();
    _contactsListBLoC = Provider.of<ContactsListBloc>(context, listen: false);
    _contactsListBLoC.fetchContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: SafeArea(child: _body(context)),
    );
  }

  Widget _appBar() => BaseAppBar(
        titleString: _getTitle(),
        centerTitle: true,
        backgroundColor: Get.theme.colorScheme.background,
        titleColor: Get.theme.colorScheme.onBackground,
        backIconColor: Get.theme.colorScheme.primary,
        bottom: _searchField(context),
      );

  PreferredSize _searchField(BuildContext context) {
    final bloc = Provider.of<ContactsListBloc>(context);
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight.h),
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 10.w),
        alignment: Alignment.center,
        color: Get.theme.colorScheme.onPrimary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: SearchBar(
                onSearchChange: (query) {
                  bloc.applySearch(query: query);
                },
                margin: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTitle() => _contactsListBLoC.flowType == ContactFlowType.send
      ? AppStrings.SEND_TO_CONTACT.tr()
      : AppStrings.REQUEST_FROM_CONTACT.tr();

  Widget _body(BuildContext context) {
    final bloc = Provider.of<ContactsListBloc>(context);
    return StreamBuilder<List<dynamic>>(
      stream: bloc.contactListForms,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.hasData == null) {
          return ListShimmering();
        }
        return _contactsList(context, snapshot.data);
      },
    );
  }

  Widget _contactsList(BuildContext context, List<dynamic> forms) {
    return ListView.separated(
      padding: const EdgeInsets.only(left: 12),
      separatorBuilder: (_, index) => forms[index] is ContactsListCellForm
          ? SizedBox(height: 4.h)
          : const SizedBox(),
      itemCount: forms.length,
      itemBuilder: (context, index) {
        if (forms[index] is ContactsListCellForm) {
          return ContactsListCell(
            form: forms[index],
            contactsListBLoC: _contactsListBLoC,
          );
        }
        if (forms[index] is ContactsListSectionForm) {
          return ContactsListSection(form: forms[index]);
        }
        return const SizedBox();
      },
    );
  }
}

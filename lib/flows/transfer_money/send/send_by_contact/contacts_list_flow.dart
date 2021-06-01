import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../repository/transfers_repository.dart';
import 'bloc/contacts_list_bloc.dart';
import 'screens/contact_list/contacts_list_screen.dart';
import 'screens/contact_list/contacts_permission_request_screen.dart';

enum ContactFlowType { request, send }

class ContactListFlow extends StatefulWidget {
  static const route = "ContactListFlow";

  ContactFlowType flowType;

  ContactListFlow({@required this.flowType});

  @override
  _ContactListFlowState createState() => _ContactListFlowState();
}

class _ContactListFlowState extends State<ContactListFlow> {
  ContactsListBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ContactsListBloc(
      context.repository<TransfersRepository>(),
      widget.flowType,
    );
  }

  @override
  Widget build(BuildContext context) {
    print('_ContactListFlowState');
    return Scaffold(
      body: MultiProvider(
        providers: [
          Provider<ContactsListBloc>(
            create: (context) => _bloc,
            dispose: (context, bloc) => bloc.dispose(),
          ),
        ],
        child: _body(),
      ),
    );
  }

  Widget _body() {
    return StreamBuilder<bool>(
      stream: _bloc.contactsPermissionStatus,
      builder: (context, snapshot) {
        print(snapshot);
        if (!snapshot.hasData) {
          return const SizedBox();
        }
        final value = snapshot.data ?? false;
        final child =
            value ? ContactListScreen() : ContactListPermissionsRequestScreen();
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: child,
        );
      },
    );
  }
}

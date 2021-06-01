import 'package:collection/collection.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';

import '../../../repository/transfers_repository.dart';
import '../contacts_list_flow.dart';
import '../entities/app_contact.dart';
import '../screens/contact_list/widgets/contacts_list_cell.dart';
import '../screens/contact_list/widgets/contacts_list_section.dart';

class ContactsListBloc {
  final TransfersRepository repository;

  // Just an interim solution, we have more than two states for the permission status - https://pub.dev/packages/permission_handler
  final BehaviorSubject<bool> contactsPermissionStatus = BehaviorSubject();

  ContactFlowType flowType;
  String _searchQuery;
  List<AppContact> _contacts = [];

  final BehaviorSubject<List<dynamic>> contactListForms = BehaviorSubject();

  ContactsListBloc(this.repository, this.flowType) {
    _updatePermissionStatus();
  }

  // 1. Fetches contacts from user's phone book
  // 2. Downloads contacts to the backend
  // 3. Receives from backend new contacts with flag, whether it's an registered in app
  Future<void> fetchContacts() async {
    final appContacts = await repository.fetchUserContacts();

    final contacts = await ContactsService.getContacts(withThumbnails: true, photoHighResolution: false);

    for (final appContact in appContacts) {
      final contact = contacts.firstWhere((e) {
        if (e.phones.isEmpty) {
          return false;
        }

        return e.phones.first.value.replaceAll(RegExp(r'\D'), '') ==
            appContact.phoneNumber.replaceAll(RegExp(r'\D'), '');
      }, orElse: () => null);
      if (contact != null) {
        appContact.avatar = contact.avatar;
      }
    }

    _contacts = appContacts;
    _regenerateForms();
  }

  void applySearch({String query}) {
    _searchQuery = query;
    _regenerateForms();
  }

  void requestPermissions() async {
    final permissionStatus = await Permission.contacts.status;
    if (permissionStatus.isGranted) {
      return;
    }
    if (permissionStatus.isUndetermined) {
      await Permission.contacts.request();
      _updatePermissionStatus();
      return;
    }
    openAppSettings();
  }

  // All blocks should be disposed
  void dispose() {
    contactsPermissionStatus.close();
  }

  void _updatePermissionStatus() async {
    final permissionStatus = await Permission.contacts.status;
    contactsPermissionStatus.value = permissionStatus == PermissionStatus.granted;
  }

  void _regenerateForms() {
    final List<ContactsListCellForm> contactForms = _contacts
        .where((element) => element.name.toLowerCase().contains(_searchQuery?.toLowerCase() ?? ""))
        .map((contact) => ContactsListCellForm(notification: contact))
        .toList();

    final Map<String, List<ContactsListCellForm>> groupedContracts =
        groupBy<ContactsListCellForm, String>(contactForms, (form) => form.notification.name[0].toUpperCase());
    final keys = groupedContracts.keys.toList();
    keys.sort((a, b) => a.compareTo(b));

    final forms = <dynamic>[];
    keys.forEach((key) {
      forms.add(ContactsListSectionForm(title: key));
      forms.addAll(groupedContracts[key]);
    });
    contactListForms.add(forms);
  }
}

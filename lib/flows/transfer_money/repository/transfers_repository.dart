import 'package:api_error_parser/api_error_parser.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:network_utils/network_bound_resource.dart';
import 'package:network_utils/resource.dart';

import '../../../networking/api_providers/accounts_api_provider.dart';
import '../enities/common/wallet_entity.dart';
import '../enities/tbu/tbu_preview_request.dart';
import '../enities/common/common_preview_response.dart';
import '../enities/tbu/tbu_request.dart';
import '../enities/tbu/tbu_response.dart';
import '../send/send_by_contact/entities/app_contact.dart';
import '../send/send_by_contact/entities/contact_entity.dart';
import '../send/send_by_contact/entities/contact_request_entity.dart';

class TransfersRepository {
  final ApiParser<String> _apiParser;
  final AccountsApiProvider _apiProvider;

  TransfersRepository(this._apiParser, this._apiProvider);

  String cleanNumber(String number) {
    return number.replaceAll(RegExp(r'[^\d+]'), '');
  }

  Future<List<AppContact>> fetchUserContacts() async {
    final List<Contact> contacts = await _loadUserAddressBook();
    // We take only first phone number for now
    final List<String> phoneNumbersToCheck =
        contacts.map((contact) => cleanNumber(contact.phones.first.value)).toList();
    contacts.map((contact) => cleanNumber(contact.phones.first.value)).toList();

    final ContactEntity appNumbers = await findAppContacts(phoneNumbersToCheck);

    return contacts.map((contact) {
      return AppContact(
          name: contact.displayName,
          uid: appNumbers.data
                  .firstWhere((element) => cleanNumber(contact.phones.first.value) == cleanNumber(element.phoneNumber),
                      orElse: () => null)
                  ?.uid ??
              '',
          phoneNumber: contact.phones.first.value,
          isAppContact: cleanNumber(contact.phones.first.value) ==
                  appNumbers.data
                      .firstWhere(
                          (element) => cleanNumber(contact.phones.first.value) == cleanNumber(element.phoneNumber),
                          orElse: () => null)
                      ?.phoneNumber ??
              false);
    }).toList();
  }

  Future<List<Contact>> _loadUserAddressBook() async {
    final contacts = await ContactsService.getContacts(withThumbnails: false, photoHighResolution: false);
    return contacts.where((contact) => contact?.displayName?.isNotEmpty != null && contact.phones.isNotEmpty).toList();
  }

  Future<ContactEntity> findAppContacts(List<String> phones) async {
    final ContactRequestEntity requestModel = ContactRequestEntity(phoneNumbers: phones);
    return _apiProvider.findContacts(requestModel);
  }

  Future<List<WalletEntity>> getWallets(String uid) async {
    return _apiProvider.getWalletsByUid(uid);
  }

  Stream<Resource<CommonPreviewResponse, String>> tbuPreview(TbuPreviewRequest requestData) {
    final networkClient = NetworkBoundResource<CommonPreviewResponse, CommonPreviewResponse, String>(
      _apiParser,
      saveCallResult: (CommonPreviewResponse item) async => item,
      createCall: () => _apiProvider.tbuPreview(requestData),
      loadFromCache: () => null,
      shouldFetch: (data) => true,
    );
    return networkClient.asStream();
  }

  Stream<Resource<TbuResponse, String>> tbu(
    TbuRequest requestModel,
  ) {
    final networkClient = NetworkBoundResource<TbuResponse, TbuResponse, String>(
      _apiParser,
      saveCallResult: (TbuResponse item) async => item,
      createCall: () => _apiProvider.tbu(requestModel),
      loadFromCache: () => null,
      shouldFetch: (data) => true,
    );
    return networkClient.asStream();
  }
}

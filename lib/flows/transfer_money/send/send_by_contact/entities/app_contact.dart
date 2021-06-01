import 'dart:typed_data';

/// Mapped app model, used in contacts list
class AppContact {
  final String name;
  final String phoneNumber;
  final String uid;
  final bool isAppContact;
  Uint8List avatar;

  String get userInitials => name.isEmpty ? '' : name[0].toUpperCase();

  AppContact({
    this.name,
    this.phoneNumber,
    this.uid,
    this.isAppContact,
    this.avatar,
  });

  @override
  String toString() {
    return 'AppContact{name: $name, phoneNumber: $phoneNumber, uid: $uid, isAppContact: $isAppContact}';
  }
}

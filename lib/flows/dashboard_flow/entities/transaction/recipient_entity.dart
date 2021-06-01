import 'account_entity.dart';
import 'profile_entity.dart';

class RecipientEntity {
  RecipientEntity({
    this.account,
    this.profile,
  });

  AccountEntity account;
  ProfileEntity profile;

  factory RecipientEntity.fromJson(Map<String, dynamic> json) => RecipientEntity(
        account: json["account"] == null ? null : AccountEntity.fromJson(json["account"]),
        profile: ProfileEntity.fromJson(json["profile"]),
      );

  @override
  String toString() {
    return "RecipientEntity { account = $account, profile = $profile}";
  }
}

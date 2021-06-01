import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../flows/sign_in_flow/entities/user.dart';
import 'cache.dart';

class CacheRepository {
  CacheRepository({@required this.cache});

  final Cache cache;
  final BehaviorSubject<UserData> userDataStream = BehaviorSubject();

  void addUserData(UserData data) {
    cache.add(data);
    userDataStream.add(data);
  }

  void updateUserData(UserData data) {
    cache.add(data);
    userDataStream.add(data);
  }

  void clearAll() {
    cache.clear();
    userDataStream.add(null);
  }
}

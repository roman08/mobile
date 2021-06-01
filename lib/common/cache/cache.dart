import 'package:flutter/cupertino.dart';

import '../../app.dart';
import 'cache_control_policy.dart';
import 'cache_entity.dart';

class Cache {
  Cache({@required this.cacheControlPolicy});

  final Map<String, CacheEntity> _memoryCache = {};

  final CacheControlPolicy cacheControlPolicy;

  void add<T>(T data, {String key}) {
    key ??= T.toString();
    if (_memoryCache.containsKey(key)) {
      _memoryCache.update(key, (value) {
        logger.d('old value before update: $value');
        return;
      });
    } else {
      _memoryCache[key] = CacheEntity(
          data: data, expDate: DateTime.now().add(cacheControlPolicy.maxAge));
    }
  }

  T get<T>({String key}) {
    key ??= T.toString();
    if (!_memoryCache.containsKey(key)) {
      return null;
    }
    final CacheEntity cacheEntity = _memoryCache[key];
    if (cacheEntity.expDate.isBefore(DateTime.now())) {
      _memoryCache.remove(key);
      return null;
    }
    return cacheEntity.data as T;
  }

  void remove<T>({String key}) {
    key ??= T.toString();
    _memoryCache.remove(key);
  }

  void clear() {
    _memoryCache.clear();
  }
}

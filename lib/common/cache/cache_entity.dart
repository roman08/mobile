class CacheEntity<T> {
  CacheEntity({this.data, this.expDate});

  final T data;
  final DateTime expDate;
}

class CacheControlPolicy {
  CacheControlPolicy({this.maxAge = const Duration(minutes: 10)});

  final Duration maxAge;
}

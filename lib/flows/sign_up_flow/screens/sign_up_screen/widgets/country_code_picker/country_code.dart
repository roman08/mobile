mixin ToAlias {}

@deprecated
class CElement = CountryCode with ToAlias;

/// Country element. This is the element that contains all the information
class CountryCode {
  CountryCode({this.name, this.code, this.dialCode});

  /// the name of the country
  String name;

  /// the country code (IT,AF..)
  String code;

  /// the dial code (+39,+93..)
  String dialCode;

  @override
  String toString() => '$dialCode';

  String toLongString() => '$dialCode $name';

  String toCountryStringOnly() => '$name';
}

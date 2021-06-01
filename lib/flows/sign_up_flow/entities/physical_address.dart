class PhysicalAddress {
  final String address;
  final String addressSecondLine;
  final String city;
  final String countryIsoTwo;
  final String description;
  final double latitude;
  final double longitude;
  final String region;
  final String zipCode;

  PhysicalAddress({
    this.address,
    this.addressSecondLine,
    this.city,
    this.countryIsoTwo,
    this.description,
    this.latitude,
    this.longitude,
    this.region,
    this.zipCode,
  });

  factory PhysicalAddress.fromJson(Map<String, dynamic> json) {
    return PhysicalAddress(
      address: json['address'],
      addressSecondLine: json['addressSecondLine'],
      city: json['city'],
      countryIsoTwo: json['countryIsoTwo'],
      description: json['description'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      region: json['region'],
      zipCode: json['zipCode'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = this.address;
    data['addressSecondLine'] = this.addressSecondLine;
    data['city'] = this.city;
    data['countryIsoTwo'] = this.countryIsoTwo;
    data['description'] = this.description;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['region'] = this.region;
    data['zipCode'] = this.zipCode;
    return data;
  }

  @override
  String toString() {
    return 'PhysicalAddress{address: $address, addressSecondLine: $addressSecondLine, city: $city, countryIsoTwo: $countryIsoTwo, description: $description, latitude: $latitude, longitude: $longitude, region: $region, zipCode: $zipCode}';
  }

}
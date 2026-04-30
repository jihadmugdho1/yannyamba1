class Address {
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final double latitude;
  final double longitude;

  Address({
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.latitude,
    required this.longitude,
  });

  String get fullAddress => '$street, $city';

  // JSON serialization for API
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      zipCode: json['zipCode'] ?? json['zip_code'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

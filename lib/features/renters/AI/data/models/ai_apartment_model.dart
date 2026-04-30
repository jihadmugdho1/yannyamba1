class AIApartment {
  final String id;
  final String listingType;
  final String propertyCategory;
  final String location;
  final String about;
  final int bedrooms;
  final int bathrooms;
  final double? dailyRate;
  final double? monthlyRent;

  AIApartment({
    required this.id,
    required this.listingType,
    required this.propertyCategory,
    required this.location,
    required this.about,
    required this.bedrooms,
    required this.bathrooms,
    this.dailyRate,
    this.monthlyRent,
  });

  factory AIApartment.fromJson(Map<String, dynamic> json) {
    return AIApartment(
      id: json['id'] as String,
      listingType: json['listing_type'] as String,
      propertyCategory: json['property_category'] as String,
      location: json['location'] as String,
      about: json['about'] as String,
      bedrooms: json['bedrooms'] as int,
      bathrooms: json['bathrooms'] as int,
      dailyRate: json['daily_rate'] != null
          ? (json['daily_rate'] as num).toDouble()
          : null,
      monthlyRent: json['monthly_rent'] != null
          ? (json['monthly_rent'] as num).toDouble()
          : null,
    );
  }
}

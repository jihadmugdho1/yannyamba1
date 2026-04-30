/// Model for property features and amenities data
class FeaturesAmenitiesData {
  final List<String> propertyFeatures;
  final List<String> amenities;
  final List<String> furnishings;
  final List<String> houseRules;

  const FeaturesAmenitiesData({
    required this.propertyFeatures,
    required this.amenities,
    required this.furnishings,
    required this.houseRules,
  });

  /// Create from JSON (for future API integration)
  factory FeaturesAmenitiesData.fromJson(Map<String, dynamic> json) {
    return FeaturesAmenitiesData(
      propertyFeatures: List<String>.from(json['propertyFeatures'] ?? []),
      amenities: List<String>.from(json['amenities'] ?? []),
      furnishings: List<String>.from(json['furnishings'] ?? []),
      houseRules: List<String>.from(json['houseRules'] ?? []),
    );
  }

  /// Convert to JSON (for future API integration)
  Map<String, dynamic> toJson() {
    return {
      'propertyFeatures': propertyFeatures,
      'amenities': amenities,
      'furnishings': furnishings,
      'houseRules': houseRules,
    };
  }
}

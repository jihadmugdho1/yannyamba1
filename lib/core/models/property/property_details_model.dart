class PropertyDetails {
  final String propertyType;
  final double squareFeet;
  final int advanceMonths;
  final int depositMonths;
  final double distanceToDowntown;

  PropertyDetails({
    required this.propertyType,
    required this.squareFeet,
    required this.advanceMonths,
    required this.depositMonths,
    required this.distanceToDowntown,
  });

  // JSON serialization for API
  factory PropertyDetails.fromJson(Map<String, dynamic> json) {
    return PropertyDetails(
      propertyType: json['propertyType'] ?? json['property_type'] ?? '',
      squareFeet: (json['squareFeet'] ?? json['square_feet'] ?? 0.0).toDouble(),
      advanceMonths: json['advanceMonths'] ?? json['advance_months'] ?? 0,
      depositMonths: json['depositMonths'] ?? json['deposit_months'] ?? 0,
      distanceToDowntown:
          (json['distanceToDowntown'] ?? json['distance_to_downtown'] ?? 0.0)
              .toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'propertyType': propertyType,
      'squareFeet': squareFeet,
      'advanceMonths': advanceMonths,
      'depositMonths': depositMonths,
      'distanceToDowntown': distanceToDowntown,
    };
  }
}

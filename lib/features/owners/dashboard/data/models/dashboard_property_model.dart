class DashboardProperty {
  final String id;
  final String propertyCategory;
  final int propertySize;
  final String about;
  final String cityName;
  final String neighborhood;
  final String distanceToMainRoad;
  final String nearbyLandmarks;
  final List<String> images;
  final String ownerName;
  final String ownerPhone;
  final double dailyRate;
  final int minimumStayDays;
  final int maximumStayDays;
  final int? bedrooms;
  final int? bathrooms;
  final int? officeRooms;
  final int? officeConferenceRooms;
  final int? officeWorkstations;
  final String? advancePayment;
  final String? securityDeposit;
  final List<String> propertyFeatures;
  final List<String> buildingAmenities;
  final List<String> houseRules;
  final List<String> whatsIncluded;
  final bool isApproved;
  final bool isHidden;
  final int viewCount;
  final int queryCount;
  final DateTime createdAt;

  const DashboardProperty({
    required this.id,
    required this.propertyCategory,
    required this.propertySize,
    required this.about,
    required this.cityName,
    required this.neighborhood,
    required this.distanceToMainRoad,
    required this.nearbyLandmarks,
    required this.images,
    required this.ownerName,
    required this.ownerPhone,
    required this.dailyRate,
    required this.minimumStayDays,
    required this.maximumStayDays,
    this.bedrooms,
    this.bathrooms,
    this.officeRooms,
    this.officeConferenceRooms,
    this.officeWorkstations,
    this.advancePayment,
    this.securityDeposit,
    required this.propertyFeatures,
    required this.buildingAmenities,
    required this.houseRules,
    required this.whatsIncluded,
    required this.isApproved,
    required this.isHidden,
    required this.viewCount,
    required this.queryCount,
    required this.createdAt,
  });

  bool get isShortTerm => minimumStayDays <= 15;
  bool get isLongTerm => minimumStayDays >= 16;
  bool get isOffice => propertyCategory == 'Office';

  String get displayTitle {
    if (isOffice) {
      return '${officeWorkstations ?? 1} Workstations Office — $neighborhood';
    }
    return '${bedrooms ?? 1} Bed $propertyCategory — $neighborhood';
  }

  String get priceLabel => '₣ ${dailyRate.toStringAsFixed(0)}/day';

  String get stayTypeLabel => isShortTerm ? 'Short Term' : 'Long Term';

  String get firstImageUrl => images.isNotEmpty ? images.first : '';

  factory DashboardProperty.fromJson(Map<String, dynamic> json) {
    return DashboardProperty(
      id: json['_id'] as String? ?? '',
      propertyCategory: json['property_category'] as String? ?? 'Home',
      propertySize: (json['property_size'] as num?)?.toInt() ?? 0,
      about: json['about'] as String? ?? '',
      cityName: json['city_name'] as String? ?? '',
      neighborhood: json['neighborhood'] as String? ?? '',
      distanceToMainRoad: json['distance_to_main_road'] as String? ?? '',
      nearbyLandmarks: json['nearby_landmarks'] as String? ?? '',
      images: (json['images'] as List?)
              ?.map((img) => img is Map ? (img['link'] as String? ?? '') : img.toString())
              .where((url) => url.isNotEmpty)
              .toList() ??
          [],
      ownerName: json['owner_name'] as String? ?? '',
      ownerPhone: json['owner_phone'] as String? ?? '',
      dailyRate: (json['daily_rate'] as num?)?.toDouble() ?? 0.0,
      minimumStayDays: (json['minimum_stay_days'] as num?)?.toInt() ?? 1,
      maximumStayDays: (json['maximum_stay_days'] as num?)?.toInt() ?? 15,
      bedrooms: (json['bedrooms'] as num?)?.toInt(),
      bathrooms: (json['bathrooms'] as num?)?.toInt(),
      officeRooms: (json['office_rooms'] as num?)?.toInt(),
      officeConferenceRooms: (json['office_conference_rooms'] as num?)?.toInt(),
      officeWorkstations: (json['office_workstations'] as num?)?.toInt(),
      advancePayment: json['advance_payment']?.toString(),
      securityDeposit: json['security_deposit']?.toString(),
      propertyFeatures: (json['property_features'] as List?)?.cast<String>() ?? [],
      buildingAmenities: (json['building_amenities'] as List?)?.cast<String>() ?? [],
      houseRules: (json['house_rules'] as List?)?.cast<String>() ?? [],
      whatsIncluded: (json['whats_included'] as List?)?.cast<String>() ?? [],
      isApproved: json['isApproved'] as bool? ?? false,
      isHidden: json['isHidden'] as bool? ?? false,
      viewCount: (json['viewedBy'] as List?)?.length ?? 0,
      queryCount: (json['queryBy'] as List?)?.length ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
    );
  }
}

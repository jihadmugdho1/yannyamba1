/// Dashboard statistics model for property owners
class DashboardStats {
  final int totalViews;
  final int inquiries;
  final int activeListings;
  final int totalProperties;

  DashboardStats({
    required this.totalViews,
    required this.inquiries,
    required this.activeListings,
    required this.totalProperties,
  });

  // JSON serialization for API
  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalViews: json['totalViews'] ?? 0,
      inquiries: json['totalQueries'] ?? 0,
      activeListings: json['totalApartments'] ?? 0,
      totalProperties: json['totalApartments'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalViews': totalViews,
      'inquiries': inquiries,
      'activeListings': activeListings,
      'totalProperties': totalProperties,
    };
  }
}

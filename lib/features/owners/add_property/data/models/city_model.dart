class CityModel {
  final String id;
  final String cityName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CityModel({
    required this.id,
    required this.cityName,
    this.createdAt,
    this.updatedAt,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['_id']?.toString() ?? '',
      cityName: json['cityName']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? ''),
    );
  }
}

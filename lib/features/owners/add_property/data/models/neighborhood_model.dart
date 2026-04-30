class NeighborhoodModel {
  final String id;
  final String name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const NeighborhoodModel({
    required this.id,
    required this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory NeighborhoodModel.fromJson(Map<String, dynamic> json) {
    return NeighborhoodModel(
      id: json['_id']?.toString() ?? '',
      name: json['neiborhoodName']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? ''),
    );
  }
}

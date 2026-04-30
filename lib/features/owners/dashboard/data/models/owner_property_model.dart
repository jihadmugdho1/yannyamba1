import 'package:yannyamba/core/models/property/property_models.dart';

/// Owner's property with additional statistics
class OwnerProperty extends Apartment {
  final int views;
  final int inquiries;
  final bool isActive;

  OwnerProperty({
    required super.id,
    required super.title,
    required super.address,
    required super.type,
    required super.rent,
    required super.advancePayment,
    required super.size,
    required super.rooms,
    required super.washrooms,
    required super.distanceToDowntown,
    required super.images,
    required super.contacts,
    required super.about,
    required super.propertyDetails,
    required super.features,
    required super.amenities,
    required super.details,
    required this.views,
    required this.inquiries,
    this.isActive = true,
  });

  // JSON serialization for API
  factory OwnerProperty.fromJson(Map<String, dynamic> json) {
    final apartment = Apartment.fromJson(json);
    return OwnerProperty(
      id: apartment.id,
      title: apartment.title,
      address: apartment.address,
      type: apartment.type,
      rent: apartment.rent,
      advancePayment: apartment.advancePayment,
      size: apartment.size,
      rooms: apartment.rooms,
      washrooms: apartment.washrooms,
      distanceToDowntown: apartment.distanceToDowntown,
      images: apartment.images,
      contacts: apartment.contacts,
      about: apartment.about,
      propertyDetails: apartment.propertyDetails,
      features: apartment.features,
      amenities: apartment.amenities,
      details: apartment.details,

      views: json['views'] ?? 0,
      inquiries: json['inquiries'] ?? 0,
      isActive: json['isActive'] ?? json['is_active'] ?? true,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['views'] = views;
    json['inquiries'] = inquiries;
    json['isActive'] = isActive;
    return json;
  }
}

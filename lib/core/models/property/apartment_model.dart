import 'contact_model.dart';
import 'property_details_model.dart';
import 'address_model.dart';

class Apartment {
  final String id;
  final String title;
  final Address address;
  final String type;
  final double rent;
  final double advancePayment;
  final double size;
  final int rooms;
  final int washrooms;
  final double distanceToDowntown;
  final List<String> images;
  final List<Contact> contacts;
  final String about;
  final PropertyDetails propertyDetails;
  final List<String> features;
  final List<String> amenities;
  final String details;
  final int? totalViews;
  final int? inquiries;

  Apartment({
    required this.id,
    required this.title,
    required this.address,
    required this.type,
    required this.rent,
    required this.advancePayment,
    required this.size,
    required this.rooms,
    required this.washrooms,
    required this.distanceToDowntown,
    required this.images,
    required this.contacts,
    required this.about,
    required this.propertyDetails,
    required this.features,
    required this.amenities,
    required this.details,
    this.totalViews,
    this.inquiries,
  });

  // Convenience getters
  Contact? get owner => contacts.where((c) => c.isOwner).firstOrNull;
  Contact? get mainContact =>
      contacts.where((c) => c.isPrimary).firstOrNull ?? owner;
  List<Contact> get referenceContacts =>
      contacts.where((c) => !c.isPrimary).toList();

  List<Contact> getContactsByRelationship(String relationship) {
    return contacts
        .where(
          (c) => c.relationship.toLowerCase() == relationship.toLowerCase(),
        )
        .toList();
  }

  // JSON serialization for API
  factory Apartment.fromJson(Map<String, dynamic> json) {
    // Handle both direct JSON and API response format
    final id = json['_id']?.toString() ?? json['id']?.toString() ?? '';

    // Extract image URLs from API format
    final List<String> imageUrls = [];
    if (json['images'] != null) {
      if (json['images'] is List) {
        for (var img in json['images']) {
          if (img is Map && img['link'] != null) {
            imageUrls.add(img['link']);
          } else if (img is String) {
            imageUrls.add(img);
          }
        }
      }
    }

    // Create address from API fields
    final address = Address(
      street: json['neighborhood'] ?? json['address']?['street'] ?? '',
      city: json['city_name'] ?? json['address']?['city'] ?? '',
      state: json['address']?['state'] ?? '',
      zipCode:
          json['address']?['zipCode'] ?? json['address']?['zip_code'] ?? '',
      latitude: (json['address']?['latitude'] ?? 0.0).toDouble(),
      longitude: (json['address']?['longitude'] ?? 0.0).toDouble(),
    );

    // Create contact from owner information
    final List<Contact> contacts = [];
    if (json['owner_name'] != null || json['owner_phone'] != null) {
      contacts.add(
        Contact(
          name: json['owner_name'] ?? 'Owner',
          phone: json['owner_phone'] ?? '',
          email: '',
          relationship: 'Owner',
          isPrimary: true,
        ),
      );
    }

    // Add references as contacts if available
    if (json['references'] != null && json['references'] is List) {
      for (var ref in json['references']) {
        if (ref is Map) {
          contacts.add(
            Contact(
              name: ref['reference_name'] ?? '',
              phone: ref['reference_phone'] ?? '',
              email: '',
              relationship: ref['reference_relationship'] ?? 'Reference',
              isPrimary: false,
            ),
          );
        }
      }
    }

    // Extract property details
    final propertyDetails = PropertyDetails(
      propertyType: json['property_category'] ?? 'Home',
      squareFeet: (json['property_size'] ?? 0).toDouble(),
      advanceMonths: _parseMonths(json['advance_payment']),
      depositMonths: _parseMonths(json['security_deposit']),
      distanceToDowntown: _parseDistance(json['distance_to_main_road']),
    );

    // Extract rooms/bedrooms
    final rooms =
        json['bedrooms'] ?? json['rooms'] ?? json['office_rooms'] ?? 0;
    final washrooms = json['bathrooms'] ?? json['washrooms'] ?? 1;

    // Parse monthly rent
    final rent = (json['monthly_rent'] ?? json['rent'] ?? 0.0).toDouble();

    return Apartment(
      id: id,
      title: _generateTitle(json),
      address: address,
      type: json['property_category'] ?? json['type'] ?? 'Home',
      rent: rent,
      advancePayment: rent * _parseMonths(json['advance_payment']),
      size: (json['property_size'] ?? json['size'] ?? 0.0).toDouble(),
      rooms: rooms,
      washrooms: washrooms,
      distanceToDowntown: _parseDistance(
        json['distance_to_main_road'] ?? json['distance_to_downtown'],
      ),
      images: imageUrls,
      contacts: contacts,
      about: json['about'] ?? '',
      propertyDetails: propertyDetails,
      features: List<String>.from(
        json['property_features'] ?? json['features'] ?? [],
      ),
      amenities: List<String>.from(
        json['building_amenities'] ?? json['amenities'] ?? [],
      ),
      details: json['details'] ?? json['about'] ?? '',
      totalViews: (json['viewedBy'] is List) ? json['viewedBy'].length : 0,
      inquiries: (json['queryBy'] is List) ? json['queryBy'].length : 0,
    );
  }

  // Helper method to generate title from API data
  static String _generateTitle(Map<String, dynamic> json) {
    if (json['title'] != null) return json['title'];

    final category = json['property_category'] ?? 'Property';
    final bedrooms = json['bedrooms'] ?? json['office_rooms'];
    final city = json['city_name'] ?? '';

    if (bedrooms != null && bedrooms > 0) {
      return '$bedrooms BR $category in $city';
    }
    return '$category in $city';
  }

  // Helper method to parse distance string to double
  static double _parseDistance(dynamic distance) {
    if (distance == null) return 0.0;
    if (distance is num) return distance.toDouble();
    if (distance is String) {
      // Extract numeric value from strings like "200m" or "1.5km"
      final numStr = distance.replaceAll(RegExp(r'[^0-9.]'), '');
      final value = double.tryParse(numStr) ?? 0.0;

      // Convert km to same unit if needed
      if (distance.toLowerCase().contains('km')) {
        return value;
      }
      // Convert meters to km
      if (distance.toLowerCase().contains('m')) {
        return value / 1000;
      }
      return value;
    }
    return 0.0;
  }

  // Helper method to parse months from string like "2 months" or number
  static int _parseMonths(dynamic months) {
    if (months == null) return 1;
    if (months is int) return months;
    if (months is String) {
      // Extract numeric value from strings like "2 months"
      final numStr = months.replaceAll(RegExp(r'[^0-9]'), '');
      return int.tryParse(numStr) ?? 1;
    }
    return 1;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'address': address.toJson(),
      'type': type,
      'rent': rent,
      'advancePayment': advancePayment,
      'size': size,
      'rooms': rooms,
      'washrooms': washrooms,
      'distanceToDowntown': distanceToDowntown,
      'images': images,
      'contacts': contacts.map((c) => c.toJson()).toList(),
      'about': about,
      'propertyDetails': propertyDetails.toJson(),
      'features': features,
      'amenities': amenities,
      'details': details,
    };
  }
}

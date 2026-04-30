import 'apartment_model.dart';
import 'contact_model.dart';
import 'property_details_model.dart';
import 'address_model.dart';

/// Model for furnished apartments with daily/short-term rental capabilities
class FurnishedApartment extends Apartment {
  final double dailyRate;
  final int minimumStay; // in days
  final int maximumStay; // in days
  final List<DateTime> blockedDates;
  final List<Booking> bookings;
  final List<String> furnishings;
  final String checkInTime;
  final String checkOutTime;
  final String cancellationPolicy;
  final List<String> houseRules;

  FurnishedApartment({
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
    super.totalViews,
    super.inquiries,

    required this.dailyRate,
    this.minimumStay = 1,
    this.maximumStay = 30,
    this.blockedDates = const [],
    this.bookings = const [],
    this.furnishings = const [],
    this.checkInTime = '14:00',
    this.checkOutTime = '11:00',
    this.cancellationPolicy = 'Flexible',
    this.houseRules = const [],
  });

  // Calculate total price for a stay
  double calculateTotalPrice(DateTime checkIn, DateTime checkOut) {
    final nights = checkOut.difference(checkIn).inDays;
    return dailyRate * nights;
  }

  // Check if dates are available
  bool isAvailable(DateTime checkIn, DateTime checkOut) {
    // Normalize dates to remove time component for accurate comparison
    final normalizedCheckIn = _normalizeDate(checkIn);
    final normalizedCheckOut = _normalizeDate(checkOut);

    // Check if any blocked dates fall within the requested range
    for (var blockedDate in blockedDates) {
      final normalizedBlocked = _normalizeDate(blockedDate);

      // Check if blocked date is within or on the boundaries of the stay period
      if ((normalizedBlocked.isAfter(normalizedCheckIn) ||
              normalizedBlocked.isAtSameMomentAs(normalizedCheckIn)) &&
          (normalizedBlocked.isBefore(normalizedCheckOut) ||
              normalizedBlocked.isAtSameMomentAs(normalizedCheckOut))) {
        return false;
      }
    }

    // Check existing bookings for conflicts
    for (var booking in bookings) {
      // Skip cancelled bookings
      if (booking.status == BookingStatus.cancelled) {
        continue;
      }

      final bookingCheckIn = _normalizeDate(booking.checkInDate);
      final bookingCheckOut = _normalizeDate(booking.checkOutDate);

      // Check for any overlap between requested dates and existing booking
      // Overlap occurs if:
      // 1. Check-in falls within existing booking
      // 2. Check-out falls within existing booking
      // 3. Requested period completely contains existing booking
      // 4. Dates are exactly the same
      if (_hasDateOverlap(
        normalizedCheckIn,
        normalizedCheckOut,
        bookingCheckIn,
        bookingCheckOut,
      )) {
        return false;
      }
    }

    return true;
  }

  /// Helper method to normalize date (remove time component)
  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Helper method to check if two date ranges overlap
  bool _hasDateOverlap(
    DateTime start1,
    DateTime end1,
    DateTime start2,
    DateTime end2,
  ) {
    // Two ranges overlap if:
    // start1 < end2 AND start2 < end1
    // This covers all overlap scenarios including:
    // - Partial overlap from either side
    // - One range completely containing the other
    // - Exact same dates
    return start1.isBefore(end2) && start2.isBefore(end1);
  }

  factory FurnishedApartment.fromJson(Map<String, dynamic> json) {
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
      advanceMonths: 1,
      depositMonths: 1,
      distanceToDowntown: _parseDistance(json['distance_to_main_road']),
    );

    // Extract rooms/bedrooms
    final rooms =
        json['bedrooms'] ?? json['rooms'] ?? json['office_rooms'] ?? 0;
    final washrooms = json['bathrooms'] ?? json['washrooms'] ?? 1;

    return FurnishedApartment(
      id: id,
      title: _generateTitle(json),
      address: address,
      type: json['listing_type'] ?? json['type'] ?? 'Furnished',
      rent: (json['rent'] ?? 0.0).toDouble(),
      advancePayment: (json['advancePayment'] ?? json['advance_payment'] ?? 0.0)
          .toDouble(),
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
      dailyRate: (json['daily_rate'] ?? json['dailyRate'] ?? 0.0).toDouble(),
      minimumStay:
          json['minimum_stay_days'] ??
          json['minimumStay'] ??
          json['minimum_stay'] ??
          1,
      maximumStay:
          json['maximum_stay_days'] ??
          json['maximumStay'] ??
          json['maximum_stay'] ??
          30,
      blockedDates: _parseBlockedDates(
        json['blocked_dates'] ?? json['blockedDates'],
      ),
      bookings: _parseBookings(json['booking_dates'] ?? json['bookings']),
      furnishings: List<String>.from(
        json['whats_included'] ?? json['furnishings'] ?? [],
      ),
      checkInTime: json['checkInTime'] ?? json['check_in_time'] ?? '14:00',
      checkOutTime: json['checkOutTime'] ?? json['check_out_time'] ?? '11:00',
      cancellationPolicy:
          json['cancellationPolicy'] ??
          json['cancellation_policy'] ??
          'Flexible',
      houseRules: List<String>.from(
        json['house_rules'] ?? json['houseRules'] ?? [],
      ),
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

  // Helper method to parse blocked dates
  static List<DateTime> _parseBlockedDates(dynamic dates) {
    if (dates == null) return [];
    if (dates is! List) return [];

    return dates
        .where((date) => date != null)
        .map<DateTime?>((date) {
          try {
            if (date is String) return DateTime.parse(date);
            if (date is Map && date['date'] != null) {
              return DateTime.parse(date['date']);
            }
          } catch (e) {
            return null;
          }
          return null;
        })
        .whereType<DateTime>()
        .toList();
  }

  // Helper method to parse bookings or booking dates
  static List<Booking> _parseBookings(dynamic bookings) {
    if (bookings == null) return [];
    if (bookings is! List) return [];

    final List<Booking> result = [];

    for (var item in bookings) {
      try {
        // Handle booking date strings (e.g., "04/01/2026" or "11/12/2025")
        if (item is String) {
          // Parse date string - API sends DD/MM/YYYY format
          final parts = item.split('/');
          if (parts.length == 3) {
            final day = int.tryParse(parts[0]);
            final month = int.tryParse(parts[1]);
            final year = int.tryParse(parts[2]);

            if (month != null && day != null && year != null) {
              final date = DateTime(year, month, day);
              // Create a booking for that single day
              result.add(
                Booking(
                  id: 'booked_$item',
                  guestName: 'Booked',
                  guestContact: '',
                  checkInDate: date,
                  checkOutDate: date.add(const Duration(days: 1)),
                  totalPrice: 0,
                  status: BookingStatus.confirmed,
                  createdAt: DateTime.now(),
                ),
              );
            }
          }
        }
        // Handle full booking objects
        else if (item is Map) {
          result.add(Booking.fromJson(Map<String, dynamic>.from(item)));
        }
      } catch (e) {
        // Skip invalid entries
      }
    }

    return result;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> baseJson = super.toJson();
    baseJson.addAll({
      'dailyRate': dailyRate,
      'minimumStay': minimumStay,
      'maximumStay': maximumStay,
      'blockedDates': blockedDates
          .map((date) => date.toIso8601String())
          .toList(),
      'bookings': bookings.map((booking) => booking.toJson()).toList(),
      'furnishings': furnishings,
      'checkInTime': checkInTime,
      'checkOutTime': checkOutTime,
      'cancellationPolicy': cancellationPolicy,
      'houseRules': houseRules,
    });
    return baseJson;
  }

  // Copy with method
  FurnishedApartment copyWith({
    String? id,
    String? title,
    Address? address,
    String? type,
    double? rent,
    double? advancePayment,
    double? size,
    int? rooms,
    int? washrooms,
    double? distanceToDowntown,
    List<String>? images,
    List<Contact>? contacts,
    String? about,
    PropertyDetails? propertyDetails,
    List<String>? features,
    List<String>? amenities,
    String? details,
    double? dailyRate,
    int? minimumStay,
    int? maximumStay,
    List<DateTime>? blockedDates,
    List<Booking>? bookings,
    List<String>? furnishings,
    String? checkInTime,
    String? checkOutTime,
    String? cancellationPolicy,
    List<String>? houseRules,
  }) {
    return FurnishedApartment(
      id: id ?? this.id,
      title: title ?? this.title,
      address: address ?? this.address,
      type: type ?? this.type,
      rent: rent ?? this.rent,
      advancePayment: advancePayment ?? this.advancePayment,
      size: size ?? this.size,
      rooms: rooms ?? this.rooms,
      washrooms: washrooms ?? this.washrooms,
      distanceToDowntown: distanceToDowntown ?? this.distanceToDowntown,
      images: images ?? this.images,
      contacts: contacts ?? this.contacts,
      about: about ?? this.about,
      propertyDetails: propertyDetails ?? this.propertyDetails,
      features: features ?? this.features,
      amenities: amenities ?? this.amenities,
      details: details ?? this.details,
      dailyRate: dailyRate ?? this.dailyRate,
      minimumStay: minimumStay ?? this.minimumStay,
      maximumStay: maximumStay ?? this.maximumStay,
      blockedDates: blockedDates ?? this.blockedDates,
      bookings: bookings ?? this.bookings,
      furnishings: furnishings ?? this.furnishings,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      cancellationPolicy: cancellationPolicy ?? this.cancellationPolicy,
      houseRules: houseRules ?? this.houseRules,
    );
  }
}

/// Booking model for tracking reservations
class Booking {
  final String id;
  final String guestName;
  final String guestContact;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final double totalPrice;
  final BookingStatus status;
  final DateTime createdAt;

  Booking({
    required this.id,
    required this.guestName,
    required this.guestContact,
    required this.checkInDate,
    required this.checkOutDate,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
  });

  int get nights => checkOutDate.difference(checkInDate).inDays;

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id']?.toString() ?? '',
      guestName: json['guestName'] ?? json['guest_name'] ?? '',
      guestContact: json['guestContact'] ?? json['guest_contact'] ?? '',
      checkInDate: DateTime.parse(json['checkInDate'] ?? json['check_in_date']),
      checkOutDate: DateTime.parse(
        json['checkOutDate'] ?? json['check_out_date'],
      ),
      totalPrice: (json['totalPrice'] ?? json['total_price'] ?? 0.0).toDouble(),
      status: BookingStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => BookingStatus.pending,
      ),
      createdAt: DateTime.parse(json['createdAt'] ?? json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'guestName': guestName,
      'guestContact': guestContact,
      'checkInDate': checkInDate.toIso8601String(),
      'checkOutDate': checkOutDate.toIso8601String(),
      'totalPrice': totalPrice,
      'status': status.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

enum BookingStatus { pending, confirmed, cancelled, completed }

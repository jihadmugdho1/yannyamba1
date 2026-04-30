class BookingCustomer {
  final String id;
  final String name;
  final String phone;
  final String email;

  const BookingCustomer({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
  });

  factory BookingCustomer.fromJson(Map<String, dynamic> json) {
    return BookingCustomer(
      id: (json['_id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
    );
  }
}

class BookingApartmentImage {
  final String link;

  const BookingApartmentImage({required this.link});

  factory BookingApartmentImage.fromJson(Map<String, dynamic> json) {
    return BookingApartmentImage(link: (json['link'] ?? '').toString());
  }
}

class BookingApartmentSummary {
  final String id;
  final String listingType;
  final String propertyCategory;
  final String cityName;
  final String neighborhood;
  final num? dailyRate;
  final List<BookingApartmentImage> images;

  const BookingApartmentSummary({
    required this.id,
    required this.listingType,
    required this.propertyCategory,
    required this.cityName,
    required this.neighborhood,
    required this.dailyRate,
    required this.images,
  });

  String get primaryImageUrl =>
      images.isNotEmpty && images.first.link.isNotEmpty
      ? images.first.link
      : '';

  factory BookingApartmentSummary.fromJson(Map<String, dynamic> json) {
    final imagesRaw = json['images'];
    final images = imagesRaw is List
        ? imagesRaw
              .whereType<Map>()
              .map(
                (e) =>
                    BookingApartmentImage.fromJson(e.cast<String, dynamic>()),
              )
              .toList()
        : <BookingApartmentImage>[];

    return BookingApartmentSummary(
      id: (json['_id'] ?? '').toString(),
      listingType: (json['listing_type'] ?? '').toString(),
      propertyCategory: (json['property_category'] ?? '').toString(),
      cityName: (json['city_name'] ?? '').toString(),
      neighborhood: (json['neighborhood'] ?? '').toString(),
      dailyRate: json['daily_rate'] is num ? (json['daily_rate'] as num) : null,
      images: images,
    );
  }
}

class OwnerBooking {
  final String id;
  final String apartmentId;
  final BookingApartmentSummary? apartment;
  final BookingCustomer customer;
  final String phone;
  final String ticketId;
  final DateTime? startDate;
  final DateTime? endDate;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const OwnerBooking({
    required this.id,
    required this.apartmentId,
    required this.apartment,
    required this.customer,
    required this.phone,
    required this.ticketId,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OwnerBooking.fromJson(Map<String, dynamic> json) {
    final dynamic apartmentRaw = json['apartmentId'];
    BookingApartmentSummary? apartment;
    String apartmentId = '';

    if (apartmentRaw is Map) {
      final apartmentMap = apartmentRaw.cast<String, dynamic>();
      apartment = BookingApartmentSummary.fromJson(apartmentMap);
      apartmentId = apartment.id;
    } else {
      apartmentId = (apartmentRaw ?? '').toString();
    }

    final customerRaw = json['customer'];
    final customer = customerRaw is Map
        ? BookingCustomer.fromJson(customerRaw.cast<String, dynamic>())
        : const BookingCustomer(id: '', name: '', phone: '', email: '');

    DateTime? tryParseDate(dynamic value) {
      if (value == null) return null;
      if (value is DateTime) return value;
      return DateTime.tryParse(value.toString());
    }

    return OwnerBooking(
      id: (json['_id'] ?? '').toString(),
      apartmentId: apartmentId,
      apartment: apartment,
      customer: customer,
      phone: (json['phone'] ?? '').toString(),
      ticketId: (json['ticketId'] ?? '').toString(),
      startDate: tryParseDate(json['startDate']),
      endDate: tryParseDate(json['endDate']),
      status: (json['status'] ?? '').toString(),
      createdAt: tryParseDate(json['createdAt']),
      updatedAt: tryParseDate(json['updatedAt']),
    );
  }
}

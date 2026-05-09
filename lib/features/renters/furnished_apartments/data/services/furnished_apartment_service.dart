import 'package:yannyamba/core/core.dart';
import 'package:yannyamba/core/models/property/property_models.dart';

/// Service for fetching furnished apartment data
class FurnishedApartmentService {
  final NetworkCaller _networkCaller;

  FurnishedApartmentService({NetworkCaller? networkCaller})
    : _networkCaller = networkCaller ?? NetworkCaller();

  void _debugDumpApartmentsJson(
    List<dynamic> apartmentsJson, {
    required String effectiveListingType,
  }) {
    try {
      AppLoggerHelper.debug(
        '[FurnishedApartmentService] listing_type request = "$effectiveListingType", items = ${apartmentsJson.length}',
      );

      final Map<String, int> listingTypeCounts = {};
      int hasDailyRateKey = 0;
      int hasDailyRateValue = 0;
      int hasRentKey = 0;

      for (final item in apartmentsJson) {
        if (item is! Map) continue;
        final listingType = (item['listing_type'] ?? item['type'] ?? 'unknown')
            .toString();
        listingTypeCounts[listingType] =
            (listingTypeCounts[listingType] ?? 0) + 1;

        final hasDailyKey =
            item.containsKey('daily_rate') || item.containsKey('dailyRate');
        if (hasDailyKey) {
          hasDailyRateKey++;
          final value = item['daily_rate'] ?? item['dailyRate'];
          if (value != null && value.toString().trim().isNotEmpty) {
            hasDailyRateValue++;
          }
        }

        if (item.containsKey('rent') || item.containsKey('monthly_rent')) {
          hasRentKey++;
        }
      }

      AppLoggerHelper.debug(
        '[FurnishedApartmentService] listing_type counts = $listingTypeCounts',
      );
      AppLoggerHelper.debug(
        '[FurnishedApartmentService] daily_rate key present = $hasDailyRateKey, value present = $hasDailyRateValue, rent key present = $hasRentKey',
      );

      for (var i = 0; i < apartmentsJson.length && i < 3; i++) {
        final item = apartmentsJson[i];
        if (item is! Map) continue;
        AppLoggerHelper.debug(
          '[FurnishedApartmentService] sample[$i] id=${item['_id'] ?? item['id']} listing_type=${item['listing_type'] ?? item['type']} daily_rate=${item['daily_rate'] ?? item['dailyRate']} rent=${item['rent'] ?? item['monthly_rent']}',
        );
      }
    } catch (e) {
      AppLoggerHelper.debug(
        '[FurnishedApartmentService] debug dump failed: $e',
      );
    }
  }

  /// Fetch all furnished apartments from API
  ///
  /// NOTE: Backend `GET /product/get-all` returns all products by default.
  /// If you pass [listingType], it will request a filtered result from API.
  /// By default this service requests `Furnished Apartment` only (to avoid
  /// mixing listing types that don't have `daily_rate`, which causes missing
  /// price values in renter UI cards).
  Future<List<FurnishedApartment>> fetchFurnishedApartments({
    String? listingType,
    int? page,
    int? limit,
    void Function(Map<String, dynamic>? meta)? onMeta,
  }) async {
    try {
      final effectiveListingType =
          (listingType == null || listingType.trim().isEmpty)
          ? 'Furnished Apartment'
          : listingType.trim();
      AppLoggerHelper.debug('Fetching furnished apartments...');
      final response = await _networkCaller.getRequest(
        ApiConstants.getAllProducts,
        queryParams: {
          'listing_type': effectiveListingType,
          if (page != null) 'page': page,
          if (limit != null) 'limit': limit,
        },
      );

      AppLoggerHelper.debug('Response isSuccess: ${response.isSuccess}');

      if (response.isSuccess && response.responseData != null) {
        final data = response.responseData;

        AppLoggerHelper.debug('Response data type: ${data.runtimeType}');

        // Extract the data array from the response
        if (data is Map && data['data'] != null && data['data'] is List) {
          Map<String, dynamic>? meta;
          if (data is Map<String, dynamic>) {
            if (data['meta'] is Map<String, dynamic>) {
              meta = Map<String, dynamic>.from(data['meta']);
            } else if (data['pagination'] is Map<String, dynamic>) {
              meta = Map<String, dynamic>.from(data['pagination']);
            } else if (data['data'] is Map<String, dynamic> &&
                data['data']['meta'] is Map<String, dynamic>) {
              meta = Map<String, dynamic>.from(data['data']['meta']);
            }
          }
          if (onMeta != null) onMeta(meta);

          final List<dynamic> apartmentsJson = data['data'];

          _debugDumpApartmentsJson(
            apartmentsJson,
            effectiveListingType: effectiveListingType,
          );

          AppLoggerHelper.debug(
            'Found ${apartmentsJson.length} apartments in response',
          );

          final apartments = apartmentsJson
              .map((json) {
                try {
                  final apt = FurnishedApartment.fromJson(json);
                  AppLoggerHelper.debug(
                    'Apartment ${apt.id}: ${apt.bookings.length} bookings, ${apt.blockedDates.length} blocked dates',
                  );
                  return apt;
                } catch (e) {
                  AppLoggerHelper.error('Error parsing apartment', e);
                  return null;
                }
              })
              .whereType<FurnishedApartment>()
              .toList();

          AppLoggerHelper.debug(
            'Successfully parsed ${apartments.length} apartments',
          );

          return apartments;
        } else {
          AppLoggerHelper.error(
            'Data structure mismatch',
            'Expected Map with data array, got: ${data.runtimeType}',
          );
        }
      }

      // Return empty list if request failed
      AppLoggerHelper.error(
        'Failed to fetch furnished apartments',
        response.errorMessage,
      );
      return [];
    } catch (e, stackTrace) {
      AppLoggerHelper.error('Error fetching furnished apartments', e);
      AppLoggerHelper.debug('Stack trace: $stackTrace');
      return [];
    }
  }

  /// Get furnished apartment by ID
  Future<FurnishedApartment?> getFurnishedApartmentById(String id) async {
    try {
      // For now, fetch all and find by ID
      // TODO: Update when backend provides single apartment endpoint
      final apartments = await fetchFurnishedApartments();

      return apartments.firstWhere(
        (apt) => apt.id == id,
        orElse: () => throw Exception('Apartment not found'),
      );
    } catch (e) {
      AppLoggerHelper.error('Error fetching apartment by ID', e);
      return null;
    }
  }

  /// Search furnished apartments
  Future<List<FurnishedApartment>> searchApartments({
    String? query,
    double? maxPrice,
    int? minRooms,
    List<String>? amenities,
  }) async {
    final apartments = await fetchFurnishedApartments();

    return apartments.where((apt) {
      if (query != null &&
          !apt.title.toLowerCase().contains(query.toLowerCase()) &&
          !apt.about.toLowerCase().contains(query.toLowerCase())) {
        return false;
      }
      if (maxPrice != null && apt.dailyRate > maxPrice) {
        return false;
      }
      if (minRooms != null && apt.rooms < minRooms) {
        return false;
      }
      if (amenities != null && amenities.isNotEmpty) {
        if (!amenities.every((a) => apt.amenities.contains(a))) {
          return false;
        }
      }
      return true;
    }).toList();
  }
}

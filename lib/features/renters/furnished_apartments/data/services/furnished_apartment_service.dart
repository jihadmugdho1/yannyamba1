import 'package:yannyamba/core/core.dart';
import 'package:yannyamba/core/models/property/property_models.dart';

/// Service for fetching furnished apartment data
class FurnishedApartmentService {
  final NetworkCaller _networkCaller;

  FurnishedApartmentService({NetworkCaller? networkCaller})
    : _networkCaller = networkCaller ?? NetworkCaller();

  /// Fetch all furnished apartments from API
  ///
  /// NOTE: Backend `GET /product/get-all` returns all products by default.
  /// If you pass [listingType], it will request a filtered result from API.
  Future<List<FurnishedApartment>> fetchFurnishedApartments({
    String? listingType,
  }) async {
    try {
      AppLoggerHelper.debug('Fetching furnished apartments...');
      final response = await _networkCaller.getRequest(
        ApiConstants.getAllProducts,
        queryParams: {
          if (listingType != null && listingType.trim().isNotEmpty)
            'listing_type': listingType.trim(),
        },
      );

      AppLoggerHelper.debug('Response isSuccess: ${response.isSuccess}');

      if (response.isSuccess && response.responseData != null) {
        final data = response.responseData;

        AppLoggerHelper.debug('Response data type: ${data.runtimeType}');

        // Extract the data array from the response
        if (data is Map && data['data'] != null && data['data'] is List) {
          final List<dynamic> apartmentsJson = data['data'];

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

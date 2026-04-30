import 'package:yannyamba/core/core.dart';
import 'package:yannyamba/core/models/property/property_models.dart';

/// Service for managing apartment data
class ApartmentService {
  final NetworkCaller _networkCaller;

  ApartmentService({NetworkCaller? networkCaller})
    : _networkCaller = networkCaller ?? NetworkCaller();

  /// Fetch all apartments from API
  Future<List<Apartment>> fetchApartments({
    String? type,
    double? minRent,
    double? maxRent,
    int? minRooms,
  }) async {
    try {
      AppLoggerHelper.debug('Fetching normal apartments from API...');

      final response = await _networkCaller.getRequest(
        ApiConstants.getNormalApartments,
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

          var apartments = apartmentsJson
              .map((json) {
                try {
                  return Apartment.fromJson(json);
                } catch (e) {
                  AppLoggerHelper.error('Error parsing apartment', e);
                  return null;
                }
              })
              .whereType<Apartment>()
              .toList();

          AppLoggerHelper.debug(
            'Successfully parsed ${apartments.length} apartments',
          );

          // Apply filters
          if (type != null && type != 'All') {
            apartments = apartments.where((apt) => apt.type == type).toList();
          }

          if (minRent != null) {
            apartments = apartments
                .where((apt) => apt.rent >= minRent)
                .toList();
          }

          if (maxRent != null) {
            apartments = apartments
                .where((apt) => apt.rent <= maxRent)
                .toList();
          }

          if (minRooms != null) {
            apartments = apartments
                .where((apt) => apt.rooms >= minRooms)
                .toList();
          }

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
        'Failed to fetch apartments',
        response.errorMessage,
      );
      return [];
    } catch (e, stackTrace) {
      AppLoggerHelper.error('Error fetching apartments', e);
      AppLoggerHelper.debug('Stack trace: $stackTrace');
      return [];
    }
  }

  /// Get apartment by ID
  Future<Apartment?> getApartmentById(String id) async {
    try {
      // For now, fetch all and find by ID
      // TODO: Update when backend provides single apartment endpoint
      final apartments = await fetchApartments();

      return apartments.firstWhere(
        (apt) => apt.id == id,
        orElse: () => throw Exception('Apartment not found'),
      );
    } catch (e) {
      AppLoggerHelper.error('Error fetching apartment by ID', e);
      return null;
    }
  }
}

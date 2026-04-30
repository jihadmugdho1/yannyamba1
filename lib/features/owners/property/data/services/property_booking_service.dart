import 'package:intl/intl.dart';
import 'package:yannyamba/core/models/property/property_models.dart';
import 'package:yannyamba/core/services/network_caller.dart';
import 'package:yannyamba/core/services/storage_service.dart';
import 'package:yannyamba/core/utils/constants/api_constants.dart';
import 'package:yannyamba/core/utils/logging/logger.dart';

/// Service for managing property booking dates
class PropertyBookingService {
  final NetworkCaller _networkCaller = NetworkCaller();

  /// Add booking dates to a property
  /// Returns the updated FurnishedApartment with new booking dates
  Future<FurnishedApartment?> addBookingDates({
    required String propertyId,
    required List<DateTime> dates,
  }) async {
    try {
      AppLoggerHelper.debug('Adding booking dates for property: $propertyId');
      AppLoggerHelper.debug('Number of dates: ${dates.length}');

      // Convert DateTime list to DD/MM/YYYY format strings
      final formattedDates = dates.map((date) {
        return DateFormat('d/M/yyyy').format(date);
      }).toList();

      AppLoggerHelper.debug('Formatted dates: $formattedDates');

      final token = await StorageService.getToken();

      // Replace {propertyId} placeholder in the URL
      final url = ApiConstants.addBookingDates.replaceAll(
        '{propertyId}',
        propertyId,
      );

      AppLoggerHelper.debug('API URL: $url');

      final response = await _networkCaller.postRequest(
        url,
        body: {'date': formattedDates},
        headers: {'Authorization': '$token'},
      );

      AppLoggerHelper.debug('Response isSuccess: ${response.isSuccess}');

      if (response.isSuccess && response.responseData != null) {
        AppLoggerHelper.debug('Successfully added booking dates');

        // Parse the updated apartment data from response
        final data = response.responseData;
        if (data is Map && data['data'] != null) {
          final apartmentData = data['data'];
          final updatedApartment = FurnishedApartment.fromJson(apartmentData);
          AppLoggerHelper.debug(
            'Parsed updated apartment with ${updatedApartment.bookings.length} bookings',
          );
          return updatedApartment;
        }

        return null;
      } else {
        AppLoggerHelper.error(
          'Failed to add booking dates',
          response.errorMessage,
        );
        return null;
      }
    } catch (e, stackTrace) {
      AppLoggerHelper.error('Error adding booking dates', e);
      AppLoggerHelper.debug('Stack trace: $stackTrace');
      return null;
    }
  }

  /// Remove booking dates from a property (if API supports it)
  /// This is a placeholder for future implementation
  Future<bool> removeBookingDates({
    required String propertyId,
    required List<DateTime> dates,
  }) async {
    try {
      AppLoggerHelper.debug('Removing booking dates for property: $propertyId');
      // TODO: Implement when backend API is available
      AppLoggerHelper.warning('Remove booking dates not implemented yet');
      return false;
    } catch (e, stackTrace) {
      AppLoggerHelper.error('Error removing booking dates', e);
      AppLoggerHelper.debug('Stack trace: $stackTrace');
      return false;
    }
  }
}

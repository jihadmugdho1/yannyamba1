import 'package:get/get.dart';
import 'package:yannyamba/core/models/property/property_models.dart';
import 'package:yannyamba/core/utils/logging/logger.dart';
import 'package:yannyamba/features/owners/property/data/services/property_booking_service.dart';

/// Controller for managing property booking dates
class PropertyBookingController extends GetxController {
  final PropertyBookingService _bookingService;

  PropertyBookingController({PropertyBookingService? bookingService})
    : _bookingService = bookingService ?? PropertyBookingService();

  // Observable state
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final successMessage = ''.obs;

  /// Add booking dates to a property
  /// Returns the updated apartment data if successful
  Future<FurnishedApartment?> addBookingDates({
    required String propertyId,
    required List<DateTime> dates,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      AppLoggerHelper.debug(
        'Controller: Adding ${dates.length} booking dates for property $propertyId',
      );

      final updatedApartment = await _bookingService.addBookingDates(
        propertyId: propertyId,
        dates: dates,
      );

      if (updatedApartment != null) {
        successMessage.value = 'Booking dates added successfully';
        AppLoggerHelper.debug('Successfully added booking dates');
        return updatedApartment;
      } else {
        errorMessage.value = 'Failed to add booking dates';
        AppLoggerHelper.error('Failed to add booking dates', null);
        return null;
      }
    } catch (e, stackTrace) {
      errorMessage.value = 'Error: ${e.toString()}';
      AppLoggerHelper.error('Error in addBookingDates controller', e);
      AppLoggerHelper.debug('Stack trace: $stackTrace');
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  /// Remove booking dates from a property
  Future<bool> removeBookingDates({
    required String propertyId,
    required List<DateTime> dates,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      final success = await _bookingService.removeBookingDates(
        propertyId: propertyId,
        dates: dates,
      );

      if (success) {
        successMessage.value = 'Booking dates removed successfully';
        return true;
      } else {
        errorMessage.value = 'Failed to remove booking dates';
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Error: ${e.toString()}';
      AppLoggerHelper.error('Error in removeBookingDates controller', e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Clear messages
  void clearMessages() {
    errorMessage.value = '';
    successMessage.value = '';
  }
}

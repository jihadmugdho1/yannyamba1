import 'package:yannyamba/core/services/network_caller.dart';
import 'package:yannyamba/core/services/storage_service.dart';
import 'package:yannyamba/core/utils/constants/api_constants.dart';
import 'package:yannyamba/core/utils/logging/logger.dart';

class BookingService {
  final NetworkCaller _networkCaller;

  BookingService({NetworkCaller? networkCaller})
    : _networkCaller = networkCaller ?? NetworkCaller();

  Future<Map<String, dynamic>> createBooking({
    required String apartmentId,
    required String phone,
    required String startDate,
    required String endDate,
  }) async {
    AppLoggerHelper.debug('Creating booking for apartment: $apartmentId');

    final token = await StorageService.getToken();
    if (token == null) {
      throw Exception('Please login first');
    }

    final response = await _networkCaller.postRequest(
      ApiConstants.createBooking,
      headers: {'Authorization': token},
      body: {
        'apartmentId': apartmentId,
        'phone': phone.trim(),
        'startDate': startDate,
        'endDate': endDate,
      },
    );

    if (!response.isSuccess) {
      throw Exception(
        response.errorMessage.isNotEmpty
            ? response.errorMessage
            : 'Failed to create booking',
      );
    }

    final data = response.responseData;
    if (data is Map) {
      return data.cast<String, dynamic>();
    }

    return <String, dynamic>{'data': data};
  }

  Future<List<Map<String, dynamic>>> fetchUserBookings({
    required String phone,
  }) async {
    final token = await StorageService.getToken();
    if (token == null) {
      throw Exception('Please login first');
    }

    final response = await _networkCaller.getRequest(
      ApiConstants.getUserBookingsByPhone(phone),
      headers: {'Authorization': token},
    );

    if (!response.isSuccess) {
      throw Exception(
        response.errorMessage.isNotEmpty
            ? response.errorMessage
            : 'Failed to fetch bookings',
      );
    }

    final decoded = response.responseData;
    if (decoded is Map<String, dynamic>) {
      final data = decoded['data'];
      if (data is List) {
        return data
            .whereType<Map>()
            .map((e) => e.cast<String, dynamic>())
            .toList();
      }
    }

    return <Map<String, dynamic>>[];
  }

  Future<Map<String, dynamic>> fetchBookingDetails({
    required String ticketId,
  }) async {
    final token = await StorageService.getToken();
    if (token == null) {
      throw Exception('Please login first');
    }

    final response = await _networkCaller.getRequest(
      ApiConstants.getBookingDetailsByTicket(ticketId),
      headers: {'Authorization': token},
    );

    if (!response.isSuccess) {
      throw Exception(
        response.errorMessage.isNotEmpty
            ? response.errorMessage
            : 'Failed to fetch booking details',
      );
    }

    final decoded = response.responseData;
    if (decoded is Map<String, dynamic>) {
      final data = decoded['data'];
      if (data is Map) {
        return data.cast<String, dynamic>();
      }
    }

    return <String, dynamic>{};
  }
}

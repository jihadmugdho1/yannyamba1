import 'package:yannyamba/core/services/network_caller.dart';
import 'package:yannyamba/core/services/storage_service.dart';
import 'package:yannyamba/core/utils/constants/api_constants.dart';
import 'package:yannyamba/core/utils/logging/logger.dart';
import 'package:yannyamba/features/owners/bookings/data/models/booking_models.dart';

class OwnerBookingsService {
  final NetworkCaller _networkCaller = NetworkCaller();

  Future<List<OwnerBooking>> fetchOwnerBookings({
    int? page,
    int? limit,
    void Function(Map<String, dynamic>? meta)? onMeta,
  }) async {
    try {
      AppLoggerHelper.debug('Fetching owner bookings...');
      final token = await StorageService.getToken();
      if (token == null) return [];

      final queryParams = <String, dynamic>{
        if (page != null) 'page': page,
        if (limit != null) 'limit': limit,
      };

      final response = await _networkCaller.getRequest(
        ApiConstants.getOwnerBookings,
        headers: {'Authorization': token},
        queryParams: queryParams.isEmpty ? null : queryParams,
      );

      if (!response.isSuccess || response.responseData == null) {
        AppLoggerHelper.error(
          'Failed to fetch owner bookings',
          response.errorMessage,
        );
        return [];
      }

      final data = response.responseData;
      if (data is Map && data['data'] is List) {
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

        return (data['data'] as List)
            .whereType<Map>()
            .map((e) => OwnerBooking.fromJson(e.cast<String, dynamic>()))
            .toList();
      }

      AppLoggerHelper.error(
        'Owner bookings response structure mismatch',
        data.runtimeType,
      );
      return [];
    } catch (e, stackTrace) {
      AppLoggerHelper.error('Error fetching owner bookings', e);
      AppLoggerHelper.debug('Stack trace: $stackTrace');
      return [];
    }
  }

  Future<List<OwnerBooking>> fetchApartmentBookings(String apartmentId) async {
    try {
      AppLoggerHelper.debug('Fetching apartment bookings for: $apartmentId');
      final token = await StorageService.getToken();
      if (token == null) return [];

      final url = ApiConstants.getApartmentBookings.replaceAll(
        '{apartmentId}',
        apartmentId,
      );

      final response = await _networkCaller.getRequest(
        url,
        headers: {'Authorization': token},
      );

      if (!response.isSuccess || response.responseData == null) {
        AppLoggerHelper.error(
          'Failed to fetch apartment bookings',
          response.errorMessage,
        );
        return [];
      }

      final data = response.responseData;
      if (data is Map && data['data'] is List) {
        return (data['data'] as List)
            .whereType<Map>()
            .map((e) => OwnerBooking.fromJson(e.cast<String, dynamic>()))
            .toList();
      }

      AppLoggerHelper.error(
        'Apartment bookings response structure mismatch',
        data.runtimeType,
      );
      return [];
    } catch (e, stackTrace) {
      AppLoggerHelper.error('Error fetching apartment bookings', e);
      AppLoggerHelper.debug('Stack trace: $stackTrace');
      return [];
    }
  }
}

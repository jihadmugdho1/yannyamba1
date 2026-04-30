import 'package:yannyamba/core/models/property/property_models.dart';
import 'package:yannyamba/core/services/network_caller.dart';
import 'package:yannyamba/core/services/storage_service.dart';
import 'package:yannyamba/core/utils/constants/api_constants.dart';
import 'package:yannyamba/core/utils/constants/image_path.dart';
import 'package:yannyamba/core/utils/logging/logger.dart';
import 'package:yannyamba/features/owners/dashboard/data/models/dashboard_stats_model.dart';
import 'package:yannyamba/features/owners/dashboard/data/models/owner_property_model.dart';

/// Service for managing owner dashboard data
/// Currently uses mock data, ready for API integration
class OwnerDashboardService {
  // TODO: Inject ApiService when backend is ready
  final NetworkCaller _networkCaller = NetworkCaller();
  // final ApiService _apiService;

  /// Fetch dashboard statistics
  Future<DashboardStats> fetchDashboardStats() async {
    try {
      AppLoggerHelper.debug('Fetching dashboard stats from API...');
      final token = await StorageService.getToken();
      if (token == null) {
        AppLoggerHelper.error(
          'No auth token found',
          'User might not be logged in',
        );
        return DashboardStats(
          totalViews: 0,
          inquiries: 0,
          activeListings: 0,
          totalProperties: 0,
        );
      }

      final response = await _networkCaller.getRequest(
        ApiConstants.getOwnerStats,
        headers: {'Authorization': '$token'},
      );

      AppLoggerHelper.debug('Response isSuccess: ${response.isSuccess}');

      if (response.isSuccess && response.responseData != null) {
        final data = response.responseData;

        AppLoggerHelper.debug('Response data type: ${data.runtimeType}');

        // Extract the data object from the response
        if (data is Map && data['data'] != null && data['data'] is Map) {
          final statsJson = data['data'] as Map<String, dynamic>;

          AppLoggerHelper.debug('Stats data: $statsJson');

          return DashboardStats.fromJson(statsJson);
        } else {
          AppLoggerHelper.error(
            'Data structure mismatch',
            'Expected Map with data object, got: ${data.runtimeType}',
          );
        }
      }

      // Return empty stats if request failed
      AppLoggerHelper.error(
        'Failed to fetch dashboard stats',
        response.errorMessage,
      );
      return DashboardStats(
        totalViews: 0,
        inquiries: 0,
        activeListings: 0,
        totalProperties: 0,
      );
    } catch (e, stackTrace) {
      AppLoggerHelper.error('Error fetching dashboard stats', e);
      AppLoggerHelper.debug('Stack trace: $stackTrace');
      return DashboardStats(
        totalViews: 0,
        inquiries: 0,
        activeListings: 0,
        totalProperties: 0,
      );
    }
  }

  /// Fetch owner's properties
  Future<List<OwnerProperty>> fetchOwnerProperties() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // TODO: Replace with actual API call
    // return await _apiService.getOwnerProperties();

    return _getMockOwnerProperties();
  }

  /// Get property by ID
  Future<OwnerProperty?> getPropertyById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));

    // TODO: Replace with actual API call
    // return await _apiService.getPropertyById(id);

    try {
      return _getMockOwnerProperties().firstWhere((prop) => prop.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Mock data - will be removed when API is integrated
  List<OwnerProperty> _getMockOwnerProperties() {
    return [
      OwnerProperty(
        id: '1',
        title: 'Modern 3BR Home with Garden',
        address: Address(
          street: '123 Oak Street',
          city: 'Seattle',
          state: 'WA',
          zipCode: '98101',
          latitude: 47.6062,
          longitude: -122.3321,
        ),
        type: 'Home',
        rent: 1900,
        advancePayment: 5000,
        size: 1500,
        rooms: 3,
        washrooms: 2,
        distanceToDowntown: 0.5,
        images: [ImagePath.homeImage],
        contacts: [
          Contact.owner(
            name: 'James Cameroon',
            phone: '+1234567890',
            email: 'james_cameroon@example.com',
            isVerified: true,
          ),
        ],
        about: 'Beautiful 3 bedroom home with garden',
        propertyDetails: PropertyDetails(
          propertyType: 'House',
          squareFeet: 1500,
          advanceMonths: 2,
          depositMonths: 1,
          distanceToDowntown: 0.5,
        ),
        features: ['Garden', 'Modern kitchen', 'Hardwood floors'],
        amenities: ['Parking', 'Laundry'],
        details: 'Perfect for families',

        views: 100,
        inquiries: 20,
        isActive: true,
      ),
    ];
  }

  Future<List<Apartment>> fetchApartments({
    String? type,
    double? minRent,
    double? maxRent,
    int? minRooms,
  }) async {
    try {
      AppLoggerHelper.debug('Fetching normal apartments from API...');
      final token = await StorageService.getToken();
      if (token == null) {
        AppLoggerHelper.error(
          'No auth token found',
          'User might not be logged in',
        );
        return [];
      }

      final response = await _networkCaller.getRequest(
        ApiConstants.getOwnerNormalProperties,
        headers: {'Authorization': '$token'},
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

  Future<List<FurnishedApartment>> fetchFurnishedApartments() async {
    try {
      AppLoggerHelper.debug('Fetching furnished apartments...');
      final token = await StorageService.getToken();
      if (token == null) {
        AppLoggerHelper.error(
          'No auth token found',
          'User might not be logged in',
        );
        return [];
      }

      final response = await _networkCaller.getRequest(
        ApiConstants.getOwnerFurnishedProperties,
        headers: {'Authorization': '$token'},
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
}

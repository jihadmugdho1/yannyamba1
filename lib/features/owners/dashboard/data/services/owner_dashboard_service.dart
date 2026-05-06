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
        headers: {'Authorization': token},
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
    String? rentalFilter,
    double? minRent,
    double? maxRent,
    int? bedrooms,
    int? bathrooms,
    String? advancePayment,
    String? securityDeposit,
    String? city,
    String? neighborhood,
    int? page,
    int? limit,
    void Function(Map<String, dynamic>? meta)? onMeta,
  }) async {
    try {
      AppLoggerHelper.debug(
        'Fetching normal apartments from API with filters...',
      );
      final token = await StorageService.getToken();
      if (token == null) {
        AppLoggerHelper.error(
          'No auth token found',
          'User might not be logged in',
        );
        return [];
      }

      final endpoint = ApiConstants.getOwnerNormalProperties.split('?').first;

      final queryParams = <String, dynamic>{
        if (type != null) 'property_category': type,
        if (rentalFilter != null) 'rental_filter': rentalFilter,
        if (minRent != null) 'price_min': minRent.toInt(),
        if (maxRent != null) 'price_max': maxRent.toInt(),
        if (bedrooms != null) 'bedrooms': bedrooms,
        if (bathrooms != null) 'bathrooms': bathrooms,
        if (advancePayment != null) 'advance_payment': advancePayment,
        if (securityDeposit != null) 'security_deposit': securityDeposit,
        if (city != null) 'city': city,
        if (neighborhood != null) 'neighborhood': neighborhood,
        if (page != null) 'page': page,
        if (limit != null) 'limit': limit,
      };

      // Ensure listing_type is included for owner endpoint
      queryParams['listing_type'] = 'Normal Apartment';

      final response = await _networkCaller.getRequest(
        endpoint,
        headers: {'Authorization': token},
        queryParams: queryParams,
      );

      AppLoggerHelper.debug('Response isSuccess: ${response.isSuccess}');

      if (response.isSuccess && response.responseData != null) {
        final data = response.responseData;

        // attempt to extract pagination/meta info and attach if present
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

        // expose meta via callback
        if (onMeta != null) onMeta(meta);

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

  Future<List<FurnishedApartment>> fetchFurnishedApartments({
    String? type,
    String? rentalFilter,
    double? minRent,
    double? maxRent,
    int? bedrooms,
    int? bathrooms,
    String? advancePayment,
    String? securityDeposit,
    String? city,
    String? neighborhood,
    int? page,
    int? limit,
    void Function(Map<String, dynamic>? meta)? onMeta,
  }) async {
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

      final endpoint = ApiConstants.getOwnerFurnishedProperties
          .split('?')
          .first;

      final queryParams = <String, dynamic>{
        if (type != null) 'property_category': type,
        if (rentalFilter != null) 'rental_filter': rentalFilter,
        if (minRent != null) 'price_min': minRent.toInt(),
        if (maxRent != null) 'price_max': maxRent.toInt(),
        if (bedrooms != null) 'bedrooms': bedrooms,
        if (bathrooms != null) 'bathrooms': bathrooms,
        if (advancePayment != null) 'advance_payment': advancePayment,
        if (securityDeposit != null) 'security_deposit': securityDeposit,
        if (city != null) 'city': city,
        if (neighborhood != null) 'neighborhood': neighborhood,
        if (page != null) 'page': page,
        if (limit != null) 'limit': limit,
      };

      queryParams['listing_type'] = 'Furnished Apartment';

      final response = await _networkCaller.getRequest(
        endpoint,
        headers: {'Authorization': token},
        queryParams: queryParams,
      );

      AppLoggerHelper.debug('Response isSuccess: ${response.isSuccess}');

      if (response.isSuccess && response.responseData != null) {
        final data = response.responseData;

        // attempt to extract pagination/meta info and attach if present
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

          // If server-side filtering is preferred, call endpoint with query params instead.
          // For now, also apply client-side filters as a fallback.
          if (type != null && type != 'All') {
            apartments = apartments.where((apt) => apt.type == type).toList();
          }

          if (minRent != null) {
            apartments = apartments
                .where((apt) => apt.dailyRate >= minRent)
                .toList();
          }

          if (maxRent != null) {
            apartments = apartments
                .where((apt) => apt.dailyRate <= maxRent)
                .toList();
          }

          if (bedrooms != null) {
            apartments = apartments
                .where((apt) => apt.rooms >= bedrooms)
                .toList();
          }

          if (bathrooms != null) {
            apartments = apartments
                .where((apt) => apt.washrooms >= bathrooms)
                .toList();
          }

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

  Future<List<Apartment>> fetchAllProducts({
    String? type,
    String? rentalFilter,
    double? minRent,
    double? maxRent,
    int? bedrooms,
    int? bathrooms,
    String? advancePayment,
    String? securityDeposit,
    String? city,
    String? neighborhood,
    int? page,
    int? limit,
    void Function(Map<String, dynamic>? meta)? onMeta,
  }) async {
    try {
      AppLoggerHelper.debug('Fetching ALL products from API...');
      final token = await StorageService.getToken();

      final queryParams = <String, dynamic>{
        if (type != null) 'property_category': type,
        if (rentalFilter != null) 'rental_filter': rentalFilter,
        if (minRent != null) 'price_min': minRent.toInt(),
        if (maxRent != null) 'price_max': maxRent.toInt(),
        if (bedrooms != null) 'bedrooms': bedrooms,
        if (bathrooms != null) 'bathrooms': bathrooms,
        if (advancePayment != null) 'advance_payment': advancePayment,
        if (securityDeposit != null) 'security_deposit': securityDeposit,
        if (city != null) 'city': city,
        if (neighborhood != null) 'neighborhood': neighborhood,
        if (page != null) 'page': page,
        if (limit != null) 'limit': limit,
      };

      AppLoggerHelper.debug(
        'ALL products request: endpoint=${ApiConstants.getAllProducts} queryParams=$queryParams',
      );

      final response = await _networkCaller.getRequest(
        ApiConstants.getAllProducts,
        headers: {
          if (token != null && token.isNotEmpty) 'Authorization': token,
        },
        queryParams: queryParams.isEmpty ? null : queryParams,
      );

      AppLoggerHelper.debug(
        'All products response isSuccess: ${response.isSuccess}',
      );
      if (!response.isSuccess) {
        AppLoggerHelper.debug(
          'All products response errorMessage: ${response.errorMessage}',
        );
      }

      if (response.isSuccess && response.responseData != null) {
        final data = response.responseData;

        Map<String, dynamic>? meta;
        if (data is Map<String, dynamic>) {
          if (data['meta'] is Map<String, dynamic>) {
            meta = Map<String, dynamic>.from(data['meta']);
          } else if (data['pagination'] is Map<String, dynamic>) {
            meta = Map<String, dynamic>.from(data['pagination']);
          }
        }
        if (onMeta != null) onMeta(meta);

        if (data is Map && data['data'] != null && data['data'] is List) {
          final List<dynamic> listJson = data['data'];
          AppLoggerHelper.debug('ALL products raw count: ${listJson.length}');

          final parsed = listJson
              .map((json) {
                try {
                  if (json is! Map) return null;
                  final map = Map<String, dynamic>.from(json);
                  final hasDailyRate =
                      map['daily_rate'] != null || map['dailyRate'] != null;
                  if (hasDailyRate) return FurnishedApartment.fromJson(map);
                  return Apartment.fromJson(map);
                } catch (e) {
                  AppLoggerHelper.error('Error parsing product', e);
                  return null;
                }
              })
              .whereType<Apartment>()
              .toList();

          AppLoggerHelper.debug('ALL products parsed count: ${parsed.length}');
          return parsed;
        }

        AppLoggerHelper.error(
          'Data structure mismatch',
          'Expected Map with data array, got: ${data.runtimeType}',
        );
      }

      AppLoggerHelper.error(
        'Failed to fetch all products',
        response.errorMessage,
      );
      return [];
    } catch (e, stackTrace) {
      AppLoggerHelper.error('Error fetching all products', e);
      AppLoggerHelper.debug('Stack trace: $stackTrace');
      return [];
    }
  }

  Future<bool> hideApartment(String productId) async {
    try {
      AppLoggerHelper.debug('Hiding apartment $productId...');
      final token = await StorageService.getToken();
      if (token == null || token.isEmpty) {
        AppLoggerHelper.error('No auth token', 'Cannot hide apartment');
        return false;
      }

      final response = await _networkCaller.patchRequest(
        ApiConstants.hideApartment(productId),
        headers: {'Authorization': token},
        body: {'isHidden': true},
      );

      AppLoggerHelper.debug('Hide apartment response: ${response.isSuccess}');
      return response.isSuccess;
    } catch (e) {
      AppLoggerHelper.error('Error hiding apartment', e);
      return false;
    }
  }

  Future<List<Apartment>> fetchMyselfProducts({
    String? propertyCategory,
    int? page,
    int? limit,
    void Function(Map<String, dynamic>? meta)? onMeta,
  }) async {
    try {
      AppLoggerHelper.debug(
        'Fetching MY products${propertyCategory != null ? ' for property_category=$propertyCategory' : ''}...',
      );
      final token = await StorageService.getToken();

      AppLoggerHelper.debug(
        'MY products request: endpoint=${ApiConstants.getOwnerMyselfProducts} queryParams=${{if (propertyCategory != null) 'property_category': propertyCategory, if (page != null) 'page': page, if (limit != null) 'limit': limit}.isEmpty ? null : {if (propertyCategory != null) 'property_category': propertyCategory, if (page != null) 'page': page, if (limit != null) 'limit': limit}}',
      );

      final queryParams = <String, dynamic>{
        if (propertyCategory != null) 'property_category': propertyCategory,
        if (page != null) 'page': page,
        if (limit != null) 'limit': limit,
      };

      final response = await _networkCaller.getRequest(
        ApiConstants.getOwnerMyselfProducts,
        headers: {
          if (token != null && token.isNotEmpty) 'Authorization': token,
        },
        queryParams: queryParams.isEmpty ? null : queryParams,
      );

      AppLoggerHelper.debug(
        'MY products response isSuccess: ${response.isSuccess}',
      );
      if (!response.isSuccess || response.responseData == null) {
        AppLoggerHelper.error(
          'Failed to fetch my products',
          response.errorMessage,
        );
        return [];
      }

      final data = response.responseData;
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

        final List<dynamic> listJson = data['data'];
        AppLoggerHelper.debug(
          'MY products raw count ($propertyCategory): ${listJson.length}',
        );

        final parsed = listJson
            .map((json) {
              try {
                if (json is! Map) return null;
                final map = Map<String, dynamic>.from(json);
                final hasDailyRate =
                    map['daily_rate'] != null || map['dailyRate'] != null;
                if (hasDailyRate) return FurnishedApartment.fromJson(map);
                return Apartment.fromJson(map);
              } catch (e) {
                AppLoggerHelper.error('Error parsing my product', e);
                return null;
              }
            })
            .whereType<Apartment>()
            .toList();

        AppLoggerHelper.debug(
          'MY products parsed count ($propertyCategory): ${parsed.length}',
        );
        return parsed;
      }

      AppLoggerHelper.error(
        'Data structure mismatch',
        'Expected Map with data array, got: ${data.runtimeType}',
      );
      return [];
    } catch (e, stackTrace) {
      AppLoggerHelper.error('Error fetching my products', e);
      AppLoggerHelper.debug('Stack trace: $stackTrace');
      return [];
    }
  }
}

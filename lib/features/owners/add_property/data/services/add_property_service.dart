import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:io';
import 'dart:convert';
import 'package:yannyamba/core/services/network_caller.dart';
import 'package:yannyamba/core/services/storage_service.dart';
import 'package:yannyamba/core/utils/constants/api_constants.dart';
import 'package:yannyamba/core/utils/logging/logger.dart';

/// Service for managing property creation and photo uploads
class AddPropertyService {
  final NetworkCaller _networkCaller = NetworkCaller();

  /// Publish furnished apartment (daily rental)
  Future<Result<Map<String, dynamic>>> publishFurnishedApartment({
    required String propertyType,
    required int bedrooms,
    required int bathrooms,
    required String propertySize,
    required String aboutRental,
    required String dailyRate,
    required int minimumStay,
    required int maximumStay,
    required String checkInTime,
    required String checkOutTime,
    required String cityName,
    required String neighbourhood,
    String? distanceToDowntown,
    String? nearbyLandmarks,
    required List<String> selectedFurnishings,
    required List<String> selectedHouseRules,
    required List<String> photoLocalPaths,
    required String ownerName,
    required String ownerNumber,
    required List<dynamic> references,
    int? workstations,
  }) async {
    try {
      // Get auth token
      final token = await StorageService.getToken();
      if (token == null) {
        return Result.error('Authentication required. Please login.');
      }

      final isOffice = propertyType == 'Office';

      // Prepare the data field as JSON string
      final dataMap = <String, dynamic>{
        'listing_type': 'Furnished Apartment',
        'property_category': isOffice ? 'Office' : 'Home',
        'property_size': double.tryParse(propertySize) ?? 0.0,
        'about': aboutRental.isNotEmpty
            ? aboutRental
            : 'Property details not provided',
        'city_name': cityName,
        'neighborhood': neighbourhood,
        'distance_to_main_road': distanceToDowntown ?? '0m',
        'nearby_landmarks':
            nearbyLandmarks != null && nearbyLandmarks.isNotEmpty
            ? nearbyLandmarks
            : 'Not specified',
        'images': photoLocalPaths.map((path) => {'link': path}).toList(),
        'owner_name': ownerName,
        'owner_phone': ownerNumber,
        'references': references.map((ref) => ref.toJson()).toList(),
        'minimum_stay_days': minimumStay,
        'maximum_stay_days': maximumStay,
        'daily_rate': double.parse(dailyRate),
        'checkInTime': checkInTime,
        'checkOutTime': checkOutTime,
        'house_rules': selectedHouseRules,
        'whats_included': selectedFurnishings,
      };

      if (isOffice) {
        dataMap['office_rooms'] = bedrooms;
        dataMap['office_conference_rooms'] = bathrooms;
        dataMap['office_workstations'] = workstations ?? 1;
      } else {
        dataMap['bedrooms'] = bedrooms;
        dataMap['bathrooms'] = bathrooms;
      }

      // Prepare multipart files
      final List<http.MultipartFile> files = [];
      for (final path in photoLocalPaths) {
        final file = File(path);
        if (await file.exists()) {
          // Determine content type based on file extension
          String contentType = 'image/jpeg';
          final extension = path.toLowerCase().split('.').last;

          AppLoggerHelper.debug('Processing image: $path');
          AppLoggerHelper.debug('File extension: $extension');

          if (extension == 'png') {
            contentType = 'image/png';
          } else if (extension == 'jpg' || extension == 'jpeg') {
            contentType = 'image/jpeg';
          } else if (extension == 'gif') {
            contentType = 'image/gif';
          } else if (extension == 'webp') {
            contentType = 'image/webp';
          }

          AppLoggerHelper.debug('Content type: $contentType');

          final multipartFile = http.MultipartFile.fromBytes(
            'images',
            await file.readAsBytes(),
            filename: path.split('/').last,
            contentType: MediaType.parse(contentType),
          );
          files.add(multipartFile);
        }
      }

      // Make API call with multipart request
      final response = await _networkCaller.multipartRequest(
        ApiConstants.postProperty,
        method: 'POST',
        fields: {'data': jsonEncode(dataMap)},
        files: files,
        token: token,
      );

      if (response.isSuccess) {
        // Convert backend response to expected format
        final responseData =
            response.responseData['data'] as Map<String, dynamic>;
        final convertedData = _convertBackendResponse(responseData, true);
        return Result.success(convertedData);
      } else {
        return Result.error(response.errorMessage);
      }
    } catch (e) {
      return Result.error('Failed to publish furnished apartment: $e');
    }
  }

  /// Complete flow: Upload photos then create property (normal apartment)
  Future<Result<Map<String, dynamic>>> publishProperty({
    required String propertyType,
    required int bedrooms,
    required int bathrooms,
    required String propertySize,
    required String aboutRental,
    required bool isLeaseTakeover,
    required String monthlyRent,
    required int advanceMonths,
    required int securityMonths,
    required String cityName,
    required String neighbourhood,
    String? distanceToDowntown,
    String? nearbyLandmarks,
    required List<String> selectedFeatures,
    required List<String> selectedAmenities,
    required List<String> photoLocalPaths, // Local file paths
    required String ownerName,
    required String ownerNumber,
    required List<dynamic> references,
    int? workstations, // Office-specific field
  }) async {
    try {
      // Get auth token
      final token = await StorageService.getToken();
      if (token == null) {
        return Result.error('Authentication required. Please login.');
      }

      // Calculate advance and security amounts based on monthly rent
      final monthlyRentValue = double.parse(monthlyRent);

      // Determine if this is an office property
      final isOffice = propertyType == 'Office';

      // Prepare the data field as JSON string
      final dataMap = <String, dynamic>{
        'listing_type': 'Normal Apartment',
        'property_category': isOffice ? 'Office' : 'Home',
        'property_size': double.tryParse(propertySize) ?? 0.0,
        'about': aboutRental.isNotEmpty
            ? aboutRental
            : 'Property details not provided',
        'city_name': cityName,
        'neighborhood': neighbourhood,
        'distance_to_main_road': distanceToDowntown ?? '0m',
        'nearby_landmarks':
            nearbyLandmarks != null && nearbyLandmarks.isNotEmpty
            ? nearbyLandmarks
            : 'Not specified',
        'images': photoLocalPaths.map((path) => {'link': path}).toList(),
        'owner_name': ownerName,
        'owner_phone': ownerNumber,
        'references': references.map((ref) => ref.toJson()).toList(),
        'monthly_rent': monthlyRentValue,
        'advance_payment': '$advanceMonths months',
        'security_deposit': '$securityMonths months',
        'property_features': selectedFeatures,
        'building_amenities': selectedAmenities,
      };

      // Add property-specific fields based on type
      if (isOffice) {
        // Office-specific fields
        dataMap['office_rooms'] = bedrooms; // reused as office rooms
        dataMap['office_conference_rooms'] =
            bathrooms; // reused as conference rooms
        dataMap['office_workstations'] = workstations ?? 1;
      } else {
        // Home-specific fields
        dataMap['bedrooms'] = bedrooms;
        dataMap['bathrooms'] = bathrooms;
      }

      // Prepare multipart files
      final List<http.MultipartFile> files = [];
      for (final path in photoLocalPaths) {
        final file = File(path);
        if (await file.exists()) {
          // Determine content type based on file extension
          String contentType = 'image/jpeg';
          final extension = path.toLowerCase().split('.').last;

          AppLoggerHelper.debug('Processing image: $path');
          AppLoggerHelper.debug('File extension: $extension');

          if (extension == 'png') {
            contentType = 'image/png';
          } else if (extension == 'jpg' || extension == 'jpeg') {
            contentType = 'image/jpeg';
          } else if (extension == 'gif') {
            contentType = 'image/gif';
          } else if (extension == 'webp') {
            contentType = 'image/webp';
          }

          AppLoggerHelper.debug('Content type: $contentType');

          final multipartFile = http.MultipartFile.fromBytes(
            'images',
            await file.readAsBytes(),
            filename: path.split('/').last,
            contentType: MediaType.parse(contentType),
          );
          files.add(multipartFile);
        }
      }

      // Make API call with multipart request
      final response = await _networkCaller.multipartRequest(
        ApiConstants.postProperty,
        method: 'POST',
        fields: {'data': jsonEncode(dataMap)},
        files: files,
        token: token,
      );

      if (response.isSuccess) {
        // Convert backend response to expected format
        final responseData =
            response.responseData['data'] as Map<String, dynamic>;
        final convertedData = _convertBackendResponse(responseData, false);
        return Result.success(convertedData);
      } else {
        return Result.error(response.errorMessage);
      }
    } catch (e) {
      return Result.error('Failed to publish property: $e');
    }
  }

  /// Convert backend response to frontend format
  Map<String, dynamic> _convertBackendResponse(
    Map<String, dynamic> backendData,
    bool isFurnished,
  ) {
    if (isFurnished) {
      return {
        'id':
            backendData['_id'] ??
            'prop_${DateTime.now().millisecondsSinceEpoch}',
        'listingType': 'furnished',
        'propertyType': backendData['property_category'] ?? 'Apartment',
        'bedrooms': backendData['bedrooms'] ?? 1,
        'bathrooms': backendData['bathrooms'] ?? 1,
        'squareFeet': (backendData['property_size'] as num?)?.toDouble() ?? 0.0,
        'aboutRental': backendData['about'] ?? '',
        'dailyRate': (backendData['daily_rate'] as num?)?.toDouble() ?? 0.0,
        'minimumStay': backendData['minimum_stay_days'] ?? 1,
        'maximumStay': backendData['maximum_stay_days'] ?? 30,
        'checkInTime': backendData['checkInTime'] ?? '14:00',
        'checkOutTime': backendData['checkOutTime'] ?? '11:00',
        'location': {
          'cityName': backendData['city_name'] ?? '',
          'neighbourhood': backendData['neighborhood'] ?? '',
          'distanceToDowntown':
              double.tryParse(
                backendData['distance_to_main_road']?.toString().replaceAll(
                      RegExp(r'[^0-9.]'),
                      '',
                    ) ??
                    '0',
              ) ??
              0.0,
          'nearbyLandmarks': backendData['nearby_landmarks'] ?? '',
        },
        'furnishings':
            (backendData['whats_included'] as List?)?.cast<String>() ?? [],
        'houseRules':
            (backendData['house_rules'] as List?)?.cast<String>() ?? [],
        'photos':
            (backendData['images'] as List?)
                ?.map((img) => img is Map ? img['link'] : img.toString())
                .toList() ??
            [],
        'owner': {
          'name': backendData['owner_name'] ?? '',
          'phoneNumber': backendData['owner_phone'] ?? '',
        },
        'references':
            (backendData['references'] as List?)
                ?.map(
                  (ref) => {
                    'name': ref['reference_name'] ?? '',
                    'phone': ref['reference_phone'] ?? '',
                    'relationship': ref['reference_relationship'] ?? '',
                  },
                )
                .toList() ??
            [],
        'status': 'active',
        'views': 0,
        'inquiries': 0,
        'createdAt': DateTime.now().toIso8601String(),
      };
    } else {
      // Normal apartment (Home or Office)
      final isOffice = backendData['property_category'] == 'Office';

      // Parse advance_payment and security_deposit strings (e.g., "2 months")
      int parseMonths(dynamic value, int defaultValue) {
        if (value == null) return defaultValue;
        if (value is int) return value;
        if (value is String) {
          final match = RegExp(r'(\d+)').firstMatch(value);
          if (match != null) {
            return int.tryParse(match.group(1)!) ?? defaultValue;
          }
        }
        return defaultValue;
      }

      final advanceMonths = parseMonths(backendData['advance_payment'], 1);
      final securityMonths = parseMonths(backendData['security_deposit'], 1);
      final monthlyRent =
          (backendData['monthly_rent'] as num?)?.toDouble() ?? 0.0;

      return {
        'id':
            backendData['_id'] ??
            'prop_${DateTime.now().millisecondsSinceEpoch}',
        'propertyType': backendData['property_category'] ?? 'Apartment',
        // For Office: use office-specific fields, for Home: use bedroom/bathroom
        'bedrooms': isOffice
            ? (backendData['office_rooms'] ?? 1)
            : (backendData['bedrooms'] ?? 1),
        'bathrooms': isOffice
            ? (backendData['office_conference_rooms'] ?? 0)
            : (backendData['bathrooms'] ?? 1),
        'squareFeet': (backendData['property_size'] as num?)?.toDouble() ?? 0.0,
        'aboutRental': backendData['about'] ?? '',
        'isLeaseTakeover': backendData['is_lease_takeover'] ?? false,
        'monthlyRent': monthlyRent,
        'advanceAmount': monthlyRent * advanceMonths,
        'advanceMonths': advanceMonths,
        'securityDeposit': monthlyRent * securityMonths,
        'securityMonths': securityMonths,
        'location': {
          'cityName': backendData['city_name'] ?? '',
          'neighbourhood': backendData['neighborhood'] ?? '',
          'distanceToDowntown':
              double.tryParse(
                backendData['distance_to_main_road']?.toString().replaceAll(
                      RegExp(r'[^0-9.]'),
                      '',
                    ) ??
                    '0',
              ) ??
              0.0,
          'nearbyLandmarks': backendData['nearby_landmarks'] ?? '',
        },
        'features':
            (backendData['property_features'] as List?)?.cast<String>() ?? [],
        'amenities':
            (backendData['building_amenities'] as List?)?.cast<String>() ?? [],
        'photos':
            (backendData['images'] as List?)
                ?.map((img) => img is Map ? img['link'] : img.toString())
                .toList() ??
            [],
        'owner': {
          'name': backendData['owner_name'] ?? '',
          'phoneNumber': backendData['owner_phone'] ?? '',
        },
        'references':
            (backendData['references'] as List?)
                ?.map(
                  (ref) => {
                    'name': ref['reference_name'] ?? '',
                    'phone': ref['reference_phone'] ?? '',
                    'relationship': ref['reference_relationship'] ?? '',
                  },
                )
                .toList() ??
            [],
        if (isOffice && backendData['office_workstations'] != null)
          'workstations': backendData['office_workstations'],
        'status': 'active',
        'views': 0,
        'inquiries': 0,
        'createdAt': DateTime.now().toIso8601String(),
      };
    }
  }
}

/// Simple Result wrapper for API responses
class Result<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  Result.success(this.data) : error = null, isSuccess = true;

  Result.error(this.error) : data = null, isSuccess = false;
}

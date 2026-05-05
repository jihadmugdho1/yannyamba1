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

  /// Publish a property — short term (min_stay ≤ 15) or long term (min_stay ≥ 16).
  /// advance_payment and security_deposit are only sent for long term.
  Future<Result<Map<String, dynamic>>> publishProperty({
    required String propertyType,
    required int bedrooms,
    required int bathrooms,
    required String propertySize,
    required String aboutRental,
    required String dailyRate,
    required int minimumStay,
    required int maximumStay,
    required String cityName,
    required String neighbourhood,
    String? distanceToDowntown,
    String? nearbyLandmarks,
    required List<String> selectedFeatures,
    required List<String> selectedAmenities,
    required List<String> selectedHouseRules,
    required List<String> selectedWhatsIncluded,
    required List<String> photoLocalPaths,
    required String ownerName,
    required String ownerNumber,
    required List<dynamic> references,
    int? workstations,
    int? advanceMonths,
    int? securityMonths,
  }) async {
    try {
      final token = await StorageService.getToken();
      if (token == null) {
        return Result.error('Authentication required. Please login.');
      }

      final isOffice = propertyType == 'Office';
      final isLongTerm = minimumStay >= 16;

      final dataMap = <String, dynamic>{
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
        'owner_name': ownerName,
        'owner_phone': ownerNumber,
        'references': references.map((ref) => ref.toJson()).toList(),
        'daily_rate': double.parse(dailyRate),
        'minimum_stay_days': minimumStay,
        'maximum_stay_days': maximumStay,
        'property_features': selectedFeatures,
        'building_amenities': selectedAmenities,
        'house_rules': selectedHouseRules,
        'whats_included': selectedWhatsIncluded,
      };

      if (isOffice) {
        dataMap['office_rooms'] = bedrooms;
        dataMap['office_conference_rooms'] = bathrooms;
        dataMap['office_workstations'] = workstations ?? 1;
      } else {
        dataMap['bedrooms'] = bedrooms;
        dataMap['bathrooms'] = bathrooms;
      }

      if (isLongTerm) {
        dataMap['advance_payment'] = '${advanceMonths ?? 1}';
        dataMap['security_deposit'] = '${securityMonths ?? 1}';
      }

      // Debug: log curl-equivalent payload
      AppLoggerHelper.debug('=== PUBLISH PROPERTY REQUEST ===');
      AppLoggerHelper.debug(
        'curl -X POST "${ApiConstants.postProperty}" \\\n'
        '  -H "Authorization: $token" \\\n'
        '  -F \'data=${jsonEncode(dataMap)}\'',
      );
      AppLoggerHelper.debug('Images count: ${photoLocalPaths.length}');

      final List<http.MultipartFile> files = [];
      for (final path in photoLocalPaths) {
        final file = File(path);
        if (await file.exists()) {
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

      final response = await _networkCaller.multipartRequest(
        ApiConstants.postProperty,
        method: 'POST',
        fields: {'data': jsonEncode(dataMap)},
        files: files,
        token: token,
      );

      // Debug: log full response
      AppLoggerHelper.debug('=== PUBLISH PROPERTY RESPONSE ===');
      AppLoggerHelper.debug('Status: ${response.statusCode}');
      AppLoggerHelper.debug('Body: ${jsonEncode(response.responseData)}');

      if (response.isSuccess) {
        final responseData =
            response.responseData['data'] as Map<String, dynamic>;
        final convertedData = _convertBackendResponse(responseData, isLongTerm);
        return Result.success(convertedData);
      } else {
        return Result.error(response.errorMessage);
      }
    } catch (e) {
      return Result.error('Failed to publish property: $e');
    }
  }

  Map<String, dynamic> _convertBackendResponse(
    Map<String, dynamic> backendData,
    bool isLongTerm,
  ) {
    final isOffice = backendData['property_category'] == 'Office';

    int parseMonths(dynamic value, int defaultValue) {
      if (value == null) return defaultValue;
      if (value is int) return value;
      if (value is String) {
        final match = RegExp(r'(\d+)').firstMatch(value);
        if (match != null) return int.tryParse(match.group(1)!) ?? defaultValue;
      }
      return defaultValue;
    }

    final advanceMonths = isLongTerm
        ? parseMonths(backendData['advance_payment'], 1)
        : 0;
    final securityMonths = isLongTerm
        ? parseMonths(backendData['security_deposit'], 1)
        : 0;
    final dailyRate =
        (backendData['daily_rate'] as num?)?.toDouble() ?? 0.0;

    return {
      'id': backendData['_id'] ??
          'prop_${DateTime.now().millisecondsSinceEpoch}',
      'listingType': isLongTerm ? 'normal' : 'furnished',
      'propertyType': backendData['property_category'] ?? 'Home',
      'bedrooms': isOffice
          ? (backendData['office_rooms'] ?? 1)
          : (backendData['bedrooms'] ?? 1),
      'bathrooms': isOffice
          ? (backendData['office_conference_rooms'] ?? 0)
          : (backendData['bathrooms'] ?? 1),
      'squareFeet':
          (backendData['property_size'] as num?)?.toDouble() ?? 0.0,
      'aboutRental': backendData['about'] ?? '',
      'dailyRate': dailyRate,
      'minimumStay': backendData['minimum_stay_days'] ?? 1,
      'maximumStay': backendData['maximum_stay_days'] ?? 15,
      'advanceMonths': advanceMonths,
      'securityMonths': securityMonths,
      'advanceAmount': dailyRate * advanceMonths,
      'securityDeposit': dailyRate * securityMonths,
      'location': {
        'cityName': backendData['city_name'] ?? '',
        'neighbourhood': backendData['neighborhood'] ?? '',
        'distanceToDowntown': double.tryParse(
              backendData['distance_to_main_road']
                      ?.toString()
                      .replaceAll(RegExp(r'[^0-9.]'), '') ??
                  '0',
            ) ??
            0.0,
        'nearbyLandmarks': backendData['nearby_landmarks'] ?? '',
      },
      'features':
          (backendData['property_features'] as List?)?.cast<String>() ?? [],
      'amenities':
          (backendData['building_amenities'] as List?)?.cast<String>() ?? [],
      'furnishings':
          (backendData['whats_included'] as List?)?.cast<String>() ?? [],
      'houseRules':
          (backendData['house_rules'] as List?)?.cast<String>() ?? [],
      'photos': (backendData['images'] as List?)
              ?.map((img) => img is Map ? img['link'] : img.toString())
              .toList() ??
          [],
      'owner': {
        'name': backendData['owner_name'] ?? '',
        'phoneNumber': backendData['owner_phone'] ?? '',
      },
      'references': (backendData['references'] as List?)
              ?.map((ref) => {
                    'name': ref['reference_name'] ?? '',
                    'phone': ref['reference_phone'] ?? '',
                    'relationship': ref['reference_relationship'] ?? '',
                  })
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

/// Simple Result wrapper for API responses
class Result<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  Result.success(this.data) : error = null, isSuccess = true;

  Result.error(this.error) : data = null, isSuccess = false;
}

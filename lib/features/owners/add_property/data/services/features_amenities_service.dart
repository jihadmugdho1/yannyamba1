import 'package:yannyamba/core/services/network_caller.dart';
import 'package:yannyamba/core/utils/constants/api_constants.dart';
import '../models/features_amenities_model.dart';

/// Service for managing features and amenities data
class FeaturesAmenitiesService {
  final _networkCaller = NetworkCaller();

  /// Get property features
  Future<List<String>> getPropertyFeatures() async {
    try {
      final response = await _networkCaller.getRequest(
        ApiConstants.getPropertyFeatures,
      );
      if (response.isSuccess) {
        final List data = response.responseData['data'];
        final List<String> features = data
            .map((item) => item['featureName']?.toString() ?? '')
            .where((name) => name.isNotEmpty)
            .toList();
        return features;
      } else {
        return [];
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Get amenities
  Future<List<String>> getAmenities() async {
    try {
      final response = await _networkCaller.getRequest(
        ApiConstants.getAmenities,
      );
      if (response.isSuccess) {
        final List data = response.responseData['data'];
        final List<String> amenities = data
            .map((item) => item['amenitiesName']?.toString() ?? '')
            .where((name) => name.isNotEmpty)
            .toList();
        return amenities;
      } else {
        return [];
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Get furnishings
  Future<List<String>> getWhatsIncluded() async {
    try {
      final response = await _networkCaller.getRequest(
        ApiConstants.getWhatsIncluded,
      );
      if (response.isSuccess) {
        final List data = response.responseData['data'];
        final List<String> furnishings = data
            .map((item) => item['name']?.toString() ?? '')
            .where((name) => name.isNotEmpty)
            .toList();
        return furnishings;
      } else {
        return [];
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Get house rules
  Future<List<String>> getHouseRules() async {
    try {
      final response = await _networkCaller.getRequest(
        ApiConstants.getHouseRules,
      );
      if (response.isSuccess) {
        final List data = response.responseData['data'];
        final List<String> rules = data
            .map((item) => item['rulesName']?.toString() ?? '')
            .where((name) => name.isNotEmpty)
            .toList();
        return rules;
      } else {
        return [];
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Get features and amenities data (deprecated, use individual methods)
  /// Currently returns static data, but structured for future API integration
  Future<FeaturesAmenitiesData> getFeaturesAmenitiesData() async {
    // TODO: Replace with API call when backend is ready
    // Example API call structure:
    // final result = await _networkCaller.getRequest(ApiConstants.featuresAmenities);
    // if (result.isSuccess) {
    //   return FeaturesAmenitiesData.fromJson(result.data);
    // } else {
    //   throw Exception(result.error);
    // }

    // For now, return static data
    return FeaturesAmenitiesData(
      propertyFeatures: await getPropertyFeatures(),
      amenities: await getAmenities(),
      furnishings: await getWhatsIncluded(),
      houseRules: await getHouseRules(),
    );
  }
}

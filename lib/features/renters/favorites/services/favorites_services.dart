import 'package:yannyamba/core/core.dart';
import 'package:yannyamba/core/models/property/property_models.dart';

class FavoritesService {
  final _networkCaller = NetworkCaller();

  Future<List<Apartment>> getFavorites() async {
    try {
      final token = await StorageService.getToken();
      final response = await _networkCaller.getRequest(
        ApiConstants.getFavorites,
        token: token,
      );

      if (!response.isSuccess) {
        throw Exception(response.errorMessage);
      }

      AppLoggerHelper.debug('Get Favorites Response: ${response.statusCode}');
      AppLoggerHelper.debug('Get Favorites Body: ${response.responseData}');

      // Extract apartment objects from the response
      final data = response.responseData['data'];
      if (data != null && data['fevouriteAppartments'] != null) {
        final favoriteApartments = data['fevouriteAppartments'] as List;
        return favoriteApartments.map((apartmentJson) {
          // Check listing_type to determine which model to use
          final listingType = apartmentJson['listing_type'] as String?;
          if (listingType == 'Furnished Apartment') {
            return FurnishedApartment.fromJson(apartmentJson);
          } else {
            return Apartment.fromJson(apartmentJson);
          }
        }).toList();
      }

      return [];
    } catch (e) {
      AppLoggerHelper.error('Error fetching favorites', e);
      rethrow;
    }
  }

  Future<void> addToFavorites(String apartmentId) async {
    try {
      final token = await StorageService.getToken();
      final response = await _networkCaller.postRequest(
        ApiConstants.addToFavorites,
        body: {'apartmentId': apartmentId},
        token: token,
      );

      if (!response.isSuccess) {
        throw Exception(response.errorMessage);
      }

      AppLoggerHelper.debug(
        'Add to Favorites Response: ${response.statusCode}',
      );
      AppLoggerHelper.debug('Add to Favorites Body: ${response.responseData}');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeFromFavorites(String apartmentId) async {
    try {
      final token = await StorageService.getToken();
      final response = await _networkCaller.deleteRequest(
        ApiConstants.deleteFromFavorites,
        body: {'apartmentId': apartmentId},
        token: token,
      );

      if (!response.isSuccess) {
        throw Exception(response.errorMessage);
      }

      AppLoggerHelper.debug(
        'Remove from Favorites Response: ${response.statusCode}',
      );
      AppLoggerHelper.debug(
        'Remove from Favorites Body: ${response.responseData}',
      );
    } catch (e) {
      rethrow;
    }
  }
}

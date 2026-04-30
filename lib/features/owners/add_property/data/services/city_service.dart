import 'package:yannyamba/core/core.dart';

import '../models/city_model.dart';

class CityService {
  CityService({NetworkCaller? networkCaller})
    : _networkCaller = networkCaller ?? NetworkCaller();

  final NetworkCaller _networkCaller;

  Future<List<CityModel>> fetchCities() async {
    final response = await _networkCaller.getRequest(ApiConstants.getCities);

    if (!response.isSuccess || response.responseData == null) {
      throw Exception(
        response.errorMessage.isEmpty
            ? 'Failed to load cities'
            : response.errorMessage,
      );
    }

    final data = response.responseData;
    if (data is! Map<String, dynamic>) {
      throw Exception('Unexpected city response format');
    }

    final rawCities = data['data'];
    if (rawCities is! List) {
      throw Exception('City list not found in response');
    }

    return rawCities
        .whereType<Map>()
        .map((item) => CityModel.fromJson(Map<String, dynamic>.from(item)))
        .where((city) => city.cityName.isNotEmpty)
        .toList();
  }
}

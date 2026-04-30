/// Base API service for making HTTP requests
/// This will be used when the backend API is ready
class ApiService {
  // Base URL - will be configured when API is ready
  static const String baseUrl =
      'http://46.224.80.189:5000'; // TODO: Update with actual API URL

  // API endpoints
  static const String apartmentsEndpoint = '/api/v1/apartments';
  static const String ownersEndpoint = '/api/v1/owners';

  // TODO: Add HTTP client (dio, http) when API is ready
  // final Dio _dio = Dio();

  // Example method structure for future API integration
  /*
  Future<ResponseData<List<Apartment>>> getApartments({
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await _dio.get(
        '$baseUrl$apartmentsEndpoint',
        queryParameters: queryParams,
      );
      
      final apartments = (response.data['data'] as List)
          .map((json) => Apartment.fromJson(json))
          .toList();
          
      return ResponseData.success(apartments);
    } catch (e) {
      return ResponseData.error(e.toString());
    }
  }
  */
}

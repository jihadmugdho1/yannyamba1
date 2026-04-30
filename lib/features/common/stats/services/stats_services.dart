import 'package:yannyamba/core/core.dart';

class StatsServices {
  final _networkCaller = NetworkCaller();
  //Increment the view count for any apartment
  Future<void> incrementViewCount(String apartmentId) async {
    try {
      final token = await StorageService.getToken();
      final response = await _networkCaller.postRequest(
        ApiConstants.incrementApartmentViewCount.replaceFirst(
          '{apartmentId}',
          apartmentId,
        ),
        headers: {'Authorization': '$token'},
      );

      AppLoggerHelper.debug(
        'Increment View Count Response: ${response.statusCode}',
      );
      AppLoggerHelper.debug(
        'Increment View Count Body: ${response.responseData}',
      );
    } catch (e) {
      rethrow;
    }
  }

  //Inbcrement the query count for any apartment
  Future<void> incrementQueryCount(String apartmentId) async {
    try {
      final token = await StorageService.getToken();
      final response = await _networkCaller.postRequest(
        ApiConstants.incrementQueryCount.replaceFirst(
          '{apartmentId}',
          apartmentId,
        ),
        headers: {'Authorization': '$token'},
      );

      AppLoggerHelper.debug(
        'Increment Query Count Response: ${response.statusCode}',
      );
      AppLoggerHelper.debug(
        'Increment Query Count Body: ${response.responseData}',
      );
    } catch (e) {
      rethrow;
    }
  }
}

import 'package:yannyamba/core/core.dart';

import '../models/neighborhood_model.dart';

class NeighborhoodService {
  NeighborhoodService({NetworkCaller? networkCaller})
    : _networkCaller = networkCaller ?? NetworkCaller();

  final NetworkCaller _networkCaller;

  Future<List<NeighborhoodModel>> fetchNeighborhoods() async {
    final response = await _networkCaller.getRequest(
      ApiConstants.getNeighborhoods,
    );

    if (!response.isSuccess || response.responseData == null) {
      throw Exception(
        response.errorMessage.isEmpty
            ? 'Failed to load neighborhoods'
            : response.errorMessage,
      );
    }

    final data = response.responseData;
    if (data is! Map<String, dynamic>) {
      throw Exception('Unexpected neighborhood response format');
    }

    final rawNeighborhoods = data['data'];
    if (rawNeighborhoods is! List) {
      throw Exception('Neighborhood list not found in response');
    }

    return rawNeighborhoods
        .whereType<Map>()
        .map(
          (item) => NeighborhoodModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .where((item) => item.name.isNotEmpty)
        .toList();
  }
}

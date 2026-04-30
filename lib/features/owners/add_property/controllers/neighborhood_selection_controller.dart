import 'package:get/get.dart';

import '../data/models/neighborhood_model.dart';
import '../data/services/neighborhood_service.dart';

class NeighborhoodSelectionController extends GetxController {
  NeighborhoodSelectionController({
    required NeighborhoodService neighborhoodService,
  }) : _neighborhoodService = neighborhoodService;

  final NeighborhoodService _neighborhoodService;

  final selectedNeighborhood = ''.obs;
  final neighborhoodList = <NeighborhoodModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNeighborhoods();
  }

  List<String> get neighborhoods {
    final names = neighborhoodList
        .map((item) => item.name.trim())
        .toSet()
        .toList();
    names.sort();
    return names;
  }

  Future<void> fetchNeighborhoods() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final fetchedNeighborhoods = await _neighborhoodService
          .fetchNeighborhoods();
      neighborhoodList.assignAll(fetchedNeighborhoods);
    } catch (e) {
      neighborhoodList.clear();
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  void onNeighborhoodSelected(String neighborhood) {
    selectedNeighborhood.value = neighborhood;
  }

  void clearSelection() {
    selectedNeighborhood.value = '';
  }
}

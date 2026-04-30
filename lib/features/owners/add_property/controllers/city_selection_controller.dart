import 'package:get/get.dart';

import '../data/models/city_model.dart';
import '../data/services/city_service.dart';

class CitySelectionController extends GetxController {
  CitySelectionController({required CityService cityService})
    : _cityService = cityService;

  final CityService _cityService;

  final selectedCity = ''.obs;
  final availableNeighbourhoods = <String>[].obs;
  final cityList = <CityModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCities();
  }

  List<String> get cities {
    final names = cityList.map((city) => city.cityName.trim()).toSet().toList();
    names.sort();
    return names;
  }

  Future<void> fetchCities() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final fetchedCities = await _cityService.fetchCities();
      cityList.assignAll(fetchedCities);
    } catch (e) {
      cityList.clear();
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  void onCitySelected(String city) {
    selectedCity.value = city;
    availableNeighbourhoods.clear();
  }

  List<String> getNeighbourhoodsForCity(String city) {
    return const [];
  }

  void clearSelection() {
    selectedCity.value = '';
    availableNeighbourhoods.clear();
  }
}

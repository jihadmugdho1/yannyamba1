import 'package:get/get.dart';
import '../data/models/features_amenities_model.dart';
import '../data/services/features_amenities_service.dart';

/// Controller for managing features and amenities data
class FeaturesAmenitiesController extends GetxController {
  final FeaturesAmenitiesService _service = FeaturesAmenitiesService();

  // Reactive data
  final featuresAmenitiesData = Rx<FeaturesAmenitiesData?>(null);
  final isLoading = false.obs;
  final error = Rx<String?>(null);

  // Reactive lists for UI binding
  final propertyFeatures = <String>[].obs;
  final amenities = <String>[].obs;
  final furnishings = <String>[].obs;
  final houseRules = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadFeaturesAmenitiesData();
  }

  /// Load features and amenities data
  Future<void> loadFeaturesAmenitiesData() async {
    try {
      isLoading.value = true;
      error.value = null;

      // Load each list separately
      final propertyFeaturesList = await _service.getPropertyFeatures();
      final amenitiesList = await _service.getAmenities();
      final whatsIncludedList = await _service.getWhatsIncluded();
      final houseRulesList = await _service.getHouseRules();

      propertyFeatures.assignAll(propertyFeaturesList);
      amenities.assignAll(amenitiesList);
      furnishings.assignAll(whatsIncludedList);
      houseRules.assignAll(houseRulesList);

      // Update the full data model if needed
      featuresAmenitiesData.value = FeaturesAmenitiesData(
        propertyFeatures: propertyFeaturesList,
        amenities: amenitiesList,
        furnishings: whatsIncludedList,
        houseRules: houseRulesList,
      );
    } catch (e) {
      error.value = 'Failed to load features and amenities: $e';
      // Provide fallback empty lists
      propertyFeatures.clear();
      amenities.clear();
      furnishings.clear();
      houseRules.clear();
      featuresAmenitiesData.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh data
  @override
  Future<void> refresh() async {
    await loadFeaturesAmenitiesData();
  }
}

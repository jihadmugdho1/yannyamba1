import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yannyamba/core/core.dart';
import '../../../controllers/add_property_controller.dart';
import '../../../controllers/city_selection_controller.dart';
import '../../../controllers/neighborhood_selection_controller.dart';
import '../../widgets/form_navigation_buttons.dart';
import '../../widgets/searchable_dropdown.dart';
import '../../widgets/location_text_field.dart';

class Step3LocationDetails extends StatelessWidget {
  const Step3LocationDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddPropertyController>();
    final cityController = Get.find<CitySelectionController>();
    final neighborhoodController = Get.find<NeighborhoodSelectionController>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppText.locationDetails.tr,
              style: getTextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: AppColors.textColor,
                font: AppFont.supreme,
              ),
            ),
            SizedBox(height: 8.h),
            const Divider(color: Color(0xFFE5E7EB), thickness: 1),
            SizedBox(height: 8.h),
            Obx(
              () => SearchableDropdown(
                label: AppText.cityName.tr,
                hint: cityController.isLoading.value
                    ? 'Loading cities...'
                    : cityController.errorMessage.value.isNotEmpty
                    ? 'Failed to load cities'
                    : AppText.selectCity.tr,
                value: controller.cityName.value.isEmpty
                    ? null
                    : controller.cityName.value,
                onChanged: (value) {
                  controller.cityName.value = value ?? '';
                  cityController.onCitySelected(value ?? '');
                  controller.neighbourhood.value = '';
                  controller.neighbourhoodController.clear();
                  neighborhoodController.clearSelection();
                },
                items: cityController.cities,
                isEnabled: cityController.cities.isNotEmpty,
                isLoading: cityController.isLoading.value,
                icon: Icons.location_city,
                searchHint: 'Search for a city...',
              ),
            ),
            Obx(
              () => cityController.errorMessage.value.isEmpty
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              cityController.errorMessage.value,
                              style: getTextStyle(
                                fontSize: 12,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: cityController.fetchCities,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
            ),
            SizedBox(height: 8.h),
            Obx(
              () => LocationTextField(
                label: AppText.neighbourhood.tr,
                hint: neighborhoodController.isLoading.value
                    ? 'Loading neighbourhoods...'
                    : neighborhoodController.errorMessage.value.isNotEmpty
                    ? 'Failed to load neighbourhoods'
                    : 'Select neighbourhood',
                textController: controller.neighbourhoodController,
                onChanged: (value) {
                  controller.neighbourhood.value = value;
                  neighborhoodController.onNeighborhoodSelected(value);
                },
                items: neighborhoodController.neighborhoods,
                isEnabled: neighborhoodController.neighborhoods.isNotEmpty,
                isLoading: neighborhoodController.isLoading.value,
                searchHint: 'Search for a neighbourhood...',
                errorText: neighborhoodController.errorMessage.value.isEmpty
                    ? null
                    : neighborhoodController.errorMessage.value,
                onRetry: neighborhoodController.fetchNeighborhoods,
              ),
            ),
            SizedBox(height: 8.h),
            LocationTextField(
              label: AppText.distanceToMainRoad.tr,
              hint: AppText.egDistanceToMainRoad.tr,
              textController: controller.distanceToDowntownController,
              onChanged: (value) => controller.distanceToDowntown.value = value,
            ),
            SizedBox(height: 8.h),
            LocationTextField(
              label: AppText.nearbyLandmarks.tr,
              hint: AppText.egNearbyLandmarks.tr,
              maxLines: 3,
              textController: controller.nearbyLandmarksController,
              onChanged: (value) => controller.nearbyLandmarks.value = value,
            ),
            SizedBox(height: 32.h),
            FormNavigationButtons(
              onPrevious: controller.previousStep,
              onNext: () {
                if (controller.validateStep3()) {
                  controller.nextStep();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${AppText.incomplete.tr}\n${AppText.pleaseProvideTheRequiredLocationDetails.tr}',
                      ),
                      backgroundColor: const Color(0xFFEF4444),
                      duration: const Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

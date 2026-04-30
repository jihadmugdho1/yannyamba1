import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yannyamba/core/core.dart';
import '../../../controllers/add_property_controller.dart';
import '../../../controllers/features_amenities_controller.dart';
import '../../widgets/form_navigation_buttons.dart';

class Step4FeaturesAmenities extends StatelessWidget {
  const Step4FeaturesAmenities({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddPropertyController>();
    final featuresController = Get.find<FeaturesAmenitiesController>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Obx(() {
          final isFurnished = controller.listingType.value == 'furnished';
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isFurnished
                    ? AppText.amenitiesAndRules.tr
                    : AppText.featuresAndAmenities.tr,
                style: getTextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor,
                  font: AppFont.supreme,
                ),
              ),
              SizedBox(height: 8.h),
              const Divider(),

              // Show furnished-specific fields or normal fields
              if (isFurnished) ...[
                Text(
                  AppText.whatsIncluded.tr,
                  style: getTextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textColor,
                    font: AppFont.supreme,
                  ),
                ),
                const Divider(),
                SizedBox(height: 12.h),
                Obx(
                  () => _buildCheckboxGrid(
                    items: featuresController.furnishings,
                    selectedItems: controller.selectedFurnishings,
                    onToggle: (furnishing) =>
                        controller.toggleFurnishing(furnishing),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  AppText.houseRules.tr,
                  style: getTextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textColor,
                    font: AppFont.supreme,
                  ),
                ),
                const Divider(),
                SizedBox(height: 12.h),
                Obx(
                  () => _buildCheckboxGrid(
                    items: featuresController.houseRules,
                    selectedItems: controller.selectedHouseRules,
                    onToggle: (rule) => controller.toggleHouseRule(rule),
                  ),
                ),
              ] else ...[
                Text(
                  AppText.propertyFeatures.tr,
                  style: getTextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textColor,
                    font: AppFont.supreme,
                  ),
                ),
                const Divider(),
                SizedBox(height: 12.h),
                Obx(
                  () => _buildCheckboxGrid(
                    items: featuresController.propertyFeatures,
                    selectedItems: controller.selectedFeatures,
                    onToggle: (feature) => controller.toggleFeature(feature),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  AppText.buildingAmenities.tr,
                  style: getTextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textColor,
                    font: AppFont.supreme,
                  ),
                ),
                const Divider(),
                SizedBox(height: 12.h),
                Obx(
                  () => _buildCheckboxGrid(
                    items: featuresController.amenities,
                    selectedItems: controller.selectedAmenities,
                    onToggle: (amenity) => controller.toggleAmenity(amenity),
                  ),
                ),
              ],
              SizedBox(height: 16.h),

              FormNavigationButtons(
                onPrevious: controller.previousStep,
                onNext: () {
                  if (controller.validateStep4()) {
                    controller.nextStep();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isFurnished
                              ? AppText.selectAtLeastOneFurnishingOrRule.tr
                              : AppText.selectAtLeastOneFeatureOrAmenity.tr,
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
          );
        }),
      ),
    );
  }

  static Widget _buildCheckboxGrid({
    required List<String> items,
    required RxList<String> selectedItems,
    required Function(String) onToggle,
  }) {
    return Column(
      children: [
        for (int i = 0; i < items.length; i += 2)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Expanded(
                  child: _buildCheckboxItem(
                    label: items[i],
                    isSelected: selectedItems.contains(items[i]),
                    onToggle: () => onToggle(items[i]),
                  ),
                ),
                const SizedBox(width: 12),
                if (i + 1 < items.length)
                  Expanded(
                    child: _buildCheckboxItem(
                      label: items[i + 1],
                      isSelected: selectedItems.contains(items[i + 1]),
                      onToggle: () => onToggle(items[i + 1]),
                    ),
                  )
                else
                  const Expanded(child: SizedBox()),
              ],
            ),
          ),
      ],
    );
  }

  static Widget _buildCheckboxItem({
    required String label,
    required bool isSelected,
    required VoidCallback onToggle,
  }) {
    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4).w,
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF2196F3) : Colors.white,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF2196F3)
                      : const Color(0xFF9CA3AF),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: getTextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

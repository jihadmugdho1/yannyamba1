import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yannyamba/core/core.dart';
import '../../controllers/furnished_apartment_controller.dart';

class FurnishedApartmentFilterScreen extends StatelessWidget {
  FurnishedApartmentFilterScreen({super.key});

  final FurnishedApartmentController controller =
      Get.find<FurnishedApartmentController>();

  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          AppText.filters.tr,
          style: getTextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.resetFilters();
              // Clear text fields to show hint text
              _minPriceController.clear();
              _maxPriceController.clear();
            },
            child: Text(
              AppText.reset.tr,
              style: getTextStyle(
                fontSize: 13.sp,
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Range Section
            // _buildSectionTitle(AppText.availableDates.tr),
            // _buildDateRangeSelector(),
            // SizedBox(height: 20.h),
            _buildSectionTitle(AppText.priceRange.tr),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minPriceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: AppText.minPrice.tr,
                      hintText: '0',
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 8.h,
                      ),
                    ),
                    onChanged: (value) {
                      final min = double.tryParse(value) ?? 0;
                      controller.updatePriceRange(
                        min,
                        controller.priceRange[1],
                      );
                    },
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: TextField(
                    controller: _maxPriceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: AppText.maxPrice.tr,
                      hintText: '1000',
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 8.h,
                      ),
                    ),
                    onChanged: (value) {
                      final max = double.tryParse(value) ?? 1000;
                      controller.updatePriceRange(
                        controller.priceRange[0],
                        max,
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle(AppText.rooms.tr),
                      Obx(
                        () => _buildCounter(
                          value: controller.selectedRooms.value,
                          onIncrement: () => controller.updateRooms(
                            controller.selectedRooms.value + 1,
                          ),
                          onDecrement: () => controller.selectedRooms.value > 0
                              ? controller.updateRooms(
                                  controller.selectedRooms.value - 1,
                                )
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1.w,
                  height: 50.h,
                  color: Colors.grey.shade300,
                  margin: EdgeInsets.symmetric(horizontal: 12.w),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle(AppText.bathrooms.tr),
                      Obx(
                        () => _buildCounter(
                          value: controller.selectedBathrooms.value,
                          onIncrement: () => controller.updateBathrooms(
                            controller.selectedBathrooms.value + 1,
                          ),
                          onDecrement: () =>
                              controller.selectedBathrooms.value > 0
                              ? controller.updateBathrooms(
                                  controller.selectedBathrooms.value - 1,
                                )
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 20.h),
            // _buildSectionTitle('Amenities'),
            // Obx(
            //   () => Wrap(
            //     spacing: 6.w,
            //     runSpacing: 6.h,
            //     children: controller.availableAmenities
            //         .map((amenity) => _buildAmenityChip(amenity))
            //         .toList(),
            //   ),
            // ),
            // SizedBox(height: 20.h),`

            // City Filter Section
            _buildSectionTitle('Cities'),
            Obx(() {
              return SearchableMultiSelectDropdown(
                key: ValueKey(
                  'city_filter_${controller.selectedCities.length}_${controller.selectedCities.hashCode}',
                ),
                selectedItems: controller.selectedCities,
                allItems: controller.availableCities,
                onToggle: controller.toggleCity,
                title: 'Cities',
                placeholder: 'Choose cities',
              );
            }),
            SizedBox(height: 20.h),

            // Neighborhood Filter Section
            _buildSectionTitle(AppText.neighborhoods.tr),
            Obx(() {
              return SearchableMultiSelectDropdown(
                key: ValueKey(
                  'neighborhood_filter_${controller.selectedNeighborhoods.length}_${controller.selectedNeighborhoods.hashCode}',
                ),
                selectedItems: controller.selectedNeighborhoods,
                allItems: controller.availableNeighborhoods,
                onToggle: controller.toggleNeighborhood,
                title: AppText.neighborhoods.tr,
                placeholder: AppText.chooseNeighborhoods.tr,
              );
            }),
            SizedBox(height: 20.h),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .08),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: () {
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Obx(
              () => Text(
                '${AppText.showProperties.tr} ${controller.filteredApartments.length} Properties',
                style: getTextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        title,
        style: getTextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildCounter({
    required int value,
    required VoidCallback onIncrement,
    required VoidCallback? onDecrement,
  }) {
    return Row(
      children: [
        IconButton(
          onPressed: onDecrement,
          icon: const Icon(Icons.remove_circle_outline),
          color: onDecrement != null ? AppColors.primaryBlue : Colors.grey,
          iconSize: 22.sp,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.backgroundLight,
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Text(
            value.toString(),
            style: getTextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
          ),
        ),
        IconButton(
          onPressed: onIncrement,
          icon: const Icon(Icons.add_circle_outline),
          color: AppColors.primaryBlue,
          iconSize: 22.sp,
        ),
      ],
    );
  }
}

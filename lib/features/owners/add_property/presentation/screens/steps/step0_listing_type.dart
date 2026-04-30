import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yannyamba/core/core.dart';
import 'package:yannyamba/features/renters/home/controllers/home_controller.dart';
import '../../../controllers/add_property_controller.dart';
import '../../widgets/form_navigation_buttons.dart';

class Step0ListingType extends StatelessWidget {
  const Step0ListingType({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddPropertyController>();
    final homeController = Get.find<HomeController>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E5E5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppText.chooseListingType.tr,
              style: getTextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor,
                font: AppFont.supreme,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              AppText.selectListingType.tr,
              style: getTextStyle(fontSize: 14, color: AppColors.textColor2),
            ),
            SizedBox(height: 8.h),
            Divider(color: const Color(0xFFE5E7EB), thickness: 1),
            SizedBox(height: 24.h),
            Obx(
              () => _buildListingTypeCard(
                controller: controller,
                type: 'normal',
                icon: Icons.apartment,
                title: AppText.normalApartment.tr,
                subtitle: AppText.traditionalLongTermRental.tr,
                features: [
                  AppText.monthlyRentPayments.tr,
                  AppText.securityDepositRequired.tr,
                  AppText.advancePayments.tr,
                  AppText.longTermLease.tr,
                ],
                isSelected: controller.listingType.value == 'normal',
                isEnabled: homeController.showNotmalApartmentsSection.value,
              ),
            ),
            SizedBox(height: 16.h),
            Obx(
              () => _buildListingTypeCard(
                controller: controller,
                type: 'furnished',
                icon: Icons.holiday_village,
                title: AppText.furnishedApartment.tr,
                subtitle: AppText.shortTermDailyRental.tr,
                features: [
                  AppText.dailyRatePricing.tr,
                  AppText.flexibleCheckInOut.tr,
                  AppText.minMaxStay.tr,
                ],
                isSelected: controller.listingType.value == 'furnished',
                isEnabled: true,
              ),
            ),
            SizedBox(height: 24.h),
            Divider(color: const Color(0xFFE5E7EB), thickness: 1),
            SizedBox(height: 24.h),
            FormNavigationButtons(
              onPrevious: () {},
              onNext: () {
                if (controller.listingType.value.isNotEmpty) {
                  controller.nextStep();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppText.selectionRequired.tr,
                            style: getTextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textColor,
                            ),
                          ),
                          Text(
                            AppText.pleaseSelectListingType.tr,
                            style: getTextStyle(color: AppColors.textColor2),
                          ),
                        ],
                      ),
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.all(16),
                      backgroundColor: Colors.white,
                      duration: const Duration(seconds: 3),
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

  Widget _buildListingTypeCard({
    required AddPropertyController controller,
    required String type,
    required IconData icon,
    required String title,
    required String subtitle,
    required List<String> features,
    required bool isSelected,
    required bool isEnabled,
  }) {
    return GestureDetector(
      onTap: isEnabled
          ? () => controller.listingType.value = type
          : () {
              ScaffoldMessenger.of(Get.context!).showSnackBar(
                SnackBar(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Coming Soon",
                        style: getTextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor,
                        ),
                      ),
                      Text(
                        "Normal Apartment listing will be available soon!",
                        style: getTextStyle(
                          color: AppColors.textColor2,
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.all(16),
                  backgroundColor: Colors.white,
                  duration: const Duration(seconds: 1),
                ),
              );
            },
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: isEnabled
                  ? (isSelected
                        ? const Color(0xFFEBF5FF)
                        : const Color(0xFFF9FAFB))
                  : const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isEnabled
                    ? (isSelected
                          ? const Color(0xFF2196F3)
                          : const Color(0xFFE5E7EB))
                    : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: isEnabled
                            ? (isSelected
                                  ? const Color(0xFF2196F3)
                                  : const Color(0xFFE5E7EB))
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        icon,
                        color: isEnabled
                            ? (isSelected
                                  ? Colors.white
                                  : const Color(0xFF686868))
                            : Colors.grey,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: getTextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isEnabled
                                  ? AppColors.textColor
                                  : Colors.grey,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            isEnabled ? subtitle : "Coming Soon…",
                            style: getTextStyle(
                              fontSize: 12,
                              color: isEnabled
                                  ? AppColors.textColor2
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected && isEnabled)
                      Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: const BoxDecoration(
                          color: Color(0xFF2196F3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 16.h),
                Divider(color: const Color(0xFFE5E7EB), thickness: 1),
                SizedBox(height: 12.h),
                if (!isEnabled)
                  Text(
                    "Normal apartment listings are not available yet. We’re preparing this feature and will launch it very soon!",
                    style: getTextStyle(fontSize: 13, color: Colors.grey),
                  )
                else
                  ...features.map(
                    (feature) => Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 16,
                            color: isSelected
                                ? const Color(0xFF2196F3)
                                : const Color(0xFF686868),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              feature,
                              style: getTextStyle(
                                fontSize: 13,
                                color: AppColors.textColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (!isEnabled)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(
                    Icons.lock,
                    size: 40,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

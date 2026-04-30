import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yannyamba/core/core.dart';
import '../../../controllers/add_property_controller.dart';
import '../../widgets/bed_bath_dropdowns.dart';
import '../../widgets/office_dropdowns.dart';
import '../../widgets/form_navigation_buttons.dart';
// import '../../widgets/lease_takeover_toggle.dart';
import '../../widgets/property_type_dropdown.dart';

class Step1BasicInfo extends StatelessWidget {
  const Step1BasicInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddPropertyController>();

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
              AppText.basicInformation.tr,
              style: getTextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppColors.textColor,
                font: AppFont.supreme,
              ),
            ),
            SizedBox(height: 8.h),
            Divider(color: Color(0xFFE5E7EB), thickness: 1),
            SizedBox(height: 8.h),
            Text(AppText.propertyCategory.tr, style: _sectionLabelStyle()),
            SizedBox(height: 4.h),
            Text(
              AppText.chooseFromHomeOffice.tr,
              style: getTextStyle(fontSize: 12, color: AppColors.textColor2),
            ),
            SizedBox(height: 8.h),
            PropertyTypeDropdown(controller: controller),
            SizedBox(height: 20.h),

            // Conditionally show bedroom/bathroom OR office-specific fields
            Obx(() {
              if (controller.propertyType.value == 'Office') {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppText.officeDetails.tr, style: _sectionLabelStyle()),
                    SizedBox(height: 8.h),
                    Text(
                      AppText.specifyOfficeRooms.tr,
                      style: getTextStyle(
                        fontSize: 12,
                        color: AppColors.textColor2,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    OfficeDropdowns(controller: controller),
                  ],
                );
              } else if (controller.propertyType.value == 'Home') {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppText.roomsAndBathrooms.tr,
                      style: _sectionLabelStyle(),
                    ),
                    SizedBox(height: 8.h),
                    BedBathDropdowns(controller: controller),
                  ],
                );
              } else {
                // No property type selected yet
                return const SizedBox.shrink();
              }
            }),

            SizedBox(height: 20.h),
            Text(AppText.propertySizeOptional.tr, style: _sectionLabelStyle()),
            SizedBox(height: 8.h),
            TextField(
              controller: controller.propertySizeController,
              onChanged: (value) => controller.propertySize.value = value,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: AppText.enterPropertySize.tr,
                hintStyle: getTextStyle(
                  color: AppColors.textColor2,
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
                filled: true,
                fillColor: const Color(0xFFF9FAFB),
                contentPadding: const EdgeInsets.all(16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color(0xFF2196F3),
                    width: 2,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(AppText.aboutThisRental.tr, style: _sectionLabelStyle()),
            SizedBox(height: 8.h),
            TextField(
              controller: controller.aboutRentalController,
              onChanged: (value) => controller.aboutRental.value = value,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: AppText.describeYourProperty.tr,
                hintStyle: getTextStyle(
                  color: AppColors.textColor2,
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
                filled: true,
                fillColor: const Color(0xFFF9FAFB),
                contentPadding: const EdgeInsets.all(16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color(0xFF2196F3),
                    width: 2,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // Only show Lease Takeover for normal apartments
            // Obx(() {
            //   if (controller.listingType.value == 'normal') {
            //     return Column(
            //       children: [
            //         LeaseTakeoverToggle(controller: controller),
            //         SizedBox(height: 16.h),
            //       ],
            //     );
            //   }
            //   return const SizedBox.shrink();
            // }),
            Divider(color: Color(0xFFE5E7EB), thickness: 1),
            SizedBox(height: 24.h),
            FormNavigationButtons(
              onPrevious: () {
                controller.previousStep();
              },
              onNext: () {
                if (controller.validateStep1()) {
                  controller.nextStep();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${AppText.incomplete.tr}: ${AppText.pleaseFillAllRequiredFields.tr}',
                        style: getTextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                        ),
                      ),
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.all(16),
                      backgroundColor: Colors.white,
                      duration: const Duration(seconds: 1),
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

  TextStyle _sectionLabelStyle() {
    return getTextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.textColor,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yannyamba/core/core.dart';

import '../../../controllers/add_property_controller.dart';
import '../../../controllers/property_photo_controller.dart';
import '../../widgets/form_navigation_buttons.dart';
import '../../widgets/property_photo_widgets.dart';

class Step5PropertyPhotos extends StatelessWidget {
  const Step5PropertyPhotos({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddPropertyController>();
    final photoController = Get.isRegistered<PropertyPhotoController>()
        ? Get.find<PropertyPhotoController>()
        : Get.put(PropertyPhotoController());

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(16.w),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE5E7EB)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppText.propertyPhotos.tr,
                    style: getTextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColor,
                      font: AppFont.supreme,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    '${AppText.addAtLeast3HighQualityPhotos.tr} (max ${photoController.maxPhotos})',
                    style: getTextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textColor2,
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Obx(
                    () => photoController.propertyPhotos.isEmpty
                        ? PropertyPhotoUploadArea(
                            onChoosePhotos: () =>
                                photoController.openImageSourceSheet(context),
                          )
                        : PropertyPhotosGrid(
                            photos: photoController.propertyPhotos,
                            onRemove: photoController.removePhoto,
                          ),
                  ),
                  SizedBox(height: 12.h),
                  Obx(
                    () =>
                        photoController.propertyPhotos.isNotEmpty &&
                            photoController.propertyPhotos.length <
                                photoController.maxPhotos
                        ? SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () =>
                                  photoController.openImageSourceSheet(context),
                              icon: Icon(
                                Icons.add_photo_alternate,
                                size: 20.sp,
                              ),
                              label: Text(
                                '${AppText.addMorePhotos.tr} (${photoController.propertyPhotos.length}/${photoController.maxPhotos})',
                                style: getTextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  font: AppFont.supreme,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                side: const BorderSide(
                                  color: Color(0xFF2196F3),
                                  width: 1.5,
                                ),
                                foregroundColor: const Color(0xFF2196F3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppText.photoGuidelines.tr,
                          style: getTextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF894B00),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        _GuidelineText(
                          text: AppText.firstPhotoWillBeTheMainListingImage.tr,
                          color: const Color(0xFF894B00),
                        ),
                        SizedBox(height: 8.h),
                        _GuidelineText(
                          text: AppText
                              .considerIncludingUtilitiesInRentForConvenience
                              .tr,
                          color: const Color(0xFF193CB8),
                        ),
                        SizedBox(height: 8.h),
                        _GuidelineText(
                          text: AppText.beCompetitiveButFairWithYourPricing.tr,
                          color: const Color(0xFF193CB8),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),

                  /// ✅ FormNavigationButtons moved inside the box
                  FormNavigationButtons(
                    onPrevious: controller.previousStep,
                    onNext: () {
                      if (controller.validateStep5()) {
                        controller.nextStep();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: const Color(0xFFEF4444),
                            duration: const Duration(seconds: 1),
                            behavior: SnackBarBehavior.floating,
                            margin: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppText.incomplete.tr,
                                  style: getTextStyle(
                                    fontSize: 8.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textColor,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  AppText
                                      .addTheRequiredPropertyPhotosBeforeContinuing
                                      .tr,
                                  style: getTextStyle(
                                    fontSize: 8.sp,
                                    color: AppColors.textColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuidelineText extends StatelessWidget {
  const _GuidelineText({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: getTextStyle(fontSize: 11.sp, color: color),
    );
  }
}

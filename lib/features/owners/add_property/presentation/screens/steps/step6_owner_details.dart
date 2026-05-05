import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yannyamba/core/common/styles/global_text_style.dart';
import 'package:yannyamba/core/utils/constants/app_texts.dart';
import 'package:yannyamba/core/utils/constants/colors.dart';
import '../../../controllers/add_property_controller.dart';
import '../../widgets/owner_section.dart';
import '../../widgets/reference_section.dart';

class Step6OwnerDetails extends StatelessWidget {
  const Step6OwnerDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddPropertyController>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OwnerSection(controller: controller),
          SizedBox(height: 24.h),
          ReferenceSection(controller: controller),
          SizedBox(height: 32.h),

          // Upload Progress
          Obx(() {
            if (controller.isSubmitting.value) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF2196F3)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF2196F3),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            controller.uploadStatus.value,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2196F3),
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (controller.uploadProgress.value > 0) ...[
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: controller.uploadProgress.value,
                        backgroundColor: Colors.white,
                        color: const Color(0xFF2196F3),
                      ),
                    ],
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),
          const SizedBox(height: 16),

          // Navigation Buttons
          Obx(
            () => Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: controller.isSubmitting.value
                        ? null
                        : () => controller.previousStep(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Color(0xFFE5E7EB)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      AppText.previous.tr,
                      style: getTextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.h),
                Expanded(
                  child: ElevatedButton(
                    onPressed: controller.isSubmitting.value
                        ? null
                        : () {
                            if (controller.validateStep6()) {
                              _showPublishConfirmation(context, controller);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${AppText.incomplete.tr}\n${AppText.pleaseFillAllRequiredFields.tr}',
                                    style: const TextStyle(color: Colors.black),
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
                    style: ElevatedButton.styleFrom(
                      side: BorderSide.none,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: const Color(0xFF10B981),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      AppText.publishProperty.tr,
                      style: getTextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textWhite,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _showPublishConfirmation(
    BuildContext context,
    AddPropertyController controller,
  ) {
    // For short-term rentals (furnished apartments), skip the landlord loyalty program
    // and proceed directly to publishing
    if (controller.listingType.value == 'furnished') {
      controller.submitProperty(context);
      return;
    }

    // For long-term rentals, show the landlord loyalty credit program dialog
    bool isAgreed = false;
    // Capture the parent context before showing dialog
    final parentContext = context;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              title: Row(
                children: [
                  const Icon(
                    Icons.verified_rounded,
                    color: Color(0xFF10B981),
                    size: 28,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      AppText.landlordLoyaltyCreditProgram.tr,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Supreme',
                      ),
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Scrollable Terms Section
                  Container(
                    height: 240, // slightly taller for extra text
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        AppText.landlordLoyaltyCreditProgramTerms.tr,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: Color(0xFF4B5563),
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: isAgreed,
                        onChanged: (value) {
                          setState(() {
                            isAgreed = value ?? false;
                          });
                        },
                        activeColor: const Color(0xFF10B981),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            AppText
                                .iHaveReadAndAgreeToTheLandlordLoyaltyCreditProgramTerms
                                .tr,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF374151),
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              actionsPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    AppText.cancel.tr,
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: isAgreed
                      ? () {
                          Navigator.pop(context);
                          controller.submitProperty(parentContext);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    side: BorderSide.none,
                    backgroundColor: const Color(0xFF10B981),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: Text(
                    AppText.publishProperty.tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Supreme',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

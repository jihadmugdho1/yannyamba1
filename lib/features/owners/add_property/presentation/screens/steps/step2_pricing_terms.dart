import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yannyamba/core/core.dart';
import '../../../controllers/add_property_controller.dart';
import '../../widgets/form_navigation_buttons.dart';

class Step2PricingTerms extends StatelessWidget {
  const Step2PricingTerms({super.key});

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
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Obx(() {
          final isFurnished = controller.listingType.value == 'furnished';
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isFurnished
                    ? AppText.pricingAndBooking.tr
                    : AppText.pricingAndTerms.tr,
                style: getTextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor,
                  font: AppFont.supreme,
                ),
              ),
              SizedBox(height: 4.h),
              const Divider(color: Color(0xFFE5E7EB), thickness: 1),
              SizedBox(height: 8.h),

              // Show furnished fields or normal fields
              if (isFurnished)
                ..._buildFurnishedFields(controller)
              else
                ..._buildNormalFields(controller),
            ],
          );
        }),
      ),
    );
  }

  List<Widget> _buildFurnishedFields(AddPropertyController controller) {
    return [
      // Daily Rate
      _buildTextField(
        label: AppText.dailyRate.tr,
        hint: ' ',
        keyboardType: TextInputType.number,
        textController: controller.dailyRateController,
        onChanged: (value) => controller.dailyRate.value = value,
      ),
      SizedBox(height: 12.h),

      // Minimum/Maximum Stay
      Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppText.minimumStay.tr,
                  style: getTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textColor,
                  ),
                ),
                SizedBox(height: 8.h),
                Obx(
                  () => _buildStayDropdown(
                    value: controller.minimumStay.value,
                    items: List.generate(30, (i) => i + 1),
                    onChanged: (val) => controller.minimumStay.value = val ?? 1,
                    suffix: AppText.nights.tr,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppText.maximumStay.tr,
                  style: getTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textColor,
                  ),
                ),
                SizedBox(height: 8.h),
                Obx(
                  () => _buildStayDropdown(
                    value: controller.maximumStay.value,
                    items: List.generate(90, (i) => i + 1),
                    onChanged: (val) =>
                        controller.maximumStay.value = val ?? 30,
                    suffix: AppText.nights.tr,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      SizedBox(height: 12.h),

      // Check-in/Check-out Times
      Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppText.checkInTime.tr,
                  style: getTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textColor,
                  ),
                ),
                SizedBox(height: 8.h),
                Obx(
                  () => _buildTimeDropdown(
                    value: controller.checkInTime.value,
                    onChanged: (val) =>
                        controller.checkInTime.value = val ?? '14:00',
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppText.checkOutTime.tr,
                  style: getTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textColor,
                  ),
                ),
                SizedBox(height: 8.h),
                Obx(
                  () => _buildTimeDropdown(
                    value: controller.checkOutTime.value,
                    onChanged: (val) =>
                        controller.checkOutTime.value = val ?? '11:00',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      SizedBox(height: 12.h),
      // Navigation Buttons
      FormNavigationButtons(
        onPrevious: controller.previousStep,
        onNext: () {
          if (controller.validateStep2()) {
            controller.nextStep();
          } else {
            ScaffoldMessenger.of(Get.context!).showSnackBar(
              SnackBar(
                content: Text(
                  AppText.pleaseCompleteThePricingAndBookingDetails.tr,
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
      ),
    ];
  }

  List<Widget> _buildNormalFields(AddPropertyController controller) {
    return [
      // Monthly Rent
      _buildTextField(
        label: AppText.monthlyRent.tr,
        hint: '\$1900',
        keyboardType: TextInputType.number,
        textController: controller.monthlyRentController,
        onChanged: (value) => controller.monthlyRent.value = value,
      ),
      SizedBox(height: 12.h),

      // Advance Months Dropdown (1 to 12)
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppText.advancePayment.tr,
            style: getTextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textColor,
            ),
          ),
          SizedBox(height: 8.h),
          Obx(
            () => Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButton<int>(
                value: controller.advanceMonths.value,
                underline: const SizedBox(),
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Color(0xFF9CA3AF),
                ),
                isExpanded: true,
                items: List.generate(12, (index) => index + 1)
                    .map(
                      (month) => DropdownMenuItem(
                        value: month,
                        child: Text(
                          '$month ${month == 1 ? AppText.month.tr : AppText.months.tr}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (val) => controller.advanceMonths.value = val ?? 1,
              ),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            AppText.numberOfMonthsToBePaidInAdvance.tr,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF9CA3AF),
              fontFamily: 'Montserrat',
            ),
          ),
        ],
      ),
      SizedBox(height: 12.h),

      // Security Months Dropdown (1 to 6)
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppText.securityDeposit.tr,
            style: getTextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textColor,
            ),
          ),
          SizedBox(height: 8.h),
          Obx(
            () => Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButton<int>(
                value: controller.securityMonths.value,
                underline: const SizedBox(),
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Color(0xFF9CA3AF),
                ),
                isExpanded: true,
                items: List.generate(6, (index) => index + 1)
                    .map(
                      (month) => DropdownMenuItem(
                        value: month,
                        child: Text(
                          '$month ${month == 1 ? AppText.month.tr : AppText.months.tr}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (val) => controller.securityMonths.value = val ?? 1,
              ),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            AppText.numberOfMonthsForRefundableSecurityDeposit.tr,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF9CA3AF),
              fontFamily: 'Montserrat',
            ),
          ),
        ],
      ),
      SizedBox(height: 12.h),

      // Pricing Tips
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFEFF6FF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppText.pricingTips.tr,
              style: getTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor,
              ),
            ),
            SizedBox(height: 8.h),
            _buildTipItem(AppText.researchComparablePropertiesInYourArea.tr),
            SizedBox(height: 8.h),
            _buildTipItem(
              AppText.considerIncludingUtilitiesInRentForConvenience.tr,
            ),
            SizedBox(height: 8.h),
            _buildTipItem(AppText.beCompetitiveButFairWithYourPricing.tr),
          ],
        ),
      ),
      SizedBox(height: 16.h),

      // Navigation Buttons
      FormNavigationButtons(
        onPrevious: controller.previousStep,
        onNext: () {
          if (controller.validateStep2()) {
            controller.nextStep();
          } else {
            ScaffoldMessenger.of(Get.context!).showSnackBar(
              SnackBar(
                content: Text(
                  AppText.pleaseCompleteThePricingAndTermsDetails.tr,
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
      ),
    ];
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    TextInputType? keyboardType,
    required TextEditingController textController,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: getTextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textColor,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: textController,
          onChanged: onChanged,
          keyboardType: keyboardType,
          inputFormatters: keyboardType == TextInputType.number
              ? [FilteringTextInputFormatter.digitsOnly]
              : null,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFF9CA3AF),
              fontFamily: 'Montserrat',
              fontSize: 14,
            ),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
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
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTipItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '• ',
          style: getTextStyle(
            fontSize: 12,
            color: const Color(0xFF193CB8),
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: getTextStyle(fontSize: 12, color: const Color(0xFF193CB8)),
          ),
        ),
      ],
    );
  }

  Widget _buildStayDropdown({
    required int value,
    required List<int> items,
    required Function(int?) onChanged,
    required String suffix,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButton<int>(
        value: value,
        underline: const SizedBox(),
        icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF9CA3AF)),
        isExpanded: true,
        items: items
            .map(
              (night) => DropdownMenuItem(
                value: night,
                child: Text(
                  '$night $suffix',
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildTimeDropdown({
    required String value,
    required Function(String?) onChanged,
  }) {
    final times = [
      '00:00',
      '01:00',
      '02:00',
      '03:00',
      '04:00',
      '05:00',
      '06:00',
      '07:00',
      '08:00',
      '09:00',
      '10:00',
      '11:00',
      '12:00',
      '13:00',
      '14:00',
      '15:00',
      '16:00',
      '17:00',
      '18:00',
      '19:00',
      '20:00',
      '21:00',
      '22:00',
      '23:00',
    ];

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButton<String>(
        value: value,
        underline: const SizedBox(),
        icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF9CA3AF)),
        isExpanded: true,
        items: times
            .map(
              (time) => DropdownMenuItem(
                value: time,
                child: Text(
                  time,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}

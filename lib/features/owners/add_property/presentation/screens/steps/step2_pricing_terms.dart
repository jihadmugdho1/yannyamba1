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
          final isLongTerm = controller.minimumStay.value >= 16;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppText.pricingAndBooking.tr,
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

              // Daily Rate
              _buildTextField(
                label: AppText.dailyRate.tr,
                hint: '80',
                keyboardType: TextInputType.number,
                textController: controller.dailyRateController,
                onChanged: (value) => controller.dailyRate.value = value,
              ),
              SizedBox(height: 16.h),

              // Min / Max Stay
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
                          () => _buildDaysDropdown(
                            value: controller.minimumStay.value,
                            items: List.generate(365, (i) => i + 1),
                            onChanged: (val) {
                              final newMin = val ?? 1;
                              controller.minimumStay.value = newMin;
                              // Ensure max >= min
                              if (controller.maximumStay.value < newMin) {
                                controller.maximumStay.value = newMin;
                              }
                            },
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
                          () => _buildDaysDropdown(
                            value: controller.maximumStay.value,
                            items: List.generate(365, (i) => i + 1),
                            onChanged: (val) =>
                                controller.maximumStay.value = val ?? 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                isLongTerm
                    ? 'Long-term rental (16+ days minimum)'
                    : 'Short-term rental (up to 15 days minimum)',
                style: TextStyle(
                  fontSize: 12,
                  color: isLongTerm
                      ? const Color(0xFF2196F3)
                      : const Color(0xFF9CA3AF),
                  fontFamily: 'Montserrat',
                ),
              ),
              SizedBox(height: 16.h),

              // Advance Payment & Security Deposit — long term only
              if (isLongTerm) ...[
                _buildMonthDropdown(
                  label: AppText.advancePayment.tr,
                  hint: AppText.numberOfMonthsToBePaidInAdvance.tr,
                  value: controller.advanceMonths.value,
                  itemCount: 12,
                  onChanged: (val) =>
                      controller.advanceMonths.value = val ?? 1,
                ),
                SizedBox(height: 16.h),
                _buildMonthDropdown(
                  label: AppText.securityDeposit.tr,
                  hint: AppText.numberOfMonthsForRefundableSecurityDeposit.tr,
                  value: controller.securityMonths.value,
                  itemCount: 6,
                  onChanged: (val) =>
                      controller.securityMonths.value = val ?? 1,
                ),
                SizedBox(height: 16.h),
              ],

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
            ],
          );
        }),
      ),
    );
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

  Widget _buildDaysDropdown({
    required int value,
    required List<int> items,
    required Function(int?) onChanged,
  }) {
    // Ensure value is within items range
    final safeValue = items.contains(value) ? value : items.first;
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButton<int>(
        value: safeValue,
        underline: const SizedBox(),
        icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF9CA3AF)),
        isExpanded: true,
        items: items
            .map(
              (d) => DropdownMenuItem(
                value: d,
                child: Text(
                  '$d ${d == 1 ? 'day' : 'days'}',
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

  Widget _buildMonthDropdown({
    required String label,
    required String hint,
    required int value,
    required int itemCount,
    required Function(int?) onChanged,
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
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButton<int>(
            value: value,
            underline: const SizedBox(),
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xFF9CA3AF),
            ),
            isExpanded: true,
            items: List.generate(itemCount, (i) => i + 1)
                .map(
                  (m) => DropdownMenuItem(
                    value: m,
                    child: Text(
                      '$m ${m == 1 ? AppText.month.tr : AppText.months.tr}',
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
        ),
        SizedBox(height: 6.h),
        Text(
          hint,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF9CA3AF),
            fontFamily: 'Montserrat',
          ),
        ),
      ],
    );
  }
}

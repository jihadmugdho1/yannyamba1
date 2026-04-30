import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:yannyamba/core/core.dart';

import '../../controllers/add_property_controller.dart';
import 'text_field_builder.dart';

class OwnerSection extends StatelessWidget {
  final AddPropertyController controller;
  const OwnerSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppText.propertyOwnerDetails.tr,
            style: getTextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor,
            ),
          ),
          SizedBox(height: 16.h),
          buildTextField(
            label: AppText.ownerName.tr,
            hint: AppText.enterYourFullName.tr,
            keyboardType: TextInputType.name,
            onChanged: (v) => controller.ownerName.value = v,
          ),
          const SizedBox(height: 16),
          _buildPhoneNumberField(controller),
        ],
      ),
    );
  }
}

Widget _buildPhoneNumberField(AddPropertyController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Text(
            AppText.ownerPhoneNumber.tr,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'Montserrat',
              color: Color(0xFF374151),
            ),
          ),
          SizedBox(width: 4),
          Text(
            '*',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFFEF4444),
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
        ),
        child: Row(
          children: [
            // Country code picker
            Flexible(
              flex: 0,
              child: Obx(
                () => CountryCodePicker(
                  onChanged: (countryCode) {
                    controller.updateOwnerCountryCode(countryCode);
                  },
                  initialSelection: controller.ownerCountryCode.value.code,
                  favorite: const ['+237'],
                  showCountryOnly: false,
                  showOnlyCountryWhenClosed: false,
                  alignLeft: false,
                  showFlag: true,
                  showFlagDialog: true,
                  flagWidth: 24.w,
                  padding: EdgeInsets.zero,
                  textStyle: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF374151),
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Montserrat',
                  ),
                  dialogTextStyle: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF374151),
                    fontFamily: 'Montserrat',
                  ),
                  searchStyle: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF374151),
                    fontFamily: 'Montserrat',
                  ),
                  // <-- Constrain the dialog size relative to screen
                  dialogSize: Size(
                    Get.width * 0.9, // max 90% of screen width
                    Get.height * 0.7, // max 70% of screen height
                  ),
                  barrierColor: Colors.black.withOpacity(0.5),
                ),
              ),
            ),

            // Divider
            Container(
              height: 24,
              width: 1,
              color: const Color(0xFFE5E7EB),
              margin: const EdgeInsets.symmetric(horizontal: 8),
            ),

            // Phone number input
            Expanded(
              child: TextField(
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                  color: Color(0xFF374151),
                ),
                decoration: const InputDecoration(
                  hintText: AppText.enterOwnerPhoneNumber,
                  hintStyle: TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                  ),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
                onChanged: (v) => controller.ownerNumber.value = v,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

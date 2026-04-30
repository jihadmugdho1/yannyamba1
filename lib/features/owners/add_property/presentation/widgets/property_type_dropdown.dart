import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yannyamba/core/core.dart';
import '../../controllers/add_property_controller.dart';

class PropertyTypeDropdown extends StatelessWidget {
  final AddPropertyController controller;
  const PropertyTypeDropdown({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    // Property categories
    final types = [
      _PropertyTypeOption(value: 'Home', label: AppText.homeTypeProperty.tr),
      _PropertyTypeOption(value: 'Office', label: AppText.officeTypeProperty.tr),
    ];

    return Obx(() {
      final selectedType = controller.propertyType.value;
      String? selectedValue;
      if (selectedType == 'Home' || selectedType == 'Office') {
        selectedValue = selectedType;
      } else if (selectedType == AppText.homeTypeProperty.tr) {
        selectedValue = 'Home';
      } else if (selectedType == AppText.officeTypeProperty.tr) {
        selectedValue = 'Office';
      }

      // Normalize any legacy localized values to canonical values.
      if (selectedValue != null && selectedValue != selectedType) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.propertyType.value = selectedValue!;
        });
      }

      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedValue == null || selectedValue.isEmpty
                ? null
                : selectedValue,
            hint: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Select property category',
                style: TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                ),
              ),
            ),
            isExpanded: true,
            icon: const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.keyboard_arrow_down, color: Color(0xFF6B7280)),
            ),
            items: types.map((option) {
              return DropdownMenuItem<String>(
                value: option.value,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    option.label,
                    style: const TextStyle(
                      color: Color(0xFF282828),
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }).toList(),
            onChanged: (String? value) {
              if (value != null) {
                controller.propertyType.value = value;
              }
            },
          ),
        ),
      );
    });
  }
}

class _PropertyTypeOption {
  final String value;
  final String label;
  const _PropertyTypeOption({required this.value, required this.label});
}

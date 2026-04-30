import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yannyamba/core/core.dart';
import '../../controllers/add_property_controller.dart';

class BedBathDropdowns extends StatelessWidget {
  final AddPropertyController controller;
  const BedBathDropdowns({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildDropdownColumn('Bedrooms', controller.bedrooms)),
        const SizedBox(width: 16),
        Expanded(
          child: _buildDropdownColumn('Bathrooms', controller.bathrooms),
        ),
      ],
    );
  }

  Widget _buildDropdownColumn(String label, RxInt value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: getTextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor,
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () => Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: value.value,
                isExpanded: true,
                icon: const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: Color(0xFF6B7280),
                  ),
                ),
                items: List.generate(10, (index) => index + 1).map((int val) {
                  return DropdownMenuItem<int>(
                    value: val,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        val.toString(),
                        style: const TextStyle(
                          color: Color(0xFF282828),
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (int? newVal) {
                  if (newVal != null) value.value = newVal;
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

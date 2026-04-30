import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yannyamba/core/core.dart';
import '../../controllers/add_property_controller.dart';

class OfficeDropdowns extends StatelessWidget {
  final AddPropertyController controller;
  const OfficeDropdowns({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildDropdownColumn(
                'Office Rooms',
                controller.officeRooms,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDropdownColumn(
                'Conference Rooms',
                controller.conferenceRooms,
                startFrom: 0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildDropdownColumn(
          'Workstations',
          controller.workstations,
          maxValue: 50,
        ),
      ],
    );
  }

  Widget _buildDropdownColumn(
    String label,
    RxInt value, {
    int startFrom = 1,
    int maxValue = 10,
  }) {
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
                items:
                    List.generate(
                      maxValue - startFrom + 1,
                      (index) => index + startFrom,
                    ).map((int val) {
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

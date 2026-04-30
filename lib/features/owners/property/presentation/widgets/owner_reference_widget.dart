import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yannyamba/core/models/property/property_models.dart';
import 'package:yannyamba/core/core.dart';

class OwnerReferenceWidget extends StatelessWidget {
  final Apartment apartment;

  const OwnerReferenceWidget({super.key, required this.apartment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppText.referenceContacts.tr,
            style: getTextStyle(
              fontSize: 18,
              font: AppFont.montserrat,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor,
            ),
          ),
          const SizedBox(height: 12),
          ...apartment.referenceContacts.map(
            (c) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          c.name,
                          style: getTextStyle(
                            fontSize: 14,
                            font: AppFont.montserrat,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor,
                          ),
                        ),
                        Text(
                          c.relationshipLabel,
                          style: getTextStyle(
                            fontSize: 12,
                            font: AppFont.montserrat,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textColor2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.phone, size: 18, color: AppColors.textPrimary),
                      const SizedBox(width: 6),
                      Text(
                        c.phone,
                        style: getTextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

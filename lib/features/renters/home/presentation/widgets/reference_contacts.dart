import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yannyamba/core/models/property/property_models.dart';
import 'package:yannyamba/core/core.dart';

class ReferenceContacts extends StatelessWidget {
  final Apartment apartment;

  const ReferenceContacts({super.key, required this.apartment});

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
                  GestureDetector(
                    onTap: () {
                      OwnerContactService.contactOwner(
                        context,
                        apartment,
                        c.name,
                        c.phone,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueAccent.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.contact_phone,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
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

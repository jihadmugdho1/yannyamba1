import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yannyamba/core/core.dart';
import 'package:yannyamba/core/models/property/property_models.dart';

class OwnerContact extends StatelessWidget {
  final Apartment apartment;

  const OwnerContact({super.key, required this.apartment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.grey[300],
                child: Image.asset(ImagePath.profileAvatar),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            apartment.mainContact?.name ??
                                AppText.contactName.tr,
                            style: getTextStyle(
                              fontSize: 18,
                              font: AppFont.supreme,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textColor,
                            ),
                          ),
                        ),
                        if (apartment.mainContact?.isVerified ?? false) ...[
                          const SizedBox(width: 8),
                          Image.asset(
                            ImagePath.verifiedIcon,
                            width: 24,
                            height: 24,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ],
                    ),
                    Text(
                      apartment.mainContact?.relationshipLabel ??
                          AppText.primaryContact.tr,
                      style: getTextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => OwnerContactService.contactOwner(
                context,
                apartment,
                apartment.owner!.name,
                apartment.owner!.phone,
              ),
              icon: const Icon(
                Icons.contact_phone,
                size: 20,
                color: Colors.white,
              ),
              label: Text(
                AppText.contactOwner.tr,
                style: getTextStyle(
                  fontSize: 14,
                  font: AppFont.montserrat,
                  color: AppColors.textWhite,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(44),
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: AppColors.primaryBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

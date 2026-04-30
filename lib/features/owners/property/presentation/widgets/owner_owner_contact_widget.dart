import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yannyamba/core/core.dart';
import 'package:yannyamba/core/models/property/property_models.dart';

class OwnerOwnerContactWidget extends StatelessWidget {
  final Apartment apartment;

  const OwnerOwnerContactWidget({super.key, required this.apartment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black.withOpacity(.2), width: 1.2),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.grey[200],
                child: ClipOval(
                  child: Image.asset(
                    ImagePath.profileAvatar,
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            apartment.mainContact?.name ??
                                AppText.contactName.tr,
                            overflow: TextOverflow.ellipsis,
                            style: getTextStyle(
                              fontSize: 18,
                              font: AppFont.supreme,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textColor,
                            ),
                          ),
                        ),
                        if (apartment.mainContact?.phone != null &&
                            apartment.mainContact!.phone.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.phone,
                                  size: 18,
                                  color: AppColors.textPrimary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  apartment.mainContact!.phone,
                                  style: getTextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      apartment.mainContact?.relationshipLabel ??
                          AppText.primaryContact.tr,
                      style: getTextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

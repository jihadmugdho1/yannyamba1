import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:yannyamba/core/core.dart';
import 'package:yannyamba/features/common/profile/data/models/profile_model.dart';

/// Widget displaying the owner's profile card with avatar, name, and verify button
class ProfileHeaderCard extends StatelessWidget {
  final Profile profile;
  final VoidCallback? onVerifyPressed;
  final bool isLoading;
  final bool isVerified;

  const ProfileHeaderCard({
    super.key,
    required this.profile,
    this.onVerifyPressed,
    this.isLoading = false,
    this.isVerified = false,
  });

  @override
  Widget build(BuildContext context) {
    // final String? imagePath = profile.imageUrl;

    final String imagePath = profile.imageUrl.isEmpty
        ? ImagePath.profileAvatar
        : profile.imageUrl;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Avatar
          Stack(
            children: [
              CircleAvatar(
                radius: 26.r,
                backgroundColor: Colors.grey[300],
                backgroundImage: (imagePath.isNotEmpty)
                    ? (imagePath.startsWith('http')
                          ? NetworkImage(imagePath)
                          : imagePath.startsWith('assets/')
                          ? AssetImage(imagePath)
                          : FileImage(File(imagePath)) as ImageProvider)
                    : null,
                child: (imagePath.isEmpty)
                    ? Text(
                        profile.name.isNotEmpty ? profile.name[0] : 'O',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    : null,
              ),

              if (isVerified)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.verified,
                      color: Color(0xFF4CAF50),
                      size: 16,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Profile Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name.isEmpty
                      ? AppText.pleaseEnterYourName.tr
                      : profile.name,
                  style: getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppText.propertyOwner.tr,
                  style: getTextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textColor2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

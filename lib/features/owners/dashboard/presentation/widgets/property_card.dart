import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yannyamba/core/core.dart';

class PropertyCard extends StatelessWidget {
  final String imageUrl;
  final String price;
  final bool isNormal;
  final int views;
  final int inquiries;
  final String title;
  final String address;
  final String advancePayment;
  final String distance;
  final VoidCallback? onViewDetails;
  final VoidCallback? onDelete;
  final VoidCallback? onShare;

  const PropertyCard({
    super.key,
    required this.imageUrl,
    required this.price,
    this.isNormal = true,
    required this.views,
    required this.inquiries,
    required this.title,
    required this.address,
    required this.advancePayment,
    required this.distance,
    this.onViewDetails,
    this.onDelete,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildPropertyImage(), _buildPropertyDetails()],
      ),
    );
  }

  Widget _buildPropertyImage() {
    final isNetworkImage =
        imageUrl.startsWith('http://') || imageUrl.startsWith('https://');
    final isAssetImage = imageUrl.startsWith('assets/');

    ImageProvider imageProvider;
    if (isNetworkImage) {
      imageProvider = NetworkImage(imageUrl);
    } else if (isAssetImage) {
      imageProvider = AssetImage(imageUrl);
    } else {
      imageProvider = FileImage(File(imageUrl));
    }

    return Stack(
      children: [
        Container(
          height: 220,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        ),
        _buildGradientOverlay(),
      ],
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 53,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black.withValues(alpha: 0), Colors.black],
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                price,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.2,
                  letterSpacing: -0.48,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Icon(Iconsax.eye, size: 16, color: Colors.white),
                  const SizedBox(width: 6),
                  Text(
                    views.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Iconsax.message, size: 16, color: Colors.white),
                  const SizedBox(width: 6),
                  Text(
                    inquiries.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyDetails() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: getTextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor,
            ),
          ),
          const SizedBox(height: 4),

          Text(
            address,
            style: getTextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textColor2,
            ),
          ),
          const SizedBox(height: 8),

          if (isNormal)
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Advance',
                    style: getTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor,
                    ),
                  ),
                  TextSpan(
                    text: ' - $advancePayment',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textColor,
                    ),
                  ),
                ],
              ),
            ),

          if (isNormal) const SizedBox(height: 8),

          if (distance.isNotEmpty)
            Text(
              distance,
              style: getTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textColor,
              ),
            ),
          if (distance.isNotEmpty) const SizedBox(height: 16),

          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            icon: Iconsax.eye,
            label: AppText.viewDetails.tr,
            color: AppColors.textColor,
            onTap: onViewDetails ?? () {},
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildActionButton(
            icon: Iconsax.trash,
            label: AppText.delete.tr,
            color: Colors.red,
            onTap: onDelete ?? () {},
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFE5E7EB).withValues(alpha: .4),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: getTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:yannyamba/core/core.dart';

/// Reusable app bar for owner dashboard pages
class OwnerAppBar extends StatelessWidget {
  final String userName;
  final bool isVerified;
  final String? profileImageUrl;

  const OwnerAppBar({
    super.key,
    required this.userName,
    this.isVerified = false,
    this.profileImageUrl,
  });

  @override
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
          ),
        ),
        child: Row(
          children: [
            _buildProfilePicture(),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _getGreeting(),
                style: getTextStyle(
                  fontSize: 18,
                  font: AppFont.supreme,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isVerified) ...[
              const SizedBox(width: 8),
              _buildVerifiedBadge(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePicture() {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.white, width: 1),
        image: DecorationImage(
          image: AssetImage(ImagePath.profileAvatar),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildVerifiedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF2196F3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            ImagePath.verifiedIcon,
            width: 16,
            height: 16,
            color: Colors.white,
          ),
          const SizedBox(width: 4),
          const Text(
            'Verified',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }
}

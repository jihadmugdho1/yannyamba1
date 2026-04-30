import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../../core/core.dart';

class ApartmentCardShimmer extends StatelessWidget {
  const ApartmentCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.textWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: .1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section Shimmer
          _buildImageShimmer(),

          // Content Section Shimmer
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Shimmer
                _buildShimmerBox(width: double.infinity, height: 16),
                const SizedBox(height: 8),

                // Address Shimmer
                _buildShimmerBox(width: 200, height: 12),
                const SizedBox(height: 8),

                const Divider(color: Color(0xFFE5E5E5), thickness: 1),
                const SizedBox(height: 4),

                // Price Row Shimmer
                Row(
                  children: [
                    _buildShimmerBox(width: 80, height: 20),
                    const Spacer(),
                    _buildShimmerBox(width: 120, height: 14),
                  ],
                ),
                const SizedBox(height: 4),

                const Divider(color: Color(0xFFE5E5E5), thickness: 1),
                const SizedBox(height: 4),

                // Property Details Row Shimmer
                Row(
                  children: [
                    _buildShimmerBox(width: 90, height: 14),
                    const Spacer(),
                    _buildShimmerBox(width: 80, height: 14),
                  ],
                ),
                const SizedBox(height: 8),

                const Divider(color: Color(0xFFE5E5E5), thickness: 1),
                const SizedBox(height: 4),

                // Contact Owner Button Shimmer
                _buildShimmerBox(
                  width: double.infinity,
                  height: 44,
                  borderRadius: 8,
                ),
                const SizedBox(height: 12),

                // View Details Button Shimmer
                _buildShimmerBox(
                  width: double.infinity,
                  height: 46,
                  borderRadius: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 150.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildShimmerBox({
    required double width,
    required double height,
    double borderRadius = 4,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

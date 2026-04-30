import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../../core/core.dart';

class FurnishedApartmentCardShimmer extends StatelessWidget {
  const FurnishedApartmentCardShimmer({super.key});

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
                _buildShimmerBox(width: 220, height: 12),
                const SizedBox(height: 8),

                const Divider(color: Color(0xFFE5E5E5), thickness: 1),
                const SizedBox(height: 4),

                // Price Row Shimmer (Daily Rate + Min Stay)
                Row(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildShimmerBox(width: 60, height: 20),
                        const SizedBox(width: 4),
                        _buildShimmerBox(width: 50, height: 12),
                      ],
                    ),
                    const Spacer(),
                    _buildShimmerBox(width: 80, height: 12),
                  ],
                ),
                const SizedBox(height: 4),

                const Divider(color: Color(0xFFE5E5E5), thickness: 1),
                const SizedBox(height: 4),

                // Property Details Row Shimmer (Rooms + Size)
                Row(
                  children: [
                    _buildShimmerBox(width: 80, height: 14),
                    const Spacer(),
                    _buildShimmerBox(width: 90, height: 14),
                  ],
                ),
              ],
            ),
          ),

          // Contact Owner Button Shimmer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildShimmerBox(
              width: double.infinity,
              height: 44,
              borderRadius: 8,
            ),
          ),

          // View Details Button Shimmer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _buildShimmerBox(
              width: double.infinity,
              height: 46,
              borderRadius: 8,
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
        height: 200,
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

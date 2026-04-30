import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PropertyCardShimmer extends StatelessWidget {
  final bool isNormal;

  const PropertyCardShimmer({super.key, this.isNormal = true});

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
        children: [_buildImageShimmer(), _buildDetailsShimmer()],
      ),
    );
  }

  Widget _buildImageShimmer() {
    return Stack(
      children: [
        // Main image placeholder
        Shimmer.fromColors(
          baseColor: const Color(0xFFE5E7EB),
          highlightColor: const Color(0xFFF5F5F5),
          child: Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
          ),
        ),
        // Gradient overlay with shimmer elements
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 53,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.grey.withValues(alpha: 0), Colors.grey],
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Price shimmer
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Shimmer.fromColors(
                    baseColor: Colors.white.withValues(alpha: 0.3),
                    highlightColor: Colors.white.withValues(alpha: 0.6),
                    child: Container(
                      height: 29, // Matches font size 24 + line height
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                // Stats shimmer
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Shimmer.fromColors(
                    baseColor: Colors.white.withValues(alpha: 0.3),
                    highlightColor: Colors.white.withValues(alpha: 0.6),
                    child: Row(
                      children: [
                        Container(
                          height: 16,
                          width: 16,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          height: 20,
                          width: 30,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          height: 16,
                          width: 16,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          height: 20,
                          width: 30,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsShimmer() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Shimmer.fromColors(
        baseColor: const Color(0xFFE5E7EB),
        highlightColor: const Color(0xFFF5F5F5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title shimmer
            Container(
              height: 19, // Matches font size 16 + line height
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 4),

            // Address shimmer
            Container(
              height: 15, // Matches font size 12 + line height
              width: 200,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 8),

            // Advance payment shimmer (only for normal apartments)
            if (isNormal) ...[
              Container(
                height: 17, // Matches font size 14 + line height
                width: 180,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 8),
            ],

            // Distance shimmer
            Container(
              height: 17, // Matches font size 14 + line height
              width: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 16),

            // Action buttons shimmer
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40, // Matches button height (padding + icon + text)
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

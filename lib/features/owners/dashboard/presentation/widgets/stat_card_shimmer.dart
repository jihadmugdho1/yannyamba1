import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class StatCardShimmer extends StatelessWidget {
  const StatCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Shimmer.fromColors(
          baseColor: const Color(0xFFE5E7EB),
          highlightColor: const Color(0xFFF5F5F5),
          child: Column(
            children: [
              // Icon shimmer
              Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(height: 8),
              // Value shimmer
              Container(
                height: 22, // Matches font size 18 + line height
                width: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 8),
              // Label shimmer
              Container(
                height: 15, // Matches font size 12 + line height
                width: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

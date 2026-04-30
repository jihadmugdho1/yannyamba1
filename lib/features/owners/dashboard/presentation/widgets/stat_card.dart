import 'package:flutter/material.dart';
import 'package:yannyamba/core/common/styles/global_text_style.dart';

/// Reusable stat card widget for dashboard
class StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const StatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
  });

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
        child: Column(
          children: [
            Icon(icon, size: 24, color: Colors.black),
            const SizedBox(height: 8),
            Text(
              value,
              style: getTextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                font: AppFont.supreme,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: getTextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

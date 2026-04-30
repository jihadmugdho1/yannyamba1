import 'package:flutter/material.dart';
import 'package:yannyamba/core/core.dart';

/// Reusable section header widget
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onActionTap;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: getTextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            font: AppFont.supreme,
            color: Color(0xFF211F1F),
          ),
        ),
        if (actionText != null)
          GestureDetector(
            onTap: onActionTap,
            child: Text(
              actionText!,
              style: getTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF211F1F),
              ),
            ),
          ),
      ],
    );
  }
}

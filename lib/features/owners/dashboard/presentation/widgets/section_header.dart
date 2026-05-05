import 'package:flutter/material.dart';
import 'package:yannyamba/core/core.dart';

/// Reusable section header widget
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onActionTap;
  final VoidCallback? onFilterTap;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onActionTap,
    this.onFilterTap,
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
        Row(
          children: [
            if (onFilterTap != null)
              IconButton(
                onPressed: onFilterTap,
                icon: const Icon(Icons.filter_list, size: 20),
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
        )
      ],
    );
  }
}

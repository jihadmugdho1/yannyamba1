import 'package:flutter/material.dart';
import 'package:yannyamba/core/core.dart';

class MenuItemWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const MenuItemWidget({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Colors.grey[600]),
            const SizedBox(width: 16),
            Text(
              title,
              style: getTextStyle(
                fontSize: 18,
                font: AppFont.supreme,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

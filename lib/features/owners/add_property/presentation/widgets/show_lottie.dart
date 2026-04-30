import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

void showSuccessLottie(BuildContext context) {
  Get.dialog(
    Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/animation/Success.json',
              width: 150,
              height: 150,
              repeat: false,
            ),
            const SizedBox(height: 16),
            const Text(
              'Property Published!',
              style: TextStyle(
                color: Color(0xFF10B981),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your property has been successfully published',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF6B7280), fontSize: 14),
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: true,
  );

  // Auto-close after 3 seconds
  Future.delayed(const Duration(seconds: 3), () {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yannyamba/core/core.dart';
import 'package:yannyamba/features/renters/AI/presentation/screens/chat_page_screen.dart';

class AiOnboardingScreen extends StatelessWidget {
  const AiOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: CustomAppBar(
        title: AppText.aiAssistant.tr,
        showBackButton: false,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black, width: 0.3),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 140.h,
                    height: 140.h,
                    child: Image.asset(ImagePath.aiIcon, fit: BoxFit.cover),
                  ),
                  SizedBox(height: 32.h),
                  Text(
                    AppText.yourAiAssistant.tr,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    AppText.aiAssistantDescription.tr,
                    textAlign: TextAlign.center,
                    style: getTextStyle(
                      fontSize: 14,
                      color: AppColors.textColor2,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  SizedBox(
                    width: double.infinity,
                    // height: 48.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        Get.to(() => const ChatPage());
                      },
                      child: Text(
                        AppText.startYourJourney.tr,
                        style: getTextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

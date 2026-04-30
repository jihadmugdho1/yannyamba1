import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yannyamba/core/core.dart';

import '../../controllers/authentication_controller.dart';

class AuthenticationVerificationScreen
    extends GetView<AuthenticationController> {
  const AuthenticationVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(ImagePath.loginBg, fit: BoxFit.cover),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white, size: 22.sp),
                onPressed: () {
                  controller.resetFlow();
                  Get.back();
                },
              ),
            ),
          ),
          // Bottom sheet content
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Container(
                  margin: EdgeInsets.only(
                    left: 16.w,
                    right: 16.w,
                    bottom: MediaQuery.of(context).viewInsets.bottom > 0
                        ? 12.h
                        : 20.h,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 24.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .1),
                        blurRadius: 20,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Obx(() {
                    final isLoading = controller.isProcessing.value;
                    final errorMessage = controller.errorMessage.value;

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppText.verificationCode.tr,
                          style: getTextStyle(
                            fontSize: 16,
                            font: AppFont.supreme,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          AppText.enterCodeSentToYourPhoneNumber.tr,
                          style: getTextStyle(
                            fontSize: 12,
                            color: AppColors.textColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 20.h),

                        _buildOTPFields(controller),
                        if (errorMessage.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(top: 12.h),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: .08),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Text(
                                errorMessage,
                                style: getTextStyle(
                                  fontSize: 12,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        SizedBox(height: 8.h),
                        SizedBox(
                          width: double.infinity,
                          height: 50.h,
                          child: ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () async {
                                    final isLogin =
                                        controller.currentMode.value ==
                                        AuthMode.login;
                                    if (isLogin) {
                                      await controller.verifyLoginOTP();
                                    } else {
                                      await controller.verifyCodeAndRegister();
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4169E1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              elevation: 0,
                            ),
                            child: isLoading
                                ? SizedBox(
                                    width: 20.w,
                                    // height: 20.w,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    AppText.verify.tr,
                                    style: getTextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),

                        Center(
                          child: TextButton(
                            onPressed: isLoading
                                ? null
                                : () async {
                                    final isLogin =
                                        controller.currentMode.value ==
                                        AuthMode.login;
                                    if (isLogin) {
                                      await controller.resendLoginOTP();
                                    } else {
                                      await controller.resendRegisterOTP();
                                    }
                                  },
                            child: Text(
                              AppText.resendCode.tr,
                              style: getTextStyle(
                                fontSize: 14,
                                color: const Color(0xFF4169E1),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOTPFields(AuthenticationController controller) {
    final List<TextEditingController> otpControllers = List.generate(
      6,
      (index) => TextEditingController(),
    );
    final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());

    // preload if code exists
    if (controller.codeController.text.isNotEmpty) {
      final code = controller.codeController.text;
      for (int i = 0; i < code.length && i < 6; i++) {
        otpControllers[i].text = code[i];
      }
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const ClampingScrollPhysics(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(6, (index) {
          return Container(
            margin: EdgeInsets.only(right: index < 5 ? 6.w : 0),
            child: SizedBox(
              width: 48.w,
              height: 48.h,
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: otpControllers[index],
                builder: (context, value, _) {
                  final isFilled = value.text.isNotEmpty;

                  return TextField(
                    controller: otpControllers[index],
                    focusNode: focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    style: getTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      contentPadding: EdgeInsets.zero,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: isFilled
                              ? const Color(0xFF4169E1) // blue when filled
                              : Colors.grey.shade300, // grey when empty
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: const BorderSide(
                          color: Color(0xFF4169E1),
                          width: 2,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        if (index < 5) {
                          focusNodes[index + 1].requestFocus();
                        } else {
                          focusNodes[index].unfocus();
                        }
                      } else if (value.isEmpty && index > 0) {
                        focusNodes[index - 1].requestFocus();
                      }

                      // update controller.codeController
                      String fullCode = '';
                      for (var ctrl in otpControllers) {
                        fullCode += ctrl.text;
                      }
                      controller.codeController.text = fullCode;
                    },
                  );
                },
              ),
            ),
          );
        }),
      ),
    );
  }
}

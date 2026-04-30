import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:yannyamba/core/core.dart';

import '../../controllers/authentication_controller.dart';
import '../screens/verification_screen.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key, this.initialMode = AuthMode.login});

  final AuthMode initialMode;

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  late final AuthenticationController controller =
      Get.find<AuthenticationController>();

  @override
  void initState() {
    super.initState();
    if (controller.currentMode.value != widget.initialMode) {
      controller.currentMode.value = widget.initialMode;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final additionalPadding = bottomPadding > 0 ? 20.h : 40.h;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImagePath.loginBg),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: .1),
                ],
              ),
            ),
          ),

          // Back button
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () {
                    controller.resetFlow(clearPhone: true);
                    Get.back();
                  },
                  child: SizedBox(
                    width: 40.w,
                    height: 40.w,
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 22.sp,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Bottom form container
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                12.w,
                20.w,
                12.w,
                bottomPadding + additionalPadding,
              ),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: Obx(() {
                    final isLoading = controller.isProcessing.value;
                    final errorMessage = controller.errorMessage.value;
                    final isLogin =
                        controller.currentMode.value == AuthMode.login;

                    return Padding(
                      padding: EdgeInsets.all(24.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppText.phoneNumber.tr,
                            style: getTextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textColor,
                            ),
                          ),
                          SizedBox(height: 4.h),

                          // Phone input with country code picker
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: AppColors.textColor2.withValues(
                                  alpha: .3,
                                ),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                // Country code picker
                                Obx(
                                  () => CountryCodePicker(
                                    onChanged: (countryCode) {
                                      controller.updateCountryCode(countryCode);
                                    },
                                    initialSelection: controller
                                        .selectedCountryCode
                                        .value
                                        .code,
                                    favorite: const ['+237'],
                                    showCountryOnly: false,
                                    showOnlyCountryWhenClosed: false,
                                    alignLeft: false,
                                    showFlag: true,
                                    showFlagDialog: true,
                                    flagWidth: 24.w,
                                    padding: EdgeInsets.zero,
                                    // <-- constrain dialog size
                                    dialogSize: Size(
                                      MediaQuery.of(context).size.width *
                                          0.9, // max 90% width
                                      MediaQuery.of(context).size.height * 0.7,
                                    ),
                                    barrierColor: Colors.black.withOpacity(0.5),
                                    textStyle: getTextStyle(
                                      fontSize: 14,
                                      color: AppColors.textColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    dialogTextStyle: getTextStyle(
                                      fontSize: 14,
                                      color: AppColors.textColor,
                                    ),
                                    searchStyle: getTextStyle(
                                      fontSize: 14,
                                      color: AppColors.textColor,
                                    ),
                                    searchDecoration: InputDecoration(
                                      hintText: Get.locale?.languageCode == 'fr'
                                          ? 'Rechercher un pays'
                                          : 'Search country',
                                      hintStyle: getTextStyle(
                                        fontSize: 14,
                                        color: AppColors.textColor2,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                        borderSide: BorderSide(
                                          color: AppColors.textColor2
                                              .withOpacity(0.3),
                                        ),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12.w,
                                        vertical: 8.h,
                                      ),
                                    ),
                                  ),
                                ),

                                // Divider
                                Container(
                                  height: 24.h,
                                  width: 1,
                                  color: AppColors.textColor2.withValues(
                                    alpha: 0.3,
                                  ),
                                  margin: EdgeInsets.symmetric(horizontal: 8.w),
                                ),

                                // Phone number input
                                Expanded(
                                  child: TextField(
                                    controller: controller.phoneController,
                                    keyboardType: TextInputType.phone,
                                    style: getTextStyle(
                                      fontSize: 14,
                                      color: AppColors.textColor,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Phone number',
                                      hintStyle: getTextStyle(
                                        fontSize: 14,
                                        color: AppColors.textColor2,
                                      ),
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 14.h,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          if (errorMessage.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(top: 10.h),
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

                          SizedBox(height: 16.h),

                          // Action button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () async {
                                      if (isLogin) {
                                        final sent = await controller.login();
                                        if (sent) {
                                          controller.codeController.clear();
                                          Get.to(
                                            () =>
                                                const AuthenticationVerificationScreen(),
                                          );
                                        }
                                      } else {
                                        final sent = await controller
                                            .sendVerificationCode();
                                        if (sent) {
                                          controller.codeController.clear();
                                          Get.to(
                                            () =>
                                                const AuthenticationVerificationScreen(),
                                          );
                                        }
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryBlue,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                disabledBackgroundColor: AppColors.primaryBlue
                                    .withValues(alpha: .6),
                              ),
                              child: isLoading
                                  ? SizedBox(
                                      width: 22.w,
                                      height: 22.w,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      isLogin
                                          ? AppText.logIn.tr
                                          : AppText.createAccount.tr,
                                      style: getTextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),

                          SizedBox(height: 16.h),

                          // Bottom link
                          Center(
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 4.w,
                              children: [
                                Text(
                                  isLogin
                                      ? AppText.dontHaveAnAccount.tr
                                      : AppText.alreadyHaveAnAccount.tr,
                                  style: getTextStyle(
                                    fontSize: 14,
                                    color: AppColors.textColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: isLoading
                                      ? null
                                      : () {
                                          if (isLogin) {
                                            controller.switchToRegister(
                                              clearPhone: true,
                                            );
                                          } else {
                                            controller.switchToLogin(
                                              clearPhone: false,
                                            );
                                          }
                                        },
                                  child: Text(
                                    isLogin
                                        ? AppText.signUp.tr
                                        : AppText.signIn.tr,
                                    style: getTextStyle(
                                      fontSize: 14,
                                      color: AppColors.textColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
}

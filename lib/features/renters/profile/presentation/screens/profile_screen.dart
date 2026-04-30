import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yannyamba/core/core.dart';
import 'package:yannyamba/features/renters/authentication/controllers/authentication_controller.dart';
import 'package:yannyamba/features/renters/authentication/presentation/screens/login_screen.dart';
import 'package:yannyamba/features/renters/authentication/presentation/screens/register_screen.dart';
import 'package:yannyamba/features/common/profile/controllers/profile_controller.dart';

import '../widgets/profile_image_widget.dart';
import '../widgets/profile_info_widget.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final ProfileController controller = Get.find<ProfileController>();
  final AuthenticationController authenticationController =
      Get.find<AuthenticationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        showProfile: false,
        title: AppText.profile.tr,
        showBackButton: false,
        showSearch: false,
        showFilter: false,
        centerTitle: true,
      ),
      body: Obx(() {
        if (!authenticationController.isLoggedIn.value) {
          return Center(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      context.height -
                      (Scaffold.of(context).appBarMaxHeight ?? 0),
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        AppText.logInToGetAccess.tr,
                        textAlign: TextAlign.center,
                        style: getTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor,
                        ),
                      ),
                      SizedBox(height: 32.h),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            authenticationController.switchToLogin(
                              clearPhone: true,
                            );
                            Get.to(() => const AuthenticationLoginScreen());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            AppText.logIn.tr,
                            style: getTextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Column(
                        children: [
                          Text(
                            AppText.haventAccountAlready.tr,
                            style: getTextStyle(
                              fontSize: 14,
                              color: AppColors.textColor2,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          GestureDetector(
                            onTap: () {
                              authenticationController.switchToRegister(
                                clearPhone: true,
                              );
                              Get.to(
                                () => const AuthenticationRegisterScreen(),
                              );
                            },
                            child: Text(
                              AppText.createAnAccount.tr,
                              style: getTextStyle(
                                fontSize: 14,
                                color: AppColors.textColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppText.unableToLoadProfile.tr,
                  style: getTextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor,
                  ),
                ),
                SizedBox(height: 8.h),
                ElevatedButton(
                  onPressed: controller.fetchProfile,
                  child: Text(AppText.retry.tr),
                ),
              ],
            ),
          );
        }

        final profile = controller.profile.value;
        if (profile == null) {
          return Center(child: Text(AppText.noProfileInfoAvailable.tr));
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProfileImageCard(
                imageUrl: profile.imageUrl,
                imageFile: controller.selectedImage.value,
                isEditing: controller.isEditing.value,
                onChangeImage: controller.showImageSourcePicker,
              ),
              SizedBox(height: 16.h),
              ProfileInfoCard(
                profile: profile,
                isEditing: controller.isEditing.value,
                isSaving: controller.isSaving.value,
                nameController: controller.nameController,
                phoneController: controller.phoneController,
                emailController: controller.emailController,
                onEdit: controller.enterEditMode,
                onCancel: controller.cancelEdit,
                onSave: controller.saveProfile,
              ),
              SizedBox(height: 32.h),
            ],
          ),
        );
      }),
    );
  }
}

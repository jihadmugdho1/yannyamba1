import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yannyamba/core/core.dart';
import 'package:yannyamba/features/common/navigation/navigation_helper.dart';
import 'package:yannyamba/features/common/profile/controllers/profile_controller.dart';
import 'package:yannyamba/features/owners/profile/presentation/widgets/contact_information_card.dart';
import 'package:yannyamba/features/owners/profile/presentation/widgets/profile_header_card.dart';

class OwnerProfileScreen extends StatelessWidget {
  const OwnerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use the common profile controller
    final controller = Get.find<ProfileController>();

    // Local state for notification settings

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          AppText.ownerProfile.tr,
          style: getTextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor,
            font: AppFont.supreme,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        // Show loading state
        if (controller.isLoading.value && controller.profile.value == null) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF4CAF50)),
          );
        }

        // Show error state
        if (controller.errorMessage.value.isNotEmpty &&
            controller.profile.value == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  AppText.failedToLoadProfile.tr,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontFamily: 'Supreme',
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.fetchProfile(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    AppText.retry.tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Supreme',
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // Show profile content
        final profile = controller.profile.value;
        if (profile == null) {
          return Center(child: Text(AppText.noProfileDataAvailable.tr));
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchProfile(),
          color: const Color(0xFF4CAF50),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: 16.h),

                // 🔸 Switch to renter dashboard button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () =>
                          NavigationHelper.navigateToRenterDashboard(
                            tabIndex: 0,
                          ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        AppText.switchToRenterDashboard.tr,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontFamily: 'Supreme',
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 16.h),

                // 🔸 Profile Header Card
                ProfileHeaderCard(
                  profile: profile,
                  onVerifyPressed: () {
                    Get.snackbar(
                      'Verification',
                      'Verification request will be implemented soon',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  isLoading: false,
                  isVerified: false,
                ),

                SizedBox(height: 16.h),

                ContactInformationCard(
                  profile: profile,
                  onEditPressed: () {
                    _showEditContactDialog(context, controller);
                  },
                ),

                // SizedBox(height: 16.h),

                // NotificationSettingsCard(
                //   viewingRequestsEnabled: viewingRequestsEnabled.value,
                //   propertyUpdatesEnabled: propertyUpdatesEnabled.value,
                //   onViewingRequestsChanged: (value) =>
                //       viewingRequestsEnabled.value = value,
                //   onPropertyUpdatesChanged: (value) =>
                //       propertyUpdatesEnabled.value = value,
                // ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        );
      }),
    );
  }

  /// Show edit contact dialog
  void _showEditContactDialog(
    BuildContext context,
    ProfileController controller,
  ) {
    final emailController = TextEditingController(
      text: controller.profile.value?.email ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        title: Text(
          AppText.editContactInformation.tr,
          style: TextStyle(fontFamily: 'Supreme', fontSize: 14.sp),
        ),
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
            maxWidth: MediaQuery.of(context).size.width * 0.9,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Phone Number (Read-only)
                TextField(
                  controller: TextEditingController(
                    text: controller.profile.value?.phoneNumber ?? '',
                  ),
                  decoration: InputDecoration(
                    labelText: AppText.phoneNumber.tr,
                    border: const OutlineInputBorder(),
                    enabled: false,
                    filled: true,
                    fillColor: Colors.grey[200],
                    suffixIcon: const Icon(Icons.lock_outline, size: 20),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 4.h),
                Text(
                  AppText.numberCantChange.tr,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: 16.h),
                // Email (Editable)
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: AppText.email.tr,
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 24.h),
                // Buttons in one row
                Row(
                  children: [
                    // Cancel Button
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                        child: Text(
                          AppText.cancel.tr,
                          style: TextStyle(
                            fontFamily: 'Supreme',
                            fontSize: 14.sp,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    // Save Button
                    Expanded(
                      child: Obx(
                        () => ElevatedButton(
                          onPressed: controller.isSaving.value
                              ? null
                              : () async {
                                  final email = emailController.text.trim();
                                  if (email.isEmpty) {
                                    Get.snackbar(
                                      'Error',
                                      'Email cannot be empty',
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.red.withOpacity(
                                        0.8,
                                      ),
                                      colorText: Colors.white,
                                    );
                                    return;
                                  }

                                  controller.emailController.text = email;
                                  await controller.saveProfile();

                                  if (context.mounted) {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text(
                                          'Contact information updated successfully',
                                        ),
                                        backgroundColor: Colors.green,
                                        behavior: SnackBarBehavior.floating,
                                        margin: EdgeInsets.all(16.w),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF50),
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: controller.isSaving.value
                              ? SizedBox(
                                  width: 16.w,
                                  height: 16.w,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Text(
                                  AppText.save.tr,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Supreme',
                                    fontSize: 14.sp,
                                  ),
                                ),
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
}

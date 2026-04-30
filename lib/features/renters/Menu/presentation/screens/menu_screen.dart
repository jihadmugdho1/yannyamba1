import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yannyamba/core/core.dart';
import 'package:yannyamba/features/renters/authentication/controllers/authentication_controller.dart';

import '../widgets/language_widget.dart';
import '../widgets/menu_item_widget.dart';
import '../../controllers/menu_controller.dart';

class SettingsMenu extends StatelessWidget {
  const SettingsMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MenuScreenController>(
      init: MenuScreenController(),
      builder: (controller) {
        final currentLocale = Get.locale;
        final selectedLanguage = currentLocale?.languageCode == 'en'
            ? 'EN'
            : 'FR';

        return Scaffold(
          appBar: CustomAppBar(
            title: AppText.settings.tr,
            showBackButton: false,
            centerTitle: true,
            // showRestartButton: true,
          ),
          backgroundColor: Colors.grey[100],
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (controller.shouldShowOwnerButton())
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(Iconsax.user_tag),
                        label: Text(
                          AppText.switchToOwnersDashboard.tr,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: controller.handleSwitchToOwnersDashboard,
                      ),
                    ),
                  _buildDivider(),
                  MenuItemWidget(
                    icon: Iconsax.house,
                    title: AppText.profile.tr,
                    onTap: controller.navigateToProfile,
                  ),
                  _buildDivider(),
                  MenuItemWidget(
                    icon: Iconsax.calendar_1,
                    title: AppText.myBookings.tr,
                    onTap: controller.navigateToMyBookings,
                  ),
                  _buildDivider(),
                  LanguageToggleWidget(
                    selectedLanguage: selectedLanguage,
                    onChange: controller.changeLanguage,
                  ),
                  // _buildDivider(),
                  // GestureDetector(
                  //   onTap: controller.navigateToNotifications,
                  //   child: MenuItemWidget(
                  //     icon: Iconsax.notification,
                  //     title: AppText.notificationSettings.tr,
                  //   ),
                  // ),
                  _buildDivider(),
                  MenuItemWidget(
                    icon: Iconsax.call,
                    title: AppText.contactUs.tr,
                    onTap: controller.navigateToContact,
                  ),
                  _buildDivider(),
                  GestureDetector(
                    onTap: controller.navigateToFAQ,
                    child: MenuItemWidget(
                      icon: Iconsax.message_question,
                      title: AppText.faq.tr,
                    ),
                  ),
                  _buildDivider(),
                  Obx(() {
                    final authenticationController =
                        Get.find<AuthenticationController>();
                    final isLoggedIn =
                        authenticationController.isLoggedIn.value;

                    return GestureDetector(
                      onTap: controller.handleLoginLogout,
                      child: MenuItemWidget(
                        icon: isLoggedIn ? Iconsax.logout : Iconsax.login,
                        title: isLoggedIn
                            ? AppText.logout.tr
                            : AppText.logIn.tr,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.black26,
      indent: 20,
      endIndent: 20,
    );
  }
}

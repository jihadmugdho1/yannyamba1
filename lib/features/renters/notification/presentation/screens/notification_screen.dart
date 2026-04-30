import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yannyamba/core/core.dart';

import '../../controllers/notification_controller.dart';
import '../../data/services/notification_service.dart';
import '../widgets/notification_tile_widgets.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      NotificationSettingsController(NotificationService()),
    );

    return Scaffold(
      appBar: CustomAppBar(
        title: "Notification Settings",
        centerTitle: true,
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.separated(
            itemCount: controller.settings.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final setting = controller.settings[index];
              return Obx(
                () => NotificationTile(
                  title: setting.title,
                  description: setting.description,
                  value: setting.value.value,
                  onChanged: (val) => controller.toggleSetting(setting, val),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

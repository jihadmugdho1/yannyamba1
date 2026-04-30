import 'package:get/get.dart';

import '../data/models/notification_setting_model.dart';
import '../data/services/notification_service.dart';

class NotificationSettingsController extends GetxController {
  final NotificationService service;
  NotificationSettingsController(this.service);

  var settings = <NotificationSetting>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  Future<void> loadSettings() async {
    isLoading.value = true;
    settings.value = await service.fetchSettings();
    isLoading.value = false;
  }

  Future<void> toggleSetting(NotificationSetting setting, bool value) async {
    setting.value.value = value;
    await service.updateSetting(setting.id, value);
  }
}

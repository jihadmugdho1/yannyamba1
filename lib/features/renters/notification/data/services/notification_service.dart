import '../models/notification_setting_model.dart';

class NotificationService {
  Future<List<NotificationSetting>> fetchSettings() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      NotificationSetting(
        id: "push",
        title: "Allow Push Notifications",
        description:
            "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumym",
        initialValue: true,
      ),
      NotificationSetting(
        id: "general",
        title: "General Notifications",
        description:
            "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumym",
        initialValue: true,
      ),
    ];
  }

  Future<void> updateSetting(String id, bool value) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}

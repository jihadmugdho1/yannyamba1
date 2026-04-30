import 'package:get/get.dart';

class NotificationSetting {
  final String id;
  final String title;
  final String description;
  RxBool value;

  NotificationSetting({
    required this.id,
    required this.title,
    required this.description,
    required bool initialValue,
  }) : value = initialValue.obs;
}

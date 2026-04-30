import 'package:get/get.dart';

/// Controller to manage navigation state across owner dashboard screens
class OwnerNavigationController extends GetxController {
  // Observable current navigation index
  final _currentIndex = 0.obs;

  // Getter for current index
  int get currentIndex => _currentIndex.value;

  // Setter for current index
  set currentIndex(int index) => _currentIndex.value = index;

  /// Change the current navigation index
  void changeIndex(int index) {
    if (index >= 0 && index <= 3) {
      _currentIndex.value = index;
    }
  }

  /// Navigate to Dashboard (index 0)
  void goToDashboard() {
    _currentIndex.value = 0;
  }

  /// Navigate to Properties List (index 1)
  void goToProperties() {
    _currentIndex.value = 1;
  }

  /// Navigate to Add Property (index 2)
  void goToAddProperty() {
    _currentIndex.value = 2;
  }

  /// Navigate to Profile (index 3)
  void goToProfile() {
    _currentIndex.value = 3;
  }

  /// Reset navigation to dashboard
  @override
  void onInit() {
    super.onInit();
    _currentIndex.value = 0;
  }
}

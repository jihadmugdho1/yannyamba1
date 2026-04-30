import 'package:get/get.dart';
import 'package:yannyamba/features/common/profile/controllers/profile_controller.dart';
import 'package:yannyamba/features/owners/bookings/data/models/booking_models.dart';
import 'package:yannyamba/features/renters/authentication/controllers/authentication_controller.dart';
import 'package:yannyamba/features/renters/bookings/data/services/booking_service.dart';

class MyBookingsController extends GetxController {
  MyBookingsController({required BookingService service}) : _service = service;

  final BookingService _service;
  final AuthenticationController _authenticationController =
      Get.find<AuthenticationController>();
  final ProfileController _profileController = Get.find<ProfileController>();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<OwnerBooking> bookings = <OwnerBooking>[].obs;

  @override
  void onInit() {
    super.onInit();
    if (_authenticationController.isLoggedIn.value) {
      fetchMyBookings();
    } else {
      errorMessage.value = 'Please login first';
    }
  }

  Future<void> fetchMyBookings() async {
    if (!_authenticationController.isLoggedIn.value) {
      errorMessage.value = 'Please login first';
      bookings.clear();
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      var phone = _profileController.profile.value?.phoneNumber.trim() ?? '';
      if (phone.isEmpty) {
        await _profileController.fetchProfile();
        phone = _profileController.profile.value?.phoneNumber.trim() ?? '';
      }

      if (phone.isEmpty) {
        throw Exception('Phone number not found in profile');
      }

      final rawList = await _service.fetchUserBookings(phone: phone);
      final parsed = rawList.map(OwnerBooking.fromJson).toList();
      bookings.assignAll(parsed);
    } catch (e) {
      errorMessage.value = e.toString();
      bookings.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<OwnerBooking?> fetchBookingDetails(String ticketId) async {
    try {
      final raw = await _service.fetchBookingDetails(ticketId: ticketId);
      if (raw.isEmpty) return null;
      return OwnerBooking.fromJson(raw);
    } catch (e) {
      rethrow;
    }
  }
}

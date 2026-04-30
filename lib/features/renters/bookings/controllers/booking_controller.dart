import 'package:get/get.dart';
import 'package:yannyamba/features/renters/bookings/data/services/booking_service.dart';

class BookingController extends GetxController {
  final BookingService _service;

  BookingController({required BookingService service}) : _service = service;

  final isSubmitting = false.obs;
  final errorMessage = ''.obs;

  Future<bool> submitBooking({
    required String apartmentId,
    required String phone,
    required String startDate,
    required String endDate,
  }) async {
    isSubmitting.value = true;
    errorMessage.value = '';
    try {
      await _service.createBooking(
        apartmentId: apartmentId,
        phone: phone,
        startDate: startDate,
        endDate: endDate,
      );
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }
}

import 'package:get/get.dart';
import 'package:yannyamba/features/owners/bookings/data/models/booking_models.dart';
import 'package:yannyamba/features/owners/bookings/data/services/owner_bookings_service.dart';

class ApartmentBookingsState {
  final bool isLoading;
  final String errorMessage;
  final List<OwnerBooking> bookings;

  const ApartmentBookingsState({
    required this.isLoading,
    required this.errorMessage,
    required this.bookings,
  });

  const ApartmentBookingsState.initial()
    : isLoading = false,
      errorMessage = '',
      bookings = const [];

  ApartmentBookingsState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<OwnerBooking>? bookings,
  }) {
    return ApartmentBookingsState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      bookings: bookings ?? this.bookings,
    );
  }
}

class OwnerBookingsController extends GetxController {
  final OwnerBookingsService _service;

  OwnerBookingsController({required OwnerBookingsService service})
    : _service = service;

  final bookings = <OwnerBooking>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final apartmentBookings = <String, ApartmentBookingsState>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOwnerBookings();
  }

  Future<void> fetchOwnerBookings() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final data = await _service.fetchOwnerBookings();
      bookings.value = data;
    } catch (e) {
      errorMessage.value = e.toString();
      bookings.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshBookings() async {
    await fetchOwnerBookings();
  }

  ApartmentBookingsState getApartmentBookingsState(String apartmentId) {
    return apartmentBookings[apartmentId] ??
        const ApartmentBookingsState.initial();
  }

  Future<void> fetchApartmentBookings(String apartmentId) async {
    apartmentBookings[apartmentId] = getApartmentBookingsState(
      apartmentId,
    ).copyWith(isLoading: true, errorMessage: '');
    try {
      final list = await _service.fetchApartmentBookings(apartmentId);
      apartmentBookings[apartmentId] = ApartmentBookingsState(
        isLoading: false,
        errorMessage: '',
        bookings: list,
      );
    } catch (e) {
      apartmentBookings[apartmentId] = ApartmentBookingsState(
        isLoading: false,
        errorMessage: e.toString(),
        bookings: const [],
      );
    }
  }

  Future<void> refreshApartmentBookings(String apartmentId) async {
    await fetchApartmentBookings(apartmentId);
  }
}

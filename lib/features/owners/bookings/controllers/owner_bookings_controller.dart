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

  static const int ownerBookingsPageSize = 5;

  final bookings = <OwnerBooking>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final _bookingsPage = 1.obs;
  final _bookingsHasNextPage = true.obs;
  final isLoadingMore = false.obs;

  final apartmentBookings = <String, ApartmentBookingsState>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOwnerBookings(reset: true);
  }

  void clearUserData() {
    bookings.clear();
    apartmentBookings.clear();
    errorMessage.value = '';
    _bookingsPage.value = 1;
    _bookingsHasNextPage.value = true;
  }

  bool get canLoadMore =>
      _bookingsHasNextPage.value && !isLoading.value && !isLoadingMore.value;

  Future<void> fetchOwnerBookings({required bool reset}) async {
    if (reset) {
      isLoading.value = true;
    }
    try {
      if (reset) {
        _bookingsPage.value = 1;
        _bookingsHasNextPage.value = true;
        errorMessage.value = '';
        bookings.clear();
      }

      final requestPage = _bookingsPage.value;
      final requestLimit = ownerBookingsPageSize;

      Map<String, dynamic>? responseMeta;
      final data = await _service.fetchOwnerBookings(
        page: requestPage,
        limit: requestLimit,
        onMeta: (meta) => responseMeta = meta,
      );

      if (reset) {
        bookings.value = data;
      } else {
        bookings.addAll(data);
      }

      final hasNext = _metaHasNextPage(
        meta: responseMeta,
        fallbackFetchedCount: data.length,
        limit: requestLimit,
      );
      _bookingsHasNextPage.value = hasNext;
      if (hasNext) _bookingsPage.value = requestPage + 1;
    } catch (e) {
      errorMessage.value = e.toString();
      if (reset) {
        bookings.value = [];
        _bookingsHasNextPage.value = false;
      }
    } finally {
      if (reset) isLoading.value = false;
    }
  }

  Future<void> refreshBookings() async {
    await fetchOwnerBookings(reset: true);
  }

  Future<void> loadMoreBookings() async {
    if (!canLoadMore) return;
    isLoadingMore.value = true;
    try {
      await fetchOwnerBookings(reset: false);
    } finally {
      isLoadingMore.value = false;
    }
  }

  bool _metaHasNextPage({
    required Map<String, dynamic>? meta,
    required int fallbackFetchedCount,
    required int limit,
  }) {
    if (meta == null) return fallbackFetchedCount >= limit;

    final hasNext = meta['hasNextPage'];
    if (hasNext is bool) return hasNext;
    if (hasNext is String) return hasNext.toLowerCase() == 'true';

    final currentPage = meta['page'];
    final totalPage = meta['totalPage'] ?? meta['total_page'];
    if (currentPage is int && totalPage is int) return currentPage < totalPage;

    final total = meta['total'];
    final skip = meta['skip'];
    final metaLimit = meta['limit'];
    if (total is int && skip is int && metaLimit is int) {
      return (skip + metaLimit) < total;
    }

    return fallbackFetchedCount >= limit;
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

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:yannyamba/core/core.dart';
import 'package:yannyamba/features/owners/bookings/controllers/owner_bookings_controller.dart';
import 'package:yannyamba/features/owners/bookings/data/models/booking_models.dart';

class OwnerBookingDetailsScreen extends StatefulWidget {
  final String apartmentId;
  final String? bookingId;
  final BookingApartmentSummary? apartment;

  const OwnerBookingDetailsScreen({
    super.key,
    required this.apartmentId,
    this.bookingId,
    this.apartment,
  });

  @override
  State<OwnerBookingDetailsScreen> createState() =>
      _OwnerBookingDetailsScreenState();
}

class _OwnerBookingDetailsScreenState extends State<OwnerBookingDetailsScreen> {
  final OwnerBookingsController _controller =
      Get.find<OwnerBookingsController>();

  @override
  void initState() {
    super.initState();
    _controller.fetchApartmentBookings(widget.apartmentId);
  }

  @override
  Widget build(BuildContext context) {
    final apartment = widget.apartment;
    final imageUrl = apartment?.primaryImageUrl.isNotEmpty == true
        ? apartment!.primaryImageUrl
        : 'assets/images/home_image.png';

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () =>
            _controller.refreshApartmentBookings(widget.apartmentId),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 220,
              backgroundColor: Colors.white,
              iconTheme: const IconThemeData(color: Colors.white),
              leading: IconButton(
                icon: const Icon(Iconsax.arrow_left_2),
                onPressed: () => Get.back(),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Iconsax.refresh),
                  onPressed: () =>
                      _controller.fetchApartmentBookings(widget.apartmentId),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image(image: _resolveImage(imageUrl), fit: BoxFit.cover),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.45),
                            Colors.black.withValues(alpha: 0.05),
                            Colors.black.withValues(alpha: 0.6),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bookings',
                      style: getTextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (apartment != null)
                      _ApartmentSummaryCard(apartment: apartment),
                    if (apartment != null) const SizedBox(height: 16),
                    Obx(() {
                      final state = _controller.getApartmentBookingsState(
                        widget.apartmentId,
                      );

                      if (state.isLoading) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 24),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (state.errorMessage.isNotEmpty) {
                        return _ErrorState(
                          message: state.errorMessage,
                          onRetry: () => _controller.fetchApartmentBookings(
                            widget.apartmentId,
                          ),
                        );
                      }

                      if (state.bookings.isEmpty) {
                        return _EmptyState(
                          onRetry: () => _controller.fetchApartmentBookings(
                            widget.apartmentId,
                          ),
                        );
                      }

                      return ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: state.bookings.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final booking = state.bookings[index];
                          final isSelected =
                              widget.bookingId != null &&
                              booking.id == widget.bookingId;
                          return _BookingTile(
                            booking: booking,
                            highlight: isSelected,
                          );
                        },
                      );
                    }),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ImageProvider _resolveImage(String imageUrl) {
    final isNetwork =
        imageUrl.startsWith('http://') || imageUrl.startsWith('https://');
    if (isNetwork) return NetworkImage(imageUrl);
    if (imageUrl.startsWith('assets/')) return AssetImage(imageUrl);
    return AssetImage('assets/images/home_image.png');
  }
}

class _ApartmentSummaryCard extends StatelessWidget {
  final BookingApartmentSummary apartment;

  const _ApartmentSummaryCard({required this.apartment});

  @override
  Widget build(BuildContext context) {
    final addressParts = [
      if (apartment.neighborhood.isNotEmpty) apartment.neighborhood,
      if (apartment.cityName.isNotEmpty) apartment.cityName,
    ];
    final address = addressParts.join(', ');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            apartment.listingType.isNotEmpty
                ? apartment.listingType
                : 'Apartment',
            style: getTextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor,
            ),
          ),
          if (address.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              address,
              style: getTextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textColor2,
              ),
            ),
          ],
          const SizedBox(height: 10),
          Row(
            children: [
              if (apartment.propertyCategory.isNotEmpty)
                _Chip(text: apartment.propertyCategory),
              if (apartment.propertyCategory.isNotEmpty)
                const SizedBox(width: 8),
              if (apartment.dailyRate != null)
                _Chip(text: '৳ ${apartment.dailyRate} / night'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;

  const _Chip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB).withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: getTextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textColor,
        ),
      ),
    );
  }
}

class _BookingTile extends StatelessWidget {
  final OwnerBooking booking;
  final bool highlight;

  const _BookingTile({required this.booking, required this.highlight});

  @override
  Widget build(BuildContext context) {
    final borderColor = highlight
        ? const Color(0xFF2196F3)
        : const Color(0xFFE5E7EB);
    final bgColor = highlight
        ? const Color(0xFF2196F3).withValues(alpha: 0.05)
        : Colors.white;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  booking.ticketId.isNotEmpty ? booking.ticketId : 'Ticket',
                  style: getTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor,
                  ),
                ),
              ),
              _StatusPill(status: booking.status),
            ],
          ),
          const SizedBox(height: 10),
          _DetailRow(
            icon: Iconsax.user,
            label: 'Customer',
            value: booking.customer.name.isNotEmpty
                ? booking.customer.name
                : '-',
          ),
          const SizedBox(height: 6),
          _DetailRow(
            icon: Iconsax.call,
            label: 'Phone',
            value: booking.phone.isNotEmpty
                ? booking.phone
                : booking.customer.phone,
          ),
          const SizedBox(height: 6),
          _DetailRow(
            icon: Iconsax.calendar_1,
            label: 'Stay',
            value: _formatRange(booking.startDate, booking.endDate),
          ),
        ],
      ),
    );
  }

  String _formatRange(DateTime? start, DateTime? end) {
    final formatter = DateFormat('d MMM, yyyy');
    if (start == null && end == null) return '-';
    if (start != null && end == null) return formatter.format(start.toLocal());
    if (start == null && end != null) return formatter.format(end.toLocal());
    return '${formatter.format(start!.toLocal())} - ${formatter.format(end!.toLocal())}';
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textColor2),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: getTextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor,
          ),
        ),
        Expanded(
          child: Text(
            value.isNotEmpty ? value : '-',
            style: getTextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textColor,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String status;

  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    final normalized = status.trim().toUpperCase();
    final Color bg;
    final Color fg;
    switch (normalized) {
      case 'CONFIRMED':
        bg = const Color(0xFFE7F8EE);
        fg = const Color(0xFF1E7F3C);
        break;
      case 'CANCELLED':
        bg = const Color(0xFFFDECEC);
        fg = const Color(0xFFC62828);
        break;
      case 'PENDING':
        bg = const Color(0xFFFFF4E5);
        fg = const Color(0xFFB26A00);
        break;
      default:
        bg = const Color(0xFFEFF2F6);
        fg = const Color(0xFF4B5563);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        normalized.isEmpty ? '-' : normalized,
        style: getTextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onRetry;

  const _EmptyState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Center(
        child: Column(
          children: [
            const Icon(Iconsax.calendar, size: 48, color: Color(0xFFE5E7EB)),
            const SizedBox(height: 16),
            Text(
              'No bookings yet',
              style: getTextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF282828),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Pull to refresh or try again',
              style: getTextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF686868),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                AppText.retry.tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Center(
        child: Column(
          children: [
            const Icon(Iconsax.warning_2, size: 48, color: Color(0xFFE5E7EB)),
            const SizedBox(height: 16),
            Text(
              'Failed to load bookings',
              style: getTextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF282828),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: getTextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF686868),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                AppText.retry.tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
  State<OwnerBookingDetailsScreen> createState() => _OwnerBookingDetailsScreenState();
}

class _OwnerBookingDetailsScreenState extends State<OwnerBookingDetailsScreen> {
  final _controller = Get.find<OwnerBookingsController>();

  @override
  void initState() {
    super.initState();
    _controller.fetchApartmentBookings(widget.apartmentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Lighter background for better contrast
      body: RefreshIndicator(
        onRefresh: () => _controller.refreshApartmentBookings(widget.apartmentId),
        child: CustomScrollView(
          slivers: [
            _buildAppBar(),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  if (widget.apartment != null) ...[
                    _ApartmentHeader(apartment: widget.apartment!),
                    const SizedBox(height: 24),
                  ],
                  Text(
                    'Booking History',
                    style: getTextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
           
                  _buildBookingsList(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 200,
      leading: const BackButton(color: Colors.white),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            _HeaderImage(imageUrl: widget.apartment?.primaryImageUrl),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black45, Colors.transparent, Colors.black87],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingsList() {
    return Obx(() {
      final state = _controller.getApartmentBookingsState(widget.apartmentId);

      if (state.isLoading) return const Center(child: CircularProgressIndicator.adaptive());
      
      if (state.errorMessage.isNotEmpty) {
        return _StatusFeedback(
          icon: Iconsax.warning_2,
          title: 'Error loading bookings',
          message: state.errorMessage,
          onRetry: () => _controller.fetchApartmentBookings(widget.apartmentId),
        );
      }

      if (state.bookings.isEmpty) {
        return const _StatusFeedback(
          icon: Iconsax.calendar_remove,
          title: 'No bookings found',
          message: 'This apartment hasn\'t received any bookings yet.',
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: state.bookings.length,
       
        itemBuilder: (context, index) => _BookingCard(
          booking: state.bookings[index],
          isSelected: state.bookings[index].id == widget.bookingId,
        ),
      );
    });
  }
}

class _HeaderImage extends StatelessWidget {
  final String? imageUrl;

  const _HeaderImage({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final url = (imageUrl ?? '').trim();
    if (url.isEmpty) {
      return Image.asset('assets/images/home_image.png', fit: BoxFit.cover);
    }

    return Image.network(
      url,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(color: Colors.grey[200]);
      },
      errorBuilder: (context, error, stackTrace) {
        return Image.asset('assets/images/home_image.png', fit: BoxFit.cover);
      },
    );
  }
}

class _ApartmentHeader extends StatelessWidget {
  final BookingApartmentSummary apartment;
  const _ApartmentHeader({required this.apartment});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          apartment.listingType.isEmpty ? 'Apartment' : apartment.listingType,
          style: getTextStyle(fontSize: 22, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Iconsax.location, size: 14, color: AppColors.textColor2),
            const SizedBox(width: 4),
            Text(
              '${apartment.neighborhood}, ${apartment.cityName}',
              style: getTextStyle(fontSize: 14, color: AppColors.textColor2),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: [
            _Tag(text: apartment.propertyCategory, color: Colors.blue),
            _Tag(text: '৳ ${apartment.dailyRate}/night', color: Colors.green),
          ],
        ),
      ],
    );
  }
}

class _BookingCard extends StatelessWidget {
  final OwnerBooking booking;
  final bool isSelected;

  const _BookingCard({required this.booking, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isSelected ? Colors.blue : const Color(0xFFE5E7EB), width: isSelected ? 2 : 1),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                booking.ticketId,
                style: getTextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
              _StatusChip(status: booking.status),
            ],
          ),
          const Divider(height: 24),
          _InfoRow(icon: Iconsax.user, label: 'Guest', value: booking.customer.name),
          const SizedBox(height: 10),
          _InfoRow(icon: Iconsax.call, label: 'Phone', value: booking.phone),
          const SizedBox(height: 10),
          _InfoRow(
            icon: Iconsax.calendar_1,
            label: 'Stay',
            value: '${DateFormat('MMM d').format(booking.startDate!)} - ${DateFormat('MMM d, yyyy').format(booking.endDate!)}',
          ),
        ],
      ),
    );
  }
}

// Reusable Small Components
class _Tag extends StatelessWidget {
  final String text;
  final Color color;
  const _Tag({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: getTextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[400]),
        const SizedBox(width: 10),
        Text('$label:', style: getTextStyle(fontSize: 13, color: AppColors.textColor2)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(value, style: getTextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final bool isConfirmed = status.toUpperCase() == 'CONFIRMED';
    final bool isCancelled = status.toUpperCase() == 'CANCELLED';
    
    final color = isConfirmed ? Colors.green : (isCancelled ? Colors.red : Colors.orange);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
      child: Text(
        status.toUpperCase(),
        style: getTextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: color),
      ),
    );
  }
}

class _StatusFeedback extends StatelessWidget {
  final IconData icon;
  final String title, message;
  final VoidCallback? onRetry;

  const _StatusFeedback({required this.icon, required this.title, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Icon(icon, size: 48, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(title, style: getTextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(message, textAlign: TextAlign.center, style: getTextStyle(color: Colors.grey)),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              TextButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh), label: const Text('Try Again')),
            ]
          ],
        ),
      ),
    );
  }
}

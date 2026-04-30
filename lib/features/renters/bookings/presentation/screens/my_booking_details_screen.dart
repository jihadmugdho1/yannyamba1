import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:yannyamba/core/core.dart';
import 'package:yannyamba/features/owners/bookings/data/models/booking_models.dart';
import 'package:yannyamba/features/renters/bookings/controllers/my_bookings_controller.dart';

class MyBookingDetailsScreen extends StatefulWidget {
  final String ticketId;
  final OwnerBooking? initialBooking;

  const MyBookingDetailsScreen({
    super.key,
    required this.ticketId,
    this.initialBooking,
  });

  @override
  State<MyBookingDetailsScreen> createState() => _MyBookingDetailsScreenState();
}

class _MyBookingDetailsScreenState extends State<MyBookingDetailsScreen> {
  final MyBookingsController _controller = Get.find<MyBookingsController>();
  late Future<OwnerBooking?> _future;

  @override
  void initState() {
    super.initState();
    _future = _controller.fetchBookingDetails(widget.ticketId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _future = _controller.fetchBookingDetails(widget.ticketId);
          });
          await _future;
        },
        child: FutureBuilder<OwnerBooking?>(
          future: _future,
          builder: (context, snapshot) {
            final booking = snapshot.data ?? widget.initialBooking;
            if (booking == null &&
                snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }

            if (booking == null && snapshot.hasError) {
              return _ErrorState(
                message: snapshot.error.toString(),
                onRetry: () {
                  setState(() {
                    _future = _controller.fetchBookingDetails(widget.ticketId);
                  });
                },
              );
            }

            if (booking == null) {
              return _ErrorState(
                message: 'Booking not found',
                onRetry: () {
                  setState(() {
                    _future = _controller.fetchBookingDetails(widget.ticketId);
                  });
                },
              );
            }

            final apartment = booking.apartment;
            final imageUrl = apartment?.primaryImageUrl.isNotEmpty == true
                ? apartment!.primaryImageUrl
                : 'assets/images/home_image.png';
            final title = apartment?.listingType.isNotEmpty == true
                ? apartment!.listingType
                : 'Apartment';

            final addressParts = [
              if ((apartment?.neighborhood ?? '').isNotEmpty)
                apartment!.neighborhood,
              if ((apartment?.cityName ?? '').isNotEmpty) apartment!.cityName,
            ];
            final address = addressParts.join(', ');

            final rentText = apartment?.monthlyRent != null
                ? '৳ ${apartment!.monthlyRent} / month'
                : (apartment?.dailyRate != null
                      ? '৳ ${apartment!.dailyRate} / night'
                      : '');

            return CustomScrollView(
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
                      onPressed: () {
                        setState(() {
                          _future = _controller.fetchBookingDetails(
                            widget.ticketId,
                          );
                        });
                      },
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image(
                          image: _resolveImage(imageUrl),
                          fit: BoxFit.cover,
                        ),
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
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                AppText.bookingDetails.tr,
                                style: getTextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textColor,
                                ),
                              ),
                            ),
                            _StatusPill(status: booking.status),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _SectionCard(
                          title: title,
                          subtitle: address,
                          trailing: rentText,
                          children: [
                            _DetailRow(
                              icon: Iconsax.ticket,
                              label: 'Ticket',
                              value: booking.ticketId,
                            ),
                            const SizedBox(height: 10),
                            _DetailRow(
                              icon: Iconsax.calendar_1,
                              label: 'Dates',
                              value: _formatDateRange(
                                booking.startDate,
                                booking.endDate,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _DetailRow(
                              icon: Iconsax.user_tag,
                              label: 'Owner',
                              value: apartment?.ownerName.isNotEmpty == true
                                  ? apartment!.ownerName
                                  : (apartment?.ownerPhone ?? '-'),
                            ),
                            const SizedBox(height: 10),
                            _DetailRow(
                              icon: Iconsax.call,
                              label: 'Owner phone',
                              value: (apartment?.ownerPhone ?? '').isNotEmpty
                                  ? apartment!.ownerPhone
                                  : '-',
                            ),
                            const SizedBox(height: 10),
                            _DetailRow(
                              icon: Iconsax.call,
                              label: 'My phone',
                              value: booking.phone.isNotEmpty
                                  ? booking.phone
                                  : '-',
                            ),
                            if (booking.createdAt != null) ...[
                              const SizedBox(height: 10),
                              _DetailRow(
                                icon: Iconsax.clock,
                                label: 'Created',
                                value: DateFormat(
                                  'd MMM, yyyy • h:mm a',
                                ).format(booking.createdAt!.toLocal()),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  ImageProvider _resolveImage(String imageUrl) {
    final isNetwork =
        imageUrl.startsWith('http://') || imageUrl.startsWith('https://');
    if (isNetwork) return NetworkImage(imageUrl);
    if (imageUrl.startsWith('assets/')) return AssetImage(imageUrl);
    return const AssetImage('assets/images/home_image.png');
  }

  String _formatDateRange(DateTime? start, DateTime? end) {
    final formatter = DateFormat('d MMM, yyyy');
    if (start == null && end == null) return '-';
    if (start != null && end == null) return formatter.format(start.toLocal());
    if (start == null && end != null) return formatter.format(end.toLocal());
    return '${formatter.format(start!.toLocal())} - ${formatter.format(end!.toLocal())}';
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String trailing;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: getTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textColor,
                      ),
                    ),
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: getTextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textColor2,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing.isNotEmpty) ...[
                const SizedBox(width: 12),
                Text(
                  trailing,
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.textColor2),
        const SizedBox(width: 10),
        SizedBox(
          width: 92,
          child: Text(
            label,
            style: getTextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor,
            ),
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
    final (bg, fg) = switch (normalized) {
      'CONFIRMED' => (const Color(0xFFE7F8EE), const Color(0xFF1E7F3C)),
      'CANCELLED' => (const Color(0xFFFDECEC), const Color(0xFFC62828)),
      'PENDING' => (const Color(0xFFFFF4E5), const Color(0xFFB26A00)),
      _ => (const Color(0xFFEFF2F6), const Color(0xFF4B5563)),
    };

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

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 80),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            children: [
              const Icon(Iconsax.warning_2, size: 42, color: Color(0xFFEF4444)),
              const SizedBox(height: 12),
              Text(
                message,
                style: getTextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Iconsax.refresh, size: 18),
                label: Text(AppText.retry.tr),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:yannyamba/core/core.dart';
import 'package:yannyamba/features/owners/bookings/data/models/booking_models.dart';

class OwnerBookingCard extends StatelessWidget {
  final OwnerBooking booking;
  final VoidCallback onViewDetails;

  const OwnerBookingCard({
    super.key,
    required this.booking,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final apartment = booking.apartment;
    final imageUrl = apartment?.primaryImageUrl.isNotEmpty == true
        ? apartment!.primaryImageUrl
        : 'assets/images/home_image.png';

    final title = apartment?.listingType.isNotEmpty == true
        ? apartment!.listingType
        : 'Apartment';

    final addressParts = [
      if ((apartment?.neighborhood ?? '').isNotEmpty) apartment!.neighborhood,
      if ((apartment?.cityName ?? '').isNotEmpty) apartment!.cityName,
    ];
    final address = addressParts.join(', ');

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BookingImageHeader(imageUrl: imageUrl, status: booking.status),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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
                _InfoRow(
                  icon: Iconsax.ticket,
                  label: 'Ticket',
                  value: booking.ticketId,
                ),
                const SizedBox(height: 6),
                _InfoRow(
                  icon: Iconsax.user,
                  label: 'Customer',
                  value: booking.customer.name.isNotEmpty
                      ? booking.customer.name
                      : booking.phone,
                ),
                const SizedBox(height: 6),
                _InfoRow(
                  icon: Iconsax.calendar_1,
                  label: 'Dates',
                  value: _formatDateRange(booking.startDate, booking.endDate),
                ),
                const SizedBox(height: 14),
                InkWell(
                  onTap: onViewDetails,
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E7EB).withValues(alpha: .4),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Iconsax.eye, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          AppText.viewDetails.tr,
                          style: getTextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateRange(DateTime? start, DateTime? end) {
    final formatter = DateFormat('d MMM, yyyy');
    if (start == null && end == null) return '-';
    if (start != null && end == null) return formatter.format(start.toLocal());
    if (start == null && end != null) return formatter.format(end.toLocal());
    return '${formatter.format(start!.toLocal())} - ${formatter.format(end!.toLocal())}';
  }
}

class _BookingImageHeader extends StatelessWidget {
  final String imageUrl;
  final String status;

  const _BookingImageHeader({required this.imageUrl, required this.status});

  @override
  Widget build(BuildContext context) {
    final isNetworkImage =
        imageUrl.startsWith('http://') || imageUrl.startsWith('https://');
    final isAssetImage = imageUrl.startsWith('assets/');

    ImageProvider imageProvider;
    if (isNetworkImage) {
      imageProvider = NetworkImage(imageUrl);
    } else if (isAssetImage) {
      imageProvider = AssetImage(imageUrl);
    } else {
      imageProvider = FileImage(File(imageUrl));
    }

    return Stack(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        ),
        Positioned(top: 12, right: 12, child: _StatusPill(status: status)),
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

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
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

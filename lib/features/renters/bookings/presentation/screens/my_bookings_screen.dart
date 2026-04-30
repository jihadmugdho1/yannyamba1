import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yannyamba/core/core.dart';
import 'package:yannyamba/features/renters/bookings/controllers/my_bookings_controller.dart';
import 'package:yannyamba/features/renters/bookings/presentation/screens/my_booking_details_screen.dart';
import 'package:yannyamba/features/renters/bookings/presentation/widgets/my_booking_card.dart';

class MyBookingsScreen extends StatelessWidget {
  MyBookingsScreen({super.key});

  final MyBookingsController _controller = Get.find<MyBookingsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(
        title: AppText.myBookings.tr,
        showBackButton: true,
        centerTitle: true,
        onBackTap: () => Get.back(),
      ),
      body: Obx(() {
        return RefreshIndicator(
          onRefresh: _controller.fetchMyBookings,
          child: ListView(
            padding: const EdgeInsets.all(16),
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              if (_controller.isLoading.value)
                const Padding(
                  padding: EdgeInsets.only(top: 60),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_controller.errorMessage.value.isNotEmpty)
                _ErrorState(
                  message: _controller.errorMessage.value,
                  onRetry: _controller.fetchMyBookings,
                )
              else if (_controller.bookings.isEmpty)
                _EmptyState(onRetry: _controller.fetchMyBookings)
              else
                ..._controller.bookings.map((booking) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: MyBookingCard(
                      booking: booking,
                      onViewDetails: () {
                        Get.to(
                          () => MyBookingDetailsScreen(
                            ticketId: booking.ticketId,
                            initialBooking: booking,
                          ),
                        );
                      },
                    ),
                  );
                }),
            ],
          ),
        );
      }),
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
            const Icon(Iconsax.ticket, size: 48, color: Color(0xFFE5E7EB)),
            const SizedBox(height: 16),
            Text(
              'No bookings yet',
              style: getTextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your bookings will appear here.',
              style: getTextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textColor2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Iconsax.refresh, size: 18),
              label: Text(AppText.retry.tr),
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
    );
  }
}

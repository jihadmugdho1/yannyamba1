import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:yannyamba/core/services/storage_service.dart';
import 'package:yannyamba/core/utils/constants/colors.dart';
import 'package:yannyamba/features/renters/bookings/controllers/booking_controller.dart';

Future<void> showBookingDialog({
  required BuildContext context,
  required String apartmentId,
}) async {
  final controller = Get.find<BookingController>();
  controller.errorMessage.value = '';
  final initialPhone = (await StorageService.getAuthRegisteredPhone()) ?? '';

  if (!context.mounted) return;

  showDialog(
    context: context,
    builder: (_) => _BookingDialog(
      apartmentId: apartmentId,
      controller: controller,
      initialPhone: initialPhone,
    ),
  );
}

class _BookingDialog extends StatefulWidget {
  final String apartmentId;
  final BookingController controller;
  final String initialPhone;

  const _BookingDialog({
    required this.apartmentId,
    required this.controller,
    required this.initialPhone,
  });

  @override
  State<_BookingDialog> createState() => _BookingDialogState();
}

class _BookingDialogState extends State<_BookingDialog> {
  late final TextEditingController phoneController = TextEditingController();
  DateTimeRange? dateRange;

  String get dateDisplay => dateRange == null
      ? 'Select Dates'
      : '${DateFormat('MMM dd').format(dateRange!.start)} - ${DateFormat('MMM dd').format(dateRange!.end)}';

  Future<void> pickDates() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => dateRange = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Obx(() {
          final bool loading = widget.controller.isSubmitting.value;
          final String error = widget.controller.errorMessage.value;

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Request Booking',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Phone Field
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: const Icon(Icons.phone_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Date Range Picker (Smarter UI than two buttons)
              InkWell(
                onTap: loading ? null : pickDates,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 20),
                      const SizedBox(width: 12),
                      Text(dateDisplay, style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),

              if (error.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  error.replaceFirst('Exception: ', ''),
                  style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                ),
              ],

              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: loading ? null : () => Navigator.pop(context),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        side: BorderSide.none,
                        backgroundColor: AppColors.primaryBlue,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: loading ? null : _submit,
                      child: loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Confirm',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }

  void _submit() async {
    final phone = phoneController.text.trim();
    if (phone.isEmpty || dateRange == null) {
      widget.controller.errorMessage.value = 'Please fill all fields';
      return;
    }

    final success = await widget.controller.submitBooking(
      apartmentId: widget.apartmentId,
      phone: phone,
      startDate: DateFormat('yyyy-MM-dd').format(dateRange!.start),
      endDate: DateFormat('yyyy-MM-dd').format(dateRange!.end),
    );

    if (success && mounted) {
      Navigator.pop(context);
      Get.snackbar(
        'Success',
        'Booking submitted!',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}

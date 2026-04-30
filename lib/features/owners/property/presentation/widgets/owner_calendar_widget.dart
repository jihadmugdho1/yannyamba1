import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:yannyamba/core/core.dart';
import 'package:yannyamba/core/models/property/property_models.dart';
import 'package:yannyamba/features/owners/dashboard/controllers/owner_dashboard_controller.dart';
import 'package:yannyamba/features/owners/property/controllers/property_booking_controller.dart';

class OwnerCalendarWidget extends StatefulWidget {
  final FurnishedApartment apartment;
  final Function(FurnishedApartment)? onApartmentUpdated;

  const OwnerCalendarWidget({
    super.key,
    required this.apartment,
    this.onApartmentUpdated,
  });

  @override
  State<OwnerCalendarWidget> createState() => _OwnerCalendarWidgetState();
}

class _OwnerCalendarWidgetState extends State<OwnerCalendarWidget> {
  DateTime _currentMonth = DateTime.now();
  final Set<DateTime> _selectedDatesToBlock = {};

  // Get or create the booking controller
  late final PropertyBookingController _bookingController;
  late final OwnerDashboardController _dashboardController;

  // Keep track of current apartment data
  late FurnishedApartment _currentApartment;

  @override
  void initState() {
    super.initState();
    // Initialize controllers
    _bookingController = Get.put(PropertyBookingController());
    _dashboardController = Get.find<OwnerDashboardController>();
    _currentApartment = widget.apartment;
  }

  @override
  void didUpdateWidget(OwnerCalendarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.apartment != widget.apartment) {
      setState(() {
        _currentApartment = widget.apartment;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: .05),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: .05),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.chevron_left, size: 22.sp),
                      onPressed: () {
                        setState(() {
                          _currentMonth = DateTime(
                            _currentMonth.year,
                            _currentMonth.month - 1,
                          );
                        });
                      },
                    ),
                    Text(
                      DateFormat('MMMM yyyy').format(_currentMonth),
                      style: getTextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.chevron_right, size: 22.sp),
                      onPressed: () {
                        setState(() {
                          _currentMonth = DateTime(
                            _currentMonth.year,
                            _currentMonth.month + 1,
                          );
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  AppText.managePropertyAvailability.tr,
                  style: getTextStyle(
                    fontSize: 10.sp,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          /// Legend Row
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendItem(
                  AppColors.success.withValues(alpha: .15),
                  AppText.available.tr,
                ),
                _buildLegendItem(
                  AppColors.error.withValues(alpha: .2),
                  AppText.booked.tr,
                ),
                _buildLegendItem(Colors.grey.shade200, AppText.unavailable.tr),
              ],
            ),
          ),

          const Divider(height: 1),

          /// Calendar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            child: _buildCalendarGrid(),
          ),

          /// Selected Dates Info
          if (_selectedDatesToBlock.isNotEmpty)
            Container(
              margin: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0.h),
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: AppColors.primaryBlue.withValues(alpha: .3),
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.event_busy,
                        color: AppColors.primaryBlue,
                        size: 20.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        AppText.selectedDatesToBlock.tr,
                        style: getTextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),

                  Text(
                    '${_selectedDatesToBlock.length} ${AppText.datesSelected.tr}',
                    style: getTextStyle(
                      fontSize: 10.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Wrap(
                    spacing: 6.w,
                    runSpacing: 4.h,
                    children: _selectedDatesToBlock.map((date) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withValues(alpha: .1),
                          borderRadius: BorderRadius.circular(6.r),
                          border: Border.all(
                            color: AppColors.primaryBlue.withValues(alpha: .3),
                          ),
                        ),
                        child: Text(
                          DateFormat('MMM dd').format(date),
                          style: getTextStyle(
                            fontSize: 6.sp,
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

          /// Buttons
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Obx(() {
              final isLoading = _bookingController.isLoading.value;

              return Row(
                children: [
                  if (_selectedDatesToBlock.isNotEmpty && !isLoading)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _selectedDatesToBlock.clear();
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.textSecondary),
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          AppText.clearSelection.tr,
                          style: getTextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  if (_selectedDatesToBlock.isNotEmpty && !isLoading)
                    SizedBox(width: 12.w),
                  if (_selectedDatesToBlock.isNotEmpty)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _markDatesAsBooked,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          disabledBackgroundColor: AppColors.primaryBlue
                              .withValues(alpha: .5),
                        ),
                        child: isLoading
                            ? SizedBox(
                                height: 20.h,
                                width: 20.h,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                AppText.markAsBooked.tr,
                                style: getTextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3.r),
            border: Border.all(color: Colors.grey.shade300, width: 0.5),
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          label,
          style: getTextStyle(
            fontSize: 8.sp,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month,
      1,
    );
    final lastDayOfMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month + 1,
      0,
    );
    final daysInMonth = lastDayOfMonth.day;
    final startWeekday = firstDayOfMonth.weekday % 7;

    final totalCells = startWeekday + daysInMonth;
    final rowsNeeded = (totalCells / 7).ceil();

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final cellSize = (availableWidth - 12.w) / 7;

        return Column(
          children: [
            Row(
              children:
                  [
                        AppText.sun.tr,
                        AppText.mon.tr,
                        AppText.tue.tr,
                        AppText.wed.tr,
                        AppText.thu.tr,
                        AppText.fri.tr,
                        AppText.sat.tr,
                      ]
                      .map(
                        (day) => SizedBox(
                          width: cellSize,
                          child: Center(
                            child: Text(
                              day,
                              style: getTextStyle(
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
            ),
            SizedBox(height: 6.h),
            ...List.generate(rowsNeeded, (weekIndex) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                child: Row(
                  children: List.generate(7, (dayIndex) {
                    final cellIndex = weekIndex * 7 + dayIndex;
                    final dayNumber = cellIndex - startWeekday + 1;

                    if (dayNumber < 1 || dayNumber > daysInMonth) {
                      return SizedBox(width: cellSize, height: cellSize * 0.85);
                    }

                    final date = DateTime(
                      _currentMonth.year,
                      _currentMonth.month,
                      dayNumber,
                    );

                    return SizedBox(
                      width: cellSize,
                      height: cellSize * 0.85,
                      child: Padding(
                        padding: EdgeInsets.all(1.5.w),
                        child: _buildDayButton(date, cellSize * 0.85 - 3.w),
                      ),
                    );
                  }),
                ),
              );
            }),
          ],
        );
      },
    );
  }

  Widget _buildDayButton(DateTime date, double size) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final isPast = date.isBefore(today);

    // Check if date is in bookings (from booking_dates API response)
    // The bookings list includes dates parsed from booking_dates array
    final isBooked = _currentApartment.bookings.any((booking) {
      // For single-day bookings from API (booking_dates like "04/01/2026")
      // checkOutDate is checkInDate + 1 day, so we check if date matches checkInDate
      final isSameDayBooking =
          date.year == booking.checkInDate.year &&
          date.month == booking.checkInDate.month &&
          date.day == booking.checkInDate.day;

      // Also check if date is within a multi-day booking range
      final isInBookingRange =
          (date.isAfter(booking.checkInDate) ||
              date.isAtSameMomentAs(booking.checkInDate)) &&
          date.isBefore(booking.checkOutDate);

      return isSameDayBooking || isInBookingRange;
    });

    // Check if date is in blocked dates
    final isBlocked = _currentApartment.blockedDates.any(
      (blocked) =>
          date.year == blocked.year &&
          date.month == blocked.month &&
          date.day == blocked.day,
    );

    // Check if date is selected to be blocked
    final isSelectedToBlock = _selectedDatesToBlock.any(
      (selected) =>
          date.year == selected.year &&
          date.month == selected.month &&
          date.day == selected.day,
    );

    final isToday =
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;

    // Determine the date type: Available, Booked, or Unavailable
    Color? backgroundColor;
    Color? textColor = AppColors.textPrimary;
    Color? borderColor;

    // 1. UNAVAILABLE - Past dates
    if (isPast) {
      backgroundColor = Colors.grey.shade200;
      textColor = Colors.grey.shade400;
    }
    // 2. BOOKED - Already booked or blocked dates
    else if (isBooked || isBlocked) {
      backgroundColor = AppColors.error.withValues(alpha: .2);
      textColor = AppColors.error;
      borderColor = AppColors.error.withValues(alpha: .3);
    }
    // 3. SELECTED (visual state when owner is selecting dates)
    else if (isSelectedToBlock) {
      backgroundColor = AppColors.primaryBlue.withValues(alpha: .2);
      textColor = AppColors.primaryBlue;
      borderColor = AppColors.primaryBlue;
    }
    // 4. AVAILABLE - Future dates that are free
    else {
      backgroundColor = AppColors.success.withValues(alpha: .15);
      textColor = AppColors.textPrimary;
    }

    return GestureDetector(
      onTap: (isPast || isBooked || isBlocked)
          ? null
          : () {
              setState(() {
                if (isSelectedToBlock) {
                  // Unselect if already selected
                  _selectedDatesToBlock.removeWhere(
                    (selected) =>
                        date.year == selected.year &&
                        date.month == selected.month &&
                        date.day == selected.day,
                  );
                } else {
                  // Select date
                  _selectedDatesToBlock.add(date);
                }
              });
            },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8.r),
          border: borderColor != null
              ? Border.all(
                  color: borderColor,
                  width: isSelectedToBlock ? 2.w : 1.w,
                )
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          '${date.day}',
          style: getTextStyle(
            fontSize: size > 40 ? 10.sp : 8.sp,
            fontWeight: (isSelectedToBlock || isBooked || isBlocked || isToday)
                ? FontWeight.bold
                : FontWeight.normal,
            color: textColor,
          ),
        ),
      ),
    );
  }

  void _markDatesAsBooked() async {
    // Show loading state
    _bookingController.clearMessages();

    final updatedApartment = await _bookingController.addBookingDates(
      propertyId: _currentApartment.id,
      dates: _selectedDatesToBlock.toList(),
    );

    if (updatedApartment != null) {
      // Update the current apartment data immediately
      setState(() {
        _currentApartment = updatedApartment;
        _selectedDatesToBlock.clear();
      });

      // Notify parent widget if callback provided
      widget.onApartmentUpdated?.call(updatedApartment);

      // Also update the dashboard controller
      _dashboardController.fetchFurnishedApartments();

      Get.snackbar(
        AppText.success.tr,
        '${updatedApartment.bookings.length - _currentApartment.bookings.length} ${AppText.datesMarkedAsBooked.tr}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.success,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } else {
      Get.snackbar(
        'Error',
        _bookingController.errorMessage.value.isEmpty
            ? 'Failed to mark dates as booked'
            : _bookingController.errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:yannyamba/core/core.dart';
import 'package:yannyamba/core/models/property/property_models.dart';
import 'package:yannyamba/features/renters/furnished_apartments/controllers/furnished_apartment_controller.dart';

class CalendarBookingWidget extends StatefulWidget {
  final FurnishedApartment apartment;

  const CalendarBookingWidget({super.key, required this.apartment});

  @override
  State<CalendarBookingWidget> createState() => _CalendarBookingWidgetState();
}

class _CalendarBookingWidgetState extends State<CalendarBookingWidget> {
  final controller = Get.find<FurnishedApartmentController>();
  DateTime _currentMonth = DateTime.now();
  DateTime? _selectedCheckIn;
  DateTime? _selectedCheckOut;

  @override
  void initState() {
    super.initState();
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
            child: Row(
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
          ),

          /// Legend Row (Updated)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendItem(
                  AppColors.primaryBlue.withValues(alpha: .2),
                  AppText.checkIn.tr,
                ),
                _buildLegendItem(
                  AppColors.success.withValues(alpha: .2),
                  AppText.checkOut.tr,
                ),
                _buildLegendItem(
                  AppColors.primaryBlue.withValues(alpha: .12),
                  AppText.selected.tr,
                ),
                _buildLegendItem(Colors.grey.shade100, AppText.unavailable.tr),
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
          if (_selectedCheckIn != null || _selectedCheckOut != null)
            Container(
              margin: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (_selectedCheckIn != null)
                        Expanded(
                          child: _buildDateInfo(
                            AppText.checkIn.tr,
                            _selectedCheckIn!,
                            Icons.login,
                            AppColors.primaryBlue,
                          ),
                        ),
                      if (_selectedCheckIn != null && _selectedCheckOut != null)
                        SizedBox(width: 12.w),
                      if (_selectedCheckOut != null)
                        Expanded(
                          child: _buildDateInfo(
                            AppText.checkOut.tr,
                            _selectedCheckOut!,
                            Icons.logout,
                            AppColors.success,
                          ),
                        ),
                    ],
                  ),
                  if (_selectedCheckIn != null &&
                      _selectedCheckOut != null) ...[
                    Divider(height: 24.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppText.totalNights.tr,
                          style: getTextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          '${_selectedCheckOut!.difference(_selectedCheckIn!).inDays} ${AppText.night.tr}${_selectedCheckOut!.difference(_selectedCheckIn!).inDays > 1 ? AppText.nights.tr : ''}',
                          style: getTextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppText.totalPrice.tr,
                          style: getTextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          '\$${widget.apartment.calculateTotalPrice(_selectedCheckIn!, _selectedCheckOut!).toStringAsFixed(2)}',
                          style: getTextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

          /// Buttons
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                if (_selectedCheckIn != null || _selectedCheckOut != null)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _selectedCheckIn = null;
                          _selectedCheckOut = null;
                        });
                        controller.setDates(null, null);
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.primaryBlue),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        AppText.clearDates.tr,
                        style: getTextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ),
                  ),
                if (_selectedCheckIn != null || _selectedCheckOut != null)
                  SizedBox(width: 12.w),
                if (_selectedCheckIn != null && _selectedCheckOut != null)
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.setDates(
                          _selectedCheckIn,
                          _selectedCheckOut,
                        );
                        Get.snackbar(
                          AppText.datesSelected.tr,
                          AppText.bookingSummaryContactOwner.tr,
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppColors.success,
                          colorText: Colors.white,
                          duration: const Duration(seconds: 2),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        AppText.applyDates.tr,
                        style: getTextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
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

  Widget _buildDateInfo(
    String label,
    DateTime date,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          // padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: color.withValues(alpha: .1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, color: color, size: 20.sp),
        ),
        SizedBox(width: 8.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: getTextStyle(
                fontSize: 10.sp,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              DateFormat('MMM dd, yyyy').format(date),
              style: getTextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
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
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w700,
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
    final isBlocked = widget.apartment.blockedDates.any(
      (blocked) =>
          date.year == blocked.year &&
          date.month == blocked.month &&
          date.day == blocked.day,
    );

    // Check if date is in bookings (booked dates are unavailable)
    final isBooked = widget.apartment.bookings.any((booking) {
      // For single-day bookings from API (checkOut is checkIn + 1 day)
      // We need to check if the date matches the checkIn date
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

    final isCheckIn =
        _selectedCheckIn != null &&
        date.year == _selectedCheckIn!.year &&
        date.month == _selectedCheckIn!.month &&
        date.day == _selectedCheckIn!.day;

    final isCheckOut =
        _selectedCheckOut != null &&
        date.year == _selectedCheckOut!.year &&
        date.month == _selectedCheckOut!.month &&
        date.day == _selectedCheckOut!.day;

    final isInRange =
        _selectedCheckIn != null &&
        _selectedCheckOut != null &&
        date.isAfter(_selectedCheckIn!) &&
        date.isBefore(_selectedCheckOut!);

    final isToday =
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;

    final isUnavailable = isPast || isBlocked || isBooked;

    Color? backgroundColor;
    Color? textColor = AppColors.textPrimary;

    if (isUnavailable) {
      backgroundColor = Colors.grey.shade100;
      textColor = Colors.grey.shade400;
    } else if (isCheckIn) {
      backgroundColor = AppColors.primaryBlue.withValues(alpha: .2);
      textColor = AppColors.primaryBlue;
    } else if (isCheckOut) {
      backgroundColor = AppColors.success.withValues(alpha: .2);
      textColor = AppColors.success;
    } else if (isInRange) {
      backgroundColor = AppColors.primaryBlue.withValues(alpha: .12);
    }

    return GestureDetector(
      onTap: isUnavailable
          ? null
          : () {
              setState(() {
                // CASE 1: First selection → Check-in
                if (_selectedCheckIn == null) {
                  _selectedCheckIn = date;
                  return;
                }

                // CASE 2: Second selection → Check-out (must be after check-in)
                if (_selectedCheckOut == null &&
                    date.isAfter(_selectedCheckIn!)) {
                  bool hasBlockedInRange = false;
                  for (
                    var d = _selectedCheckIn!.add(const Duration(days: 1));
                    d.isBefore(date) || d.isAtSameMomentAs(date);
                    d = d.add(const Duration(days: 1))
                  ) {
                    if (widget.apartment.blockedDates.any(
                          (blocked) =>
                              d.year == blocked.year &&
                              d.month == blocked.month &&
                              d.day == blocked.day,
                        ) ||
                        widget.apartment.bookings.any((booking) {
                          // Check if date matches checkIn (for single-day bookings)
                          final isSameDayBooking =
                              d.year == booking.checkInDate.year &&
                              d.month == booking.checkInDate.month &&
                              d.day == booking.checkInDate.day;

                          // Check if date is in booking range
                          final isInBookingRange =
                              (d.isAfter(booking.checkInDate) ||
                                  d.isAtSameMomentAs(booking.checkInDate)) &&
                              d.isBefore(booking.checkOutDate);

                          return isSameDayBooking || isInBookingRange;
                        })) {
                      hasBlockedInRange = true;
                      break;
                    }
                  }

                  if (hasBlockedInRange) {
                    Get.snackbar(
                      AppText.unavailableDates.tr,
                      AppText.unavailableDatesInSelectedRange.tr,
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: AppColors.error,
                      colorText: Colors.white,
                    );
                    return;
                  }

                  final nights = date.difference(_selectedCheckIn!).inDays;
                  if (nights < widget.apartment.minimumStay) {
                    Get.snackbar(
                      AppText.minimumStayRequired.tr,
                      '${AppText.propertyRequiresMinimumStay.tr} ${widget.apartment.minimumStay} ${AppText.night.tr}${widget.apartment.minimumStay > 1 ? AppText.nights.tr : ''}',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: AppColors.error,
                      colorText: Colors.white,
                    );
                    return;
                  }
                  if (nights > widget.apartment.maximumStay) {
                    Get.snackbar(
                      AppText.maximumStayExceeded.tr,
                      '${AppText.propertyAllowsMaximumStay.tr} ${widget.apartment.maximumStay} ${AppText.nights.tr}',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: AppColors.error,
                      colorText: Colors.white,
                    );
                    return;
                  }

                  _selectedCheckOut = date;
                  return;
                }

                // CASE 3: Any other tap → Start new selection
                _selectedCheckIn = date;
                _selectedCheckOut = null;
              });
            },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8.r),
          border: (isCheckIn || isCheckOut)
              ? Border.all(
                  color: isCheckIn ? AppColors.primaryBlue : AppColors.success,
                  width: 2.w,
                )
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          '${date.day}',
          style: getTextStyle(
            fontSize: size > 40 ? 10.sp : 8.sp,
            fontWeight: (isCheckIn || isCheckOut || isToday)
                ? FontWeight.bold
                : FontWeight.normal,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

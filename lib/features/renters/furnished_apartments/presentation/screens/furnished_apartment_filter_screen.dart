import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yannyamba/core/core.dart';
import '../../controllers/furnished_apartment_controller.dart';
import 'package:yannyamba/features/owners/dashboard/presentation/widgets/filter_bottom_sheet.dart';

class FurnishedApartmentFilterScreen extends StatefulWidget {
  FurnishedApartmentFilterScreen({super.key});

  @override
  State<FurnishedApartmentFilterScreen> createState() =>
      _FurnishedApartmentFilterScreenState();
}

class _FurnishedApartmentFilterScreenState
    extends State<FurnishedApartmentFilterScreen> {
  final FurnishedApartmentController controller =
      Get.find<FurnishedApartmentController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) => FilterBottomSheet(renterController: controller),
      );
      // Close this screen after bottom sheet is dismissed
      if (mounted) Get.back();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(backgroundColor: Colors.white);
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        title,
        style: getTextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildCounter({
    required int value,
    required VoidCallback onIncrement,
    required VoidCallback? onDecrement,
  }) {
    return Row(
      children: [
        IconButton(
          onPressed: onDecrement,
          icon: const Icon(Icons.remove_circle_outline),
          color: onDecrement != null ? AppColors.primaryBlue : Colors.grey,
          iconSize: 22.sp,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.backgroundLight,
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Text(
            value.toString(),
            style: getTextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
          ),
        ),
        IconButton(
          onPressed: onIncrement,
          icon: const Icon(Icons.add_circle_outline),
          color: AppColors.primaryBlue,
          iconSize: 22.sp,
        ),
      ],
    );
  }
}

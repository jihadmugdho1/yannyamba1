import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yannyamba/core/core.dart';
import '../../controllers/owner_dashboard_controller.dart';

class FilterBottomSheet extends StatefulWidget {
  final OwnerDashboardController controller;
  const FilterBottomSheet({super.key, required this.controller});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String selectedCategory = 'All';
  String selectedRentalFilter = 'Any';
  final _cityController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  final _advanceController = TextEditingController();
  final _securityController = TextEditingController();
  int? minBedrooms;
  int? minBathrooms;
  RangeValues priceRange = const RangeValues(0, 100000);

  @override
  void dispose() {
    _cityController.dispose();
    _neighborhoodController.dispose();
    _advanceController.dispose();
    _securityController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: Container(
          height: MediaQuery.sizeOf(context).height * 0.92,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
          ),
          child: Column(
            children: [
              SizedBox(height: 8.h),
              Container(
                width: 48.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(999.r),
                ),
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.black),
                    ),
                    Expanded(
                      child: Text(
                        'Filter Properties',
                        textAlign: TextAlign.center,
                        style: getTextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _handleReset,
                      child: Text(
                        'Reset',
                        style: getTextStyle(
                          fontSize: 13.sp,
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Category'),
                      DropdownButtonFormField<String>(
                        value: selectedCategory,
                        items: const [
                          DropdownMenuItem(value: 'All', child: Text('All')),
                          DropdownMenuItem(value: 'Home', child: Text('Home')),
                          DropdownMenuItem(
                            value: 'Office',
                            child: Text('Office'),
                          ),
                        ],
                        onChanged: (v) =>
                            setState(() => selectedCategory = v ?? 'All'),
                        decoration: InputDecoration(
                          hintText: 'Select category',
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 8.h,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      _buildSectionTitle('Rental Type'),
                      DropdownButtonFormField<String>(
                        value: selectedRentalFilter,
                        items: const [
                          DropdownMenuItem(value: 'Any', child: Text('Any')),
                          DropdownMenuItem(
                            value: 'short_time_rental',
                            child: Text('Short time rental'),
                          ),
                          DropdownMenuItem(
                            value: 'long_time_rental',
                            child: Text('Long time rental'),
                          ),
                        ],
                        onChanged: (v) =>
                            setState(() => selectedRentalFilter = v ?? 'Any'),
                        decoration: InputDecoration(
                          hintText: 'Select rental type',
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 8.h,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      _buildSectionTitle('City'),
                      TextField(
                        controller: _cityController,
                        decoration: InputDecoration(
                          hintText: 'Enter city',
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 8.h,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      _buildSectionTitle('Neighborhood'),
                      TextField(
                        controller: _neighborhoodController,
                        decoration: InputDecoration(
                          hintText: 'Enter neighborhood',
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 8.h,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _advanceController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Advance (months)',
                                hintText: '0',
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 8.h,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: TextField(
                              controller: _securityController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Security (months)',
                                hintText: '0',
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 8.h,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Min Bedrooms',
                                hintText: '0',
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 8.h,
                                ),
                              ),
                              onChanged: (v) => minBedrooms = int.tryParse(v),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Min Bathrooms',
                                hintText: '0',
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 8.h,
                                ),
                              ),
                              onChanged: (v) => minBathrooms = int.tryParse(v),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      _buildSectionTitle('Price Range'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            priceRange.start.round().toString(),
                            style: getTextStyle(
                              fontSize: 12.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            priceRange.end.round().toString(),
                            style: getTextStyle(
                              fontSize: 12.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      RangeSlider(
                        values: priceRange,
                        min: 0,
                        max: 100000,
                        divisions: 100,
                        activeColor: AppColors.primaryBlue,
                        labels: RangeLabels(
                          priceRange.start.round().toString(),
                          priceRange.end.round().toString(),
                        ),
                        onChanged: (r) => setState(() => priceRange = r),
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .08),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _handleApply,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        'Apply Filters',
                        style: getTextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleReset() {
    setState(() {
      selectedCategory = 'All';
      selectedRentalFilter = 'Any';
      _cityController.clear();
      _neighborhoodController.clear();
      _advanceController.clear();
      _securityController.clear();
      minBedrooms = null;
      minBathrooms = null;
      priceRange = const RangeValues(0, 100000);
    });
    widget.controller.clearFilters();
    Navigator.pop(context);
  }

  void _handleApply() {
    widget.controller.applyFilters(
      category: selectedCategory == 'All' ? null : selectedCategory,
      city: _cityController.text.isEmpty ? null : _cityController.text,
      minBedrooms: minBedrooms,
      minBathrooms: minBathrooms,
      minPrice: priceRange.start,
      maxPrice: priceRange.end,
      rentalFilter: selectedRentalFilter == 'Any' ? null : selectedRentalFilter,
      advancePayment: _advanceController.text.isEmpty
          ? null
          : _advanceController.text,
      securityDeposit: _securityController.text.isEmpty
          ? null
          : _securityController.text,
      neighborhood: _neighborhoodController.text.isEmpty
          ? null
          : _neighborhoodController.text,
    );
    Navigator.pop(context);
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
}

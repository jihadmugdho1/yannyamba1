import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yannyamba/core/core.dart';
import 'package:yannyamba/core/common/widgets/searchable_multi_select_dropdown.dart';
import 'package:yannyamba/features/owners/add_property/controllers/city_selection_controller.dart';
import 'package:yannyamba/features/renters/furnished_apartments/controllers/furnished_apartment_controller.dart';
import '../../controllers/owner_dashboard_controller.dart';

class FilterBottomSheet extends StatefulWidget {
  final OwnerDashboardController? ownerController;
  final FurnishedApartmentController? renterController;

  const FilterBottomSheet({
    super.key,
    this.ownerController,
    this.renterController,
  }) : assert(
         ownerController != null || renterController != null,
         'Either ownerController or renterController must be provided',
       );

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
  final _minPriceController = TextEditingController();
  final _maxPriceController = TextEditingController();
  int minBedrooms = 0;
  int minBathrooms = 0;
  RangeValues priceRange = const RangeValues(0, 100000);
  List<String> selectedCities = [];
  List<String> selectedNeighborhoods = [];

  @override
  void dispose() {
    _cityController.dispose();
    _neighborhoodController.dispose();
    _advanceController.dispose();
    _securityController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();

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
                      Obx(() {
                        final cityCtrl = Get.find<CitySelectionController>();
                        return SearchableMultiSelectDropdown(
                          key: ValueKey(
                            'owner_city_filter_${selectedCities.length}_${selectedCities.hashCode}',
                          ),
                          selectedItems: selectedCities,
                          allItems: cityCtrl.cities,
                          onToggle: (c) {
                            setState(() {
                              if (selectedCities.contains(c)) {
                                selectedCities.remove(c);
                              } else {
                                selectedCities.add(c);
                              }
                            });
                          },
                          title: 'Cities',
                          placeholder: 'Choose cities',
                        );
                      }),
                      SizedBox(height: 16.h),
                      _buildSectionTitle('Neighborhood'),
                      Builder(
                        builder: (ctx) {
                          final List<String> neighborhoodItems;
                          if (widget.ownerController != null) {
                            neighborhoodItems = widget
                                .ownerController!
                                .properties
                                .map((p) => p.address.street)
                                .where((s) => s.isNotEmpty)
                                .toSet()
                                .toList();
                          } else if (widget.renterController != null) {
                            neighborhoodItems = widget
                                .renterController!
                                .apartments
                                .map((p) => p.address.street)
                                .where((s) => s.isNotEmpty)
                                .toSet()
                                .toList();
                          } else {
                            neighborhoodItems = <String>[];
                          }
                          neighborhoodItems.sort();

                          return SearchableMultiSelectDropdown(
                            key: ValueKey(
                              'owner_neighborhood_filter_${selectedNeighborhoods.length}_${selectedNeighborhoods.hashCode}',
                            ),
                            selectedItems: selectedNeighborhoods,
                            allItems: neighborhoodItems,
                            onToggle: (n) {
                              setState(() {
                                if (selectedNeighborhoods.contains(n)) {
                                  selectedNeighborhoods.remove(n);
                                } else {
                                  selectedNeighborhoods.add(n);
                                }
                              });
                            },
                            title: 'Neighborhoods',
                            placeholder: 'Choose neighborhoods',
                          );
                        },
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionTitle('Min Bedrooms'),
                                _buildCounter(
                                  value: minBedrooms,
                                  onIncrement: () =>
                                      setState(() => minBedrooms++),
                                  onDecrement: () => setState(() {
                                    if (minBedrooms > 0) minBedrooms--;
                                  }),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionTitle('Min Bathrooms'),
                                _buildCounter(
                                  value: minBathrooms,
                                  onIncrement: () =>
                                      setState(() => minBathrooms++),
                                  onDecrement: () => setState(() {
                                    if (minBathrooms > 0) minBathrooms--;
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      _buildSectionTitle('Price Range'),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _minPriceController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Min Price',
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
                              onChanged: (v) {
                                final min =
                                    double.tryParse(v) ?? priceRange.start;
                                setState(
                                  () => priceRange = RangeValues(
                                    min,
                                    priceRange.end,
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: TextField(
                              controller: _maxPriceController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Max Price',
                                hintText: priceRange.end.round().toString(),
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 8.h,
                                ),
                              ),
                              onChanged: (v) {
                                final max =
                                    double.tryParse(v) ?? priceRange.end;
                                setState(
                                  () => priceRange = RangeValues(
                                    priceRange.start,
                                    max,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
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
                        onChanged: (r) => setState(() {
                          priceRange = r;
                          _minPriceController.text = priceRange.start
                              .round()
                              .toString();
                          _maxPriceController.text = priceRange.end
                              .round()
                              .toString();
                        }),
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
      _minPriceController.clear();
      _maxPriceController.clear();
      selectedCities.clear();
      selectedNeighborhoods.clear();
      minBedrooms = 0;
      minBathrooms = 0;
      priceRange = const RangeValues(0, 100000);
    });
    if (widget.ownerController != null) {
      widget.ownerController!.clearFilters();
    } else if (widget.renterController != null) {
      widget.renterController!.resetFilters();
    }
    Navigator.pop(context);
  }

  void _handleApply() {
    if (widget.ownerController != null) {
      const defaultPriceRange = RangeValues(0, 100000);
      final bool isDefaultPriceRange =
          priceRange.start == defaultPriceRange.start &&
          priceRange.end == defaultPriceRange.end;
      widget.ownerController!.applyFilters(
        category: selectedCategory == 'All' ? null : selectedCategory,
        city: selectedCities.isEmpty
            ? (_cityController.text.isEmpty ? null : _cityController.text)
            : selectedCities.join(','),
        minBedrooms: minBedrooms == 0 ? null : minBedrooms,
        minBathrooms: minBathrooms == 0 ? null : minBathrooms,
        minPrice: isDefaultPriceRange ? null : priceRange.start,
        maxPrice: isDefaultPriceRange ? null : priceRange.end,
        rentalFilter: selectedRentalFilter == 'Any'
            ? null
            : selectedRentalFilter,
        advancePayment: _advanceController.text.isEmpty
            ? null
            : _advanceController.text,
        securityDeposit: _securityController.text.isEmpty
            ? null
            : _securityController.text,
        neighborhood: selectedNeighborhoods.isEmpty
            ? (_neighborhoodController.text.isEmpty
                  ? null
                  : _neighborhoodController.text)
            : selectedNeighborhoods.join(','),
      );
    } else if (widget.renterController != null) {
      // Apply filters to furnished apartment controller
      final r = widget.renterController!;
      // Reset renter filters then apply selections
      r.resetFilters();

      // Cities
      for (final c in selectedCities) {
        if (!r.selectedCities.contains(c)) r.toggleCity(c);
      }

      // Neighborhoods
      for (final n in selectedNeighborhoods) {
        if (!r.selectedNeighborhoods.contains(n)) r.toggleNeighborhood(n);
      }

      // Price, rooms, bathrooms
      r.updatePriceRange(priceRange.start, priceRange.end);
      if (minBedrooms > 0) r.updateRooms(minBedrooms);
      if (minBathrooms > 0) r.updateBathrooms(minBathrooms);
    }
    Navigator.pop(context);
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

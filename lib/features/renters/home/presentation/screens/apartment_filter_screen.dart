import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yannyamba/core/core.dart';
import 'package:yannyamba/features/renters/home/controllers/apartment_filter_controller.dart';

class ApartmentFilterScreen extends StatelessWidget {
  const ApartmentFilterScreen({super.key});

  void _applyFilters(BuildContext context) {
    final controller = Get.find<ApartmentFilterController>();
    Navigator.pop(context, controller.getFilterData());
  }

  Widget _section(String title, Widget child) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.textWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                title,
                style: getTextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          child,
        ],
      ),
    );
  }

  Widget _dropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) => onChanged(v!),
        ),
      ),
    );
  }

  Widget _checkboxGroup({
    required List<String> labels,
    required Set<String> selected,
    required Function(String) onToggle,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < labels.length; i += 2)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: _checkbox(labels[i], selected, onToggle)),
              const SizedBox(width: 8),
              Expanded(
                child: i + 1 < labels.length
                    ? _checkbox(labels[i + 1], selected, onToggle)
                    : const SizedBox(),
              ),
            ],
          ),
      ],
    );
  }

  Widget _checkbox(
    String label,
    Set<String> selected,
    Function(String) onToggle,
  ) {
    final isSelected = selected.contains(label);
    return CheckboxListTile(
      title: Text(label, style: getTextStyle(color: AppColors.textColor)),
      value: isSelected,
      onChanged: (v) => onToggle(label),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      dense: true,
      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
      activeColor: Colors.blue,
    );
  }

  Widget _priceInput(double value, bool isMin) {
    final controller = Get.find<ApartmentFilterController>();
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF3F3F5),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: TextField(
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: getTextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            isDense: true,
          ),
          controller: TextEditingController(text: value.round().toString()),
          onChanged: (val) {
            final parsed = double.tryParse(val) ?? value;
            controller.setPriceRange(
              isMin
                  ? RangeValues(parsed, controller.priceRange.end)
                  : RangeValues(controller.priceRange.start, parsed),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Initialize controller if not already initialized
    final controller = Get.put(ApartmentFilterController());
    final systemBottom =
        MediaQuery.of(context).systemGestureInsets.bottom + 4.h;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            controller.resetFilters();
            Navigator.pop(context);
          },
        ),
        title: Text(
          AppText.filterApartments.tr,
          style: getTextStyle(
            color: AppColors.textColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          TextButton(
            onPressed: controller.resetFilters,
            child: Text(
              AppText.clearAll.tr,
              style: getTextStyle(
                color: Colors.red,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: Obx(
        () => Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _section(
                      AppText.propertyType.tr,
                      Column(
                        children: [
                          const SizedBox(height: 8),
                          _dropdown(
                            value: controller.selectedPropertyType,
                            items: [
                              AppText.all.tr,
                              AppText.home.tr,
                              AppText.office.tr,
                            ],
                            onChanged: controller.setPropertyType,
                          ),
                        ],
                      ),
                    ),
                    _section(
                      AppText.priceRange.tr,
                      Column(
                        children: [
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              _priceInput(controller.priceRange.start, true),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  '-',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                              _priceInput(controller.priceRange.end, false),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Center(
                            child: Text(
                              '\$${controller.priceRange.start.round()} - \$${controller.priceRange.end.round()}/${AppText.month.tr}',
                              style: getTextStyle(color: AppColors.textColor2),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _section(
                      AppText.locationDetails.tr,
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              AppText.city.tr,
                              style: getTextStyle(
                                color: AppColors.textColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Obx(
                            () => SearchableSingleSelectDropdown(
                              selectedItem: controller.selectedCity,
                              allItems: controller.availableCities,
                              onChanged: controller.setCity,
                              title: AppText.city.tr,
                              placeholder: AppText.all.tr,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              AppText.neighborhoods.tr,
                              style: getTextStyle(
                                color: AppColors.textColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Obx(() {
                            // Access both observables to trigger rebuild when either changes
                            final selectedCity = controller.selectedCity;
                            final _ = controller.selectedNeighborhoods.length;

                            return SearchableMultiSelectDropdown(
                              key: ValueKey(
                                'neighborhood_filter_$selectedCity',
                              ),
                              selectedItems: controller.selectedNeighborhoods,
                              allItems: controller.availableNeighborhoods,
                              onToggle: controller.toggleNeighborhood,
                              title: AppText.neighborhoods.tr,
                              placeholder: AppText.chooseNeighborhoods.tr,
                            );
                          }),
                        ],
                      ),
                    ),
                    if (controller.selectedPropertyType != 'Office')
                      _section(
                        AppText.bedroomsAndBathrooms.tr,
                        Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(AppText.bedrooms.tr),
                            ),
                            const SizedBox(height: 8),
                            _dropdown(
                              value: controller.selectedBedrooms,
                              items: [
                                AppText.any.tr,
                                AppText.singleRoom.tr,
                                AppText.singleModernRoom.tr,
                                AppText.studio.tr,
                                AppText.oneBedroom.tr,
                                AppText.twoBedrooms.tr,
                                AppText.threePlusBedrooms.tr,
                              ],
                              onChanged: controller.setBedrooms,
                            ),
                            const SizedBox(height: 16),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(AppText.bathrooms.tr),
                            ),
                            const SizedBox(height: 8),
                            _dropdown(
                              value: controller.selectedBathrooms,
                              items: [
                                AppText.any.tr,
                                AppText.one.tr,
                                AppText.two.tr,
                                AppText.three.tr,
                                AppText.fourPlus.tr,
                              ],
                              onChanged: controller.setBathrooms,
                            ),
                          ],
                        ),
                      ),
                    _section(
                      AppText.bikePriceFromMainRoad.tr,
                      _checkboxGroup(
                        labels: ['0', '100', '200', '300 - 500F', '500F+'],
                        selected: controller.selectedBikePrices,
                        onToggle: controller.toggleBikePrice,
                      ),
                    ),
                    _section(
                      AppText.paymentTerms.tr,
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(AppText.advancePaymentMonths.tr),
                          ),
                          const SizedBox(height: 8),
                          _dropdown(
                            value: controller.advancePaymentMonths,
                            items: [
                              AppText.any.tr,
                              AppText.oneMonth.tr,
                              AppText.twoMonths.tr,
                              AppText.threeMonths.tr,
                              AppText.sixMonths.tr,
                              AppText.twelveMonths.tr,
                            ],
                            onChanged: controller.setAdvancePaymentMonths,
                          ),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(AppText.securityDepositMonths.tr),
                          ),
                          const SizedBox(height: 8),
                          _dropdown(
                            value: controller.securityDepositMonths,
                            items: [
                              AppText.any.tr,
                              AppText.oneMonth.tr,
                              AppText.twoMonths.tr,
                              AppText.threeMonths.tr,
                            ],
                            onChanged: controller.setSecurityDepositMonths,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: 4.h,
                left: 4.w,
                right: 4.w,
                bottom: systemBottom > 0 ? systemBottom : 4.h,
              ),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _applyFilters(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF374151),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: const BorderSide(color: Colors.transparent, width: 1),
                ),
                child: Text(
                  AppText.applyFilters.tr,
                  style: getTextStyle(color: AppColors.textWhite, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

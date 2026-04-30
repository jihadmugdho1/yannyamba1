import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yannyamba/core/core.dart';

class SearchableDropdown extends StatelessWidget {
  final String label;
  final String hint;
  final String? value;
  final Function(String?) onChanged;
  final List<String> items;
  final bool isEnabled;
  final bool isLoading;
  final IconData icon;
  final String searchHint;

  const SearchableDropdown({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.onChanged,
    required this.items,
    this.isEnabled = true,
    this.isLoading = false,
    required this.icon,
    required this.searchHint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: AppColors.textColor),
            const SizedBox(width: 8),
            Text(
              label,
              style: getTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: isEnabled && !isLoading && items.isNotEmpty
              ? () => _showSearchableDialog(
                  label: label,
                  searchHint: searchHint,
                  items: items,
                  currentValue: value,
                  onChanged: onChanged,
                  icon: icon,
                )
              : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isEnabled
                  ? const Color(0xFFF9FAFB)
                  : const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isEnabled
                    ? const Color(0xFFE5E7EB)
                    : const Color(0xFFD1D5DB),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    value ?? hint,
                    style: getTextStyle(
                      color: value != null
                          ? AppColors.textColor
                          : AppColors.textColor2,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(
                        Icons.search,
                        color: isEnabled
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFFD1D5DB),
                        size: 20,
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showSearchableDialog({
    required String label,
    required String searchHint,
    required List<String> items,
    required String? currentValue,
    required Function(String?) onChanged,
    required IconData icon,
  }) {
    final searchController = TextEditingController();
    final filteredItems = items.obs;
    final showClearButton = false.obs;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 600, maxWidth: 500),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFF2196F3),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(icon, color: Colors.white, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Select $label',
                        style: getTextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Get.back(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: searchController,
                  autofocus: true,
                  onChanged: (value) {
                    showClearButton.value = value.isNotEmpty;
                    if (value.isEmpty) {
                      filteredItems.value = items;
                    } else {
                      filteredItems.value = items
                          .where(
                            (item) => item.toLowerCase().contains(
                              value.toLowerCase(),
                            ),
                          )
                          .toList();
                    }
                  },
                  decoration: InputDecoration(
                    hintText: searchHint,
                    hintStyle: getTextStyle(
                      color: AppColors.textColor2,
                      fontSize: 14,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFF9CA3AF),
                    ),
                    suffixIcon: Obx(
                      () => showClearButton.value
                          ? IconButton(
                              icon: const Icon(
                                Icons.clear,
                                color: Color(0xFF9CA3AF),
                              ),
                              onPressed: () {
                                searchController.clear();
                                showClearButton.value = false;
                                filteredItems.value = items;
                              },
                            )
                          : const SizedBox.shrink(),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF9FAFB),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xFF2196F3),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              // Items Count
              Obx(
                () => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(
                        '${filteredItems.length} ${filteredItems.length == 1 ? 'result' : 'results'}',
                        style: getTextStyle(
                          fontSize: 12,
                          color: AppColors.textColor2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Divider(height: 1, color: Color(0xFFE5E7EB)),
              // List of items
              Expanded(
                child: Obx(
                  () => filteredItems.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(40),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 48,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No results found',
                                  style: getTextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textColor2,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Try a different search term',
                                  style: getTextStyle(
                                    fontSize: 14,
                                    color: AppColors.textColor2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredItems.length,
                          itemBuilder: (context, index) {
                            final item = filteredItems[index];
                            final isSelected = item == currentValue;
                            return InkWell(
                              onTap: () {
                                onChanged(item);
                                Get.back();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(
                                          0xFF2196F3,
                                        ).withValues(alpha: 0.1)
                                      : Colors.transparent,
                                  border: Border(
                                    bottom: BorderSide(
                                      color: const Color(
                                        0xFFE5E7EB,
                                      ).withValues(alpha: 0.5),
                                      width: 0.5,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    if (isSelected)
                                      const Icon(
                                        Icons.check_circle,
                                        color: Color(0xFF2196F3),
                                        size: 20,
                                      )
                                    else
                                      const Icon(
                                        Icons.radio_button_unchecked,
                                        color: Color(0xFFD1D5DB),
                                        size: 20,
                                      ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        item,
                                        style: getTextStyle(
                                          fontSize: 14,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                          color: isSelected
                                              ? const Color(0xFF2196F3)
                                              : AppColors.textColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

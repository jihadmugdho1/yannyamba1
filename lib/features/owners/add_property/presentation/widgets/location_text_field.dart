import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yannyamba/core/core.dart';

class LocationTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController textController;
  final Function(String) onChanged;
  final int maxLines;
  final List<String>? items;
  final bool isLoading;
  final bool isEnabled;
  final String searchHint;
  final String? errorText;
  final VoidCallback? onRetry;

  const LocationTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.textController,
    required this.onChanged,
    this.maxLines = 1,
    this.items,
    this.isLoading = false,
    this.isEnabled = true,
    this.searchHint = 'Search...',
    this.errorText,
    this.onRetry,
  });

  bool get _isSelectable => items != null;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: getTextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: textController,
          onChanged: _isSelectable ? null : onChanged,
          readOnly: _isSelectable,
          maxLines: maxLines,
          onTap: _isSelectable && isEnabled && !isLoading && items!.isNotEmpty
              ? () => _showSearchableDialog()
              : null,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: getTextStyle(color: AppColors.textColor2, fontSize: 12),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
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
                width: 1.5,
              ),
            ),
            suffixIcon: _isSelectable
                ? isLoading
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : const Icon(Icons.search, color: Color(0xFF9CA3AF))
                : null,
          ),
        ),
        if ((errorText ?? '').isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    errorText!,
                    style: getTextStyle(fontSize: 12, color: Colors.red),
                  ),
                ),
                if (onRetry != null)
                  TextButton(onPressed: onRetry, child: const Text('Retry')),
              ],
            ),
          ),
      ],
    );
  }

  void _showSearchableDialog() {
    final allItems = items ?? const <String>[];
    final searchController = TextEditingController();
    final filteredItems = allItems.obs;
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
                    const Icon(Icons.place, color: Colors.white, size: 24),
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
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: searchController,
                  autofocus: true,
                  onChanged: (value) {
                    showClearButton.value = value.isNotEmpty;
                    if (value.isEmpty) {
                      filteredItems.value = allItems;
                    } else {
                      filteredItems.value = allItems
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
                                filteredItems.value = allItems;
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
              Expanded(
                child: Obx(
                  () => filteredItems.isEmpty
                      ? Center(
                          child: Text(
                            'No results found',
                            style: getTextStyle(
                              fontSize: 14,
                              color: AppColors.textColor2,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredItems.length,
                          itemBuilder: (context, index) {
                            final item = filteredItems[index];
                            final isSelected = textController.text == item;

                            return InkWell(
                              onTap: () {
                                textController.text = item;
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
                                    Icon(
                                      isSelected
                                          ? Icons.check_circle
                                          : Icons.radio_button_unchecked,
                                      color: isSelected
                                          ? const Color(0xFF2196F3)
                                          : const Color(0xFFD1D5DB),
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

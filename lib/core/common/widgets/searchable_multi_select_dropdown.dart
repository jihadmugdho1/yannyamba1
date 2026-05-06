import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:yannyamba/core/core.dart';

class SearchableMultiSelectDropdown extends StatefulWidget {
  final dynamic selectedItems; // Can be Set<String> or List<String>
  final List<String> allItems;
  final Function(String) onToggle;
  final String title;
  final String placeholder;

  const SearchableMultiSelectDropdown({
    super.key,
    required this.selectedItems,
    required this.allItems,
    required this.onToggle,
    required this.title,
    this.placeholder = 'Choose items',
  });

  @override
  State<SearchableMultiSelectDropdown> createState() =>
      _SearchableMultiSelectDropdownState();
}

class _SearchableMultiSelectDropdownState
    extends State<SearchableMultiSelectDropdown> {
  // Helper to get selected items as a list
  List<String> get _selectedList {
    if (widget.selectedItems is Set<String>) {
      return (widget.selectedItems as Set<String>).toList();
    } else if (widget.selectedItems is List<String>) {
      return widget.selectedItems as List<String>;
    }
    return [];
  }

  // Helper to check if an item is selected
  bool _isSelected(String item) {
    if (widget.selectedItems is Set<String>) {
      return (widget.selectedItems as Set<String>).contains(item);
    } else if (widget.selectedItems is List<String>) {
      return (widget.selectedItems as List<String>).contains(item);
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(SearchableMultiSelectDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Rebuild when selectedItems changes
    if (oldWidget.selectedItems != widget.selectedItems) {
      setState(() {
        // This will trigger a rebuild with the new selectedItems
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showSelectionDialog(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F3F5),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                _selectedList.isEmpty
                    ? widget.placeholder
                    : _selectedList.length == 1
                    ? _selectedList.first
                    : '${_selectedList.length} ${widget.title.toLowerCase()} selected',
                style: getTextStyle(
                  color: _selectedList.isEmpty
                      ? Colors.grey.shade600
                      : AppColors.textColor,
                  fontSize: 8.sp,
                ),
              ),
            ),
            Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
          ],
        ),
      ),
    );
  }

  Future<void> _showSelectionDialog() async {
    final searchController = TextEditingController();
    var filteredItems = List<String>.from(widget.allItems);

    void applyFilter(void Function(void Function()) setModalState) {
      final query = searchController.text.trim().toLowerCase();
      setModalState(() {
        if (query.isEmpty) {
          filteredItems = List<String>.from(widget.allItems);
        } else {
          filteredItems = widget.allItems
              .where((item) => item.toLowerCase().contains(query))
              .toList();
        }
      });
    }

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.fromLTRB(
                20.w,
                20.w,
                20.w,
                20.w + MediaQuery.viewInsetsOf(context).bottom,
              ),
              height: MediaQuery.of(context).size.height * 0.7,
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Select ${widget.title}',
                          style: getTextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    // Search field
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search ${widget.title.toLowerCase()}...',
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey.shade600,
                        ),
                        suffixIcon: searchController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: Colors.grey.shade600,
                                ),
                                onPressed: () {
                                  setModalState(() {
                                    searchController.clear();
                                  });
                                  applyFilter(setModalState);
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: const Color(0xFFF3F3F5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                      ),
                      onChanged: (value) {
                        applyFilter(setModalState);
                      },
                    ),
                    SizedBox(height: 16.h),

                    // Selected count
                    if (_selectedList.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: Text(
                          '${_selectedList.length} selected',
                          style: getTextStyle(
                            fontSize: 8.sp,
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                    // List of items
                    Expanded(
                      child: filteredItems.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    size: 48.sp,
                                    color: Colors.grey.shade400,
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    'No ${widget.title.toLowerCase()} found',
                                    style: getTextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: filteredItems.length,
                              itemBuilder: (context, index) {
                                final item = filteredItems[index];
                                final isSelected = _isSelected(item);
                                return CheckboxListTile(
                                  title: Text(
                                    item,
                                    style: getTextStyle(fontSize: 10.sp),
                                  ),
                                  value: isSelected,
                                  onChanged: (bool? value) {
                                    widget.onToggle(item);
                                    // keep modal state in sync (checkbox)
                                    setModalState(() {});
                                    if (mounted) setState(() {});
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  activeColor: AppColors.primaryBlue,
                                );
                              },
                            ),
                    ),
                    SizedBox(height: 16.h),

                    // Done button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          AppText.done.tr,
                          style: getTextStyle(
                            color: Colors.white,
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    searchController.dispose();
    if (mounted) setState(() {});
  }
}

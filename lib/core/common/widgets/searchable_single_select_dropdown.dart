import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yannyamba/core/core.dart';

class SearchableSingleSelectDropdown extends StatefulWidget {
  final String selectedItem;
  final List<String> allItems;
  final Function(String) onChanged;
  final String title;
  final String placeholder;

  const SearchableSingleSelectDropdown({
    super.key,
    required this.selectedItem,
    required this.allItems,
    required this.onChanged,
    required this.title,
    this.placeholder = 'Select an item',
  });

  @override
  State<SearchableSingleSelectDropdown> createState() =>
      _SearchableSingleSelectDropdownState();
}

class _SearchableSingleSelectDropdownState
    extends State<SearchableSingleSelectDropdown> {
  late TextEditingController _searchController;
  late List<String> _filteredItems;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredItems = List.from(widget.allItems);
    _searchController.addListener(_filterItems);
  }

  @override
  void didUpdateWidget(SearchableSingleSelectDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Rebuild when selectedItem changes
    if (oldWidget.selectedItem != widget.selectedItem) {
      setState(() {
        // This will trigger a rebuild with the new selectedItem
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterItems() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredItems = List.from(widget.allItems);
      } else {
        _filteredItems = widget.allItems
            .where((item) => item.toLowerCase().contains(query))
            .toList();
      }
    });
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
                widget.selectedItem.isEmpty
                    ? widget.placeholder
                    : widget.selectedItem,
                style: getTextStyle(
                  color: widget.selectedItem.isEmpty
                      ? Colors.grey.shade600
                      : AppColors.textColor,
                  fontSize: 10.sp,
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
    // Reset search when opening
    _searchController.clear();
    _filteredItems = List.from(widget.allItems);

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
              padding: EdgeInsets.all(20.w),
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
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search ${widget.title.toLowerCase()}...',
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey.shade600,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: Colors.grey.shade600,
                                ),
                                onPressed: () {
                                  setModalState(() {
                                    _searchController.clear();
                                  });
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
                        setModalState(() {
                          _filterItems();
                        });
                      },
                    ),
                    SizedBox(height: 16.h),

                    // Current selection indicator
                    if (widget.selectedItem.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: Text(
                          'Current: ${widget.selectedItem}',
                          style: getTextStyle(
                            fontSize: 8.sp,
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                    // List of items
                    Expanded(
                      child: _filteredItems.isEmpty
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
                              itemCount: _filteredItems.length,
                              itemBuilder: (context, index) {
                                final item = _filteredItems[index];
                                final isSelected = item == widget.selectedItem;
                                return RadioListTile<String>(
                                  title: Text(
                                    item,
                                    style: getTextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                    ),
                                  ),
                                  value: item,
                                  groupValue: widget.selectedItem,
                                  onChanged: (String? value) {
                                    if (value != null) {
                                      widget.onChanged(value);
                                      Navigator.pop(context);
                                    }
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.trailing,
                                  activeColor: AppColors.primaryBlue,
                                );
                              },
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
  }
}

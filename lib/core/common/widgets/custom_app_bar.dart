// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import '../../core.dart';

// class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final String title;
//   final String? profileImageUrl;
//   final VoidCallback? onBackTap;
//   final VoidCallback? onFilterTap;
//   final TextEditingController? searchController;
//   final bool showBackButton;
//   final bool showSearch;
//   final bool showFilter;
//   final bool showProfile;
//   final bool centerTitle;

//   const CustomAppBar({
//     super.key,
//     required this.title,
//     this.profileImageUrl,
//     this.onBackTap,
//     this.onFilterTap,
//     this.searchController,
//     this.showBackButton = false,
//     this.showSearch = false,
//     this.showFilter = false,
//     this.showProfile = false,
//     this.centerTitle = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final double inputHeight = 34.h;
//     final double profileSize = 26.w;

//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
//       decoration: const BoxDecoration(
//         color: AppColors.appBarColor,
//         borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
//         border: Border(
//           bottom: BorderSide(color: AppColors.textWhite, width: 1),
//         ),
//       ),
//       child: SafeArea(
//         bottom: false,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 if (showBackButton)
//                   InkWell(
//                     onTap: onBackTap ?? () => Navigator.pop(context),
//                     borderRadius: BorderRadius.circular(16.r),
//                     child: Padding(
//                       padding: EdgeInsets.all(3.w),
//                       child: Icon(
//                         Icons.arrow_back,
//                         size: 18.sp,
//                         color: AppColors.textWhite,
//                       ),
//                     ),
//                   ),
//                 if (showProfile) ...[
//                   SizedBox(width: 4.w),
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(6.r),
//                     child: profileImageUrl != null
//                         ? (profileImageUrl!.startsWith('http')
//                               ? Image.network(
//                                   profileImageUrl!,
//                                   width: profileSize,
//                                   height: profileSize,
//                                   fit: BoxFit.cover,
//                                 )
//                               : Image.asset(
//                                   profileImageUrl!,
//                                   width: profileSize,
//                                   height: profileSize,
//                                   fit: BoxFit.cover,
//                                 ))
//                         : Container(
//                             width: profileSize,
//                             height: profileSize,
//                             color: Colors.grey.shade300,
//                             child: Icon(
//                               Icons.person,
//                               color: Colors.black54,
//                               size: 14.sp,
//                             ),
//                           ),
//                   ),
//                   SizedBox(width: 4.w),
//                 ],
//                 Expanded(
//                   child: Align(
//                     alignment: centerTitle
//                         ? Alignment.center
//                         : Alignment.centerLeft,
//                     child: Text(
//                       title,
//                       style: getTextStyle(
//                         color: AppColors.textWhite,
//                         fontSize: 16,
//                         font: AppFont.supreme,
//                         fontWeight: FontWeight.w500,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ),
//                 if (centerTitle)
//                   SizedBox(width: showBackButton || showProfile ? 36.w : 0),
//               ],
//             ),
//             if (showSearch) SizedBox(height: 8.h),
//             if (showSearch)
//               Row(
//                 children: [
//                   Expanded(
//                     child: SizedBox(
//                       height: inputHeight,
//                       child: TextField(
//                         controller: searchController,
//                         decoration: InputDecoration(
//                           hintText: "Search in state, city, region...",
//                           hintStyle: getTextStyle(
//                             color: AppColors.hintColor,
//                             fontSize: 12,
//                           ),
//                           filled: true,
//                           fillColor: AppColors.textWhite,
//                           contentPadding: EdgeInsets.symmetric(
//                             vertical: 6.h,
//                             horizontal: 10.w,
//                           ),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10.r),
//                             borderSide: BorderSide.none,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   if (showFilter) SizedBox(width: 6.w),
//                   if (showFilter)
//                     InkWell(
//                       onTap: onFilterTap,
//                       borderRadius: BorderRadius.circular(10.r),
//                       child: Container(
//                         height: inputHeight,
//                         padding: EdgeInsets.symmetric(horizontal: 10.w),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10.r),
//                           border: Border.all(
//                             color: AppColors.textWhite,
//                             width: 1,
//                           ),
//                         ),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Icon(
//                               Icons.filter_list,
//                               size: 18.sp,
//                               color: AppColors.textWhite,
//                             ),
//                             SizedBox(width: 3.w),
//                             Text(
//                               "Filter",
//                               style: getTextStyle(
//                                 fontSize: 12.sp,
//                                 fontWeight: FontWeight.w500,
//                                 color: AppColors.textWhite,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Size get preferredSize {
//     const baseContentHeight = 40.0;
//     final basePadding = 14.0;
//     final baseHeight =
//         baseContentHeight * (ScreenUtil().scaleHeight) + basePadding;
//     final searchRowHeight = showSearch ? (34.h + 8.h) : 0.0;
//     return Size.fromHeight(baseHeight + searchRowHeight);
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:smart_restart/smart_restart.dart';

import '../../core.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? profileImageUrl;
  final VoidCallback? onBackTap;
  final VoidCallback? onFilterTap;
  final VoidCallback? onRestartTap; // <-- new
  final VoidCallback? onSearchTap;
  final TextEditingController? searchController;
  final FocusNode? searchFocusNode;
  final bool showBackButton;
  final bool showSearch;
  final bool showFilter;
  final bool showProfile;
  final bool centerTitle;
  final bool showRestartButton; // <-- new

  const CustomAppBar({
    super.key,
    required this.title,
    this.profileImageUrl,
    this.onBackTap,
    this.onFilterTap,
    this.onRestartTap, // <-- new
    this.onSearchTap,
    this.searchController,
    this.searchFocusNode,
    this.showBackButton = false,
    this.showSearch = false,
    this.showFilter = false,
    this.showProfile = false,
    this.centerTitle = false,
    this.showRestartButton = false, // <-- new
  });

  @override
  Widget build(BuildContext context) {
    final double inputHeight = 34.h;
    final double profileSize = 26.w;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: const BoxDecoration(
        color: AppColors.appBarColor,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        border: Border(
          bottom: BorderSide(color: AppColors.textWhite, width: 1),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (showBackButton)
                  InkWell(
                    onTap: onBackTap ?? () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(16.r),
                    child: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: Icon(
                        Icons.arrow_back,
                        size: 18.sp,
                        color: AppColors.textWhite,
                      ),
                    ),
                  ),
                if (showProfile) ...[
                  SizedBox(width: 4.w),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6.r),
                    child: profileImageUrl != null
                        ? (profileImageUrl!.startsWith('http')
                              ? Image.network(
                                  profileImageUrl!,
                                  width: profileSize,
                                  height: profileSize,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  profileImageUrl!,
                                  width: profileSize,
                                  height: profileSize,
                                  fit: BoxFit.cover,
                                ))
                        : Container(
                            width: profileSize,
                            height: profileSize,
                            color: Colors.grey.shade300,
                            child: Icon(
                              Icons.person,
                              color: Colors.black54,
                              size: 14.sp,
                            ),
                          ),
                  ),
                  SizedBox(width: 4.w),
                ],
                Expanded(
                  child: Align(
                    alignment: centerTitle
                        ? Alignment.center
                        : Alignment.centerLeft,
                    child: Text(
                      title,
                      style: getTextStyle(
                        color: AppColors.textWhite,
                        fontSize: 16,
                        font: AppFont.supreme,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                if (showRestartButton) // <-- new
                  InkWell(
                    onTap: () {
                      SmartRestart.restart();
                    },
                    borderRadius: BorderRadius.circular(16.r),
                    child: Padding(
                      padding: EdgeInsets.all(6.w),
                      child: Icon(
                        Icons.refresh, // restart icon
                        size: 20.sp,
                        color: AppColors.textWhite,
                      ),
                    ),
                  ),
                if (centerTitle)
                  SizedBox(width: showBackButton || showProfile ? 36.w : 0),
              ],
            ),
            if (showSearch) SizedBox(height: 8.h),
            if (showSearch)
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: onSearchTap,
                      child: Container(
                        height: inputHeight,
                        padding: EdgeInsets.symmetric(
                          vertical: 6.h,
                          horizontal: 10.w,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.textWhite,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                AppText.selectCity.tr,
                                style: getTextStyle(
                                  color: AppColors.hintColor,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: AppColors.hintColor,
                              size: 20.sp,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (showFilter) SizedBox(width: 6.w),
                  if (showFilter)
                    InkWell(
                      onTap: onFilterTap,
                      borderRadius: BorderRadius.circular(10.r),
                      child: Container(
                        height: inputHeight,
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: AppColors.textWhite,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.filter_list,
                              size: 18.sp,
                              color: AppColors.textWhite,
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              AppText.filter.tr,
                              style: getTextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textWhite,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize {
    const baseContentHeight = 40.0;
    final basePadding = 14.0;
    final baseHeight =
        baseContentHeight * (ScreenUtil().scaleHeight) + basePadding;
    final searchRowHeight = showSearch ? (34.h + 8.h) : 0.0;
    return Size.fromHeight(baseHeight + searchRowHeight);
  }
}

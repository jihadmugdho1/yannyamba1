import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yannyamba/core/core.dart';

import 'package:dotted_border/dotted_border.dart';

class PropertyPhotoUploadArea extends StatelessWidget {
  const PropertyPhotoUploadArea({super.key, required this.onChoosePhotos});

  final VoidCallback onChoosePhotos;

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        color: const Color(0xFFE5E7EB),
        strokeWidth: 2,
        radius: Radius.circular(12.r),
        dashPattern: const [8, 4],
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        color: const Color(0xFFF9FAFB),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              child: Image.asset(
                ImagePath.uploadIcon,
                width: 24.w,
                height: 24.h,
              ),
            ),
            Text(
              'Upload photos of your property',
              style: getTextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor,
              ),
            ),
            SizedBox(height: 24.h),
            OutlinedButton.icon(
              onPressed: onChoosePhotos,
              icon: Icon(Iconsax.gallery_add, size: 20.sp),
              label: Text(
                'Choose Photos',
                style: getTextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor2,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                side: const BorderSide(color: Color(0xFFD1D5DB)),
                foregroundColor: AppColors.textColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PropertyPhotosGrid extends StatelessWidget {
  const PropertyPhotosGrid({
    super.key,
    required this.photos,
    required this.onRemove,
  });

  final List<String> photos;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.file(
                  File(photos[index]),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
            Positioned(
              top: 6.w,
              right: 6.w,
              child: GestureDetector(
                onTap: () => onRemove(index),
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Icon(Icons.close, size: 14.sp, color: Colors.white),
                ),
              ),
            ),
            if (index == 0)
              Positioned(
                bottom: 6.w,
                left: 6.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    'Main',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: 'Supreme',
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

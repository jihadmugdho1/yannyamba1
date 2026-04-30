import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yannyamba/core/core.dart';

Widget buildTextField({
  required String label,
  required String hint,
  required Function(String) onChanged,
  TextInputType? keyboardType,
  List<TextInputFormatter>? inputFormatters,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: getTextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textColor,
        ),
      ),
      SizedBox(height: 8.h),
      TextField(
        onChanged: onChanged,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        style: getTextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.textColor,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: getTextStyle(
            color: const Color(0xFF9CA3AF),
            fontSize: 10.sp,
            fontWeight: FontWeight.w400,
          ),
          filled: true,
          fillColor: const Color(0xFFF9FAFB),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 1.5),
          ),
        ),
      ),
    ],
  );
}

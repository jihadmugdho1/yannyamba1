import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

enum AppFont { montserrat, supreme }

TextStyle getTextStyle({
  double fontSize = 14.0,
  FontWeight fontWeight = FontWeight.w400,
  Color color = Colors.black,
  AppFont font = AppFont.montserrat,
}) {
  late TextStyle base;

  switch (font) {
    case AppFont.montserrat:
      base = GoogleFonts.montserrat();
      break;
    case AppFont.supreme:
      base = const TextStyle(fontFamily: 'Supreme');
      break;
  }

  return base.copyWith(
    fontSize: fontSize.sp,
    fontWeight: fontWeight,
    color: color,
  );
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class TextStyles {
  // 제목용 (Bold)
  static TextStyle titleLarge = GoogleFonts.notoSansKr(
      fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textBlack
  );

  static TextStyle titleMedium = GoogleFonts.notoSansKr(
      fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textBlack
  );

  // 본문용 (Regular)
  static TextStyle bodyMedium = GoogleFonts.notoSansKr(
      fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textBlack
  );

  static TextStyle bodySmall = GoogleFonts.notoSansKr(
      fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textGrey
  );
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

abstract final class AppTextStyles {
  static TextStyle display([double size = 38]) => GoogleFonts.playfairDisplay(
      fontSize: size, color: AppColors.forest, height: 1.2);
  static TextStyle title([double size = 25]) => GoogleFonts.playfairDisplay(
      fontSize: size, color: AppColors.forest, height: 1.25);
  static TextStyle body([double size = 14]) => GoogleFonts.inter(
      fontSize: size, color: AppColors.ink, height: 1.45);
  static TextStyle muted([double size = 13]) => GoogleFonts.inter(
      fontSize: size, color: AppColors.plum, height: 1.45);
  static TextStyle label([double size = 12]) => GoogleFonts.inter(
      fontSize: size, color: AppColors.sage, fontWeight: FontWeight.w600, height: 1.3);
}

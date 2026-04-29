// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Backgrounds
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF7F7F5);

  // Text
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF8A8A8A);

  // Borders
  static const Color border = Color(0xFFE0E0DC);

  // Accent — teal green
  static const Color accent = Color(0xFF1D9E75);
  static const Color accentLight = Color(0xFFE8F5F0);

  // Warning — red
  static const Color warning = Color(0xFFE84C4C);
  static const Color warningBg = Color(0xFFFEF0F0);

  // Reminder — amber
  static const Color amber = Color(0xFFF5A623);
  static const Color amberBg = Color(0xFFFFF8EC);

  // OCR confidence
  static const Color ocrLowConfBg = Color(0xFFFFFBEA);

  // Category badge colors
  static const Color catFoodBg = Color(0xFFE8F5F0);
  static const Color catFoodText = Color(0xFF1D9E75);
  static const Color catElecBg = Color(0xFFE8F0FB);
  static const Color catElecText = Color(0xFF1D5A9E);
  static const Color catHealthBg = Color(0xFFF5E8F5);
  static const Color catHealthText = Color(0xFF7A1D9E);
  static const Color catTransBg = Color(0xFFFFF8EC);
  static const Color catTransText = Color(0xFF9E6A1D);
  static const Color catOtherBg = Color(0xFFF2F2F0);
  static const Color catOtherText = Color(0xFF5A5A5A);

  // Shimmer
  static const Color shimmerBase = Color(0xFFEEEEEE);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
}

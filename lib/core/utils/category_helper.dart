// lib/core/utils/category_helper.dart
import 'package:flutter/material.dart';
import 'package:strukku/core/models/receipt_model.dart';
import 'package:strukku/core/theme/app_colors.dart';

class CategoryHelper {
  static Color getBgColor(ReceiptCategory category) {
    switch (category) {
      case ReceiptCategory.makanan:
        return AppColors.catFoodBg;
      case ReceiptCategory.elektronik:
        return AppColors.catElecBg;
      case ReceiptCategory.kesehatan:
        return AppColors.catHealthBg;
      case ReceiptCategory.transportasi:
        return AppColors.catTransBg;
      case ReceiptCategory.lainnya:
        return AppColors.catOtherBg;
    }
  }

  static Color getTextColor(ReceiptCategory category) {
    switch (category) {
      case ReceiptCategory.makanan:
        return AppColors.catFoodText;
      case ReceiptCategory.elektronik:
        return AppColors.catElecText;
      case ReceiptCategory.kesehatan:
        return AppColors.catHealthText;
      case ReceiptCategory.transportasi:
        return AppColors.catTransText;
      case ReceiptCategory.lainnya:
        return AppColors.catOtherText;
    }
  }

  static IconData getIcon(ReceiptCategory category) {
    switch (category) {
      case ReceiptCategory.makanan:
        return Icons.restaurant_outlined;
      case ReceiptCategory.elektronik:
        return Icons.devices_outlined;
      case ReceiptCategory.kesehatan:
        return Icons.favorite_border_outlined;
      case ReceiptCategory.transportasi:
        return Icons.directions_car_outlined;
      case ReceiptCategory.lainnya:
        return Icons.category_outlined;
    }
  }

  // BUG FIX: Parameter changed from int (index) → ReceiptCategory
  // The analytics screen was passing e.key which is a ReceiptCategory, not an int.
  static Color getChartColor(ReceiptCategory category) {
    const colors = [
      Color(0xFF1D9E75),
      Color(0xFF1D5A9E),
      Color(0xFF7A1D9E),
      Color(0xFFF5A623),
      Color(0xFFE84C4C),
    ];
    return colors[category.index % colors.length];
  }
}

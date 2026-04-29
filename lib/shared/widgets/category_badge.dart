// lib/shared/widgets/category_badge.dart
import 'package:flutter/material.dart';
import '../../core/models/receipt_model.dart';
import '../../core/utils/category_helper.dart';

class CategoryBadge extends StatelessWidget {
  final ReceiptCategory category;
  final double fontSize;

  const CategoryBadge({
    super.key,
    required this.category,
    this.fontSize = 11,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: CategoryHelper.getBgColor(category),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        category.label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
          color: CategoryHelper.getTextColor(category),
        ),
      ),
    );
  }
}

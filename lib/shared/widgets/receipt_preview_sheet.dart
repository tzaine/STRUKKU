// lib/shared/widgets/receipt_preview_sheet.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:strukku/core/models/receipt_model.dart';
import 'package:strukku/core/theme/app_colors.dart';
import 'package:strukku/core/theme/app_typography.dart';
import 'package:strukku/core/utils/currency_formatter.dart';
import 'package:strukku/core/utils/date_formatter.dart';
import 'package:strukku/shared/widgets/category_badge.dart';
import 'package:strukku/shared/widgets/reminder_badge.dart';

/// READ-ONLY preview of a receipt — shown on long-press of a ReceiptCard.
class ReceiptPreviewSheet extends StatelessWidget {
  final ReceiptModel receipt;

  const ReceiptPreviewSheet({super.key, required this.receipt});

  @override
  Widget build(BuildContext context) {
    const maxItems = 5;
    final visibleItems = receipt.items.take(maxItems).toList();
    final remaining = receipt.items.length - maxItems;

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 24),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ─── Handle bar ────────────────────────────────────────────────
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── Photo ──────────────────────────────────────────────
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: receipt.photoPath != null
                      ? Image.file(
                          File(receipt.photoPath!),
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _photoPlaceholder(),
                        )
                      : _photoPlaceholder(),
                ),
                const SizedBox(height: 16),

                // ─── Store name ─────────────────────────────────────────
                Text(
                  receipt.storeName,
                  style: AppTypography.storeName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                // ─── Date ───────────────────────────────────────────────
                Text(
                  DateFormatter.format(receipt.date),
                  style: AppTypography.body
                      .copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 12),

                // ─── Total + Category ───────────────────────────────────
                Row(
                  children: [
                    Text(
                      CurrencyFormatter.format(receipt.totalAmount),
                      style: AppTypography.totalAmount,
                    ),
                    const SizedBox(width: 12),
                    CategoryBadge(category: receipt.category),
                  ],
                ),

                // ─── Reminder chip ──────────────────────────────────────
                if (receipt.hasReminder && receipt.reminderDate != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.alarm_outlined,
                          color: AppColors.amber, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        '${receipt.reminderType?.label ?? "Reminder"} | ${DateFormatter.formatReminderCountdown(receipt.reminderDate!)}',
                        style: AppTypography.caption
                            .copyWith(color: AppColors.amber),
                      ),
                    ],
                  ),
                ],

                // ─── Items ──────────────────────────────────────────────
                if (visibleItems.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Divider(height: 0, color: AppColors.border),
                  const SizedBox(height: 12),
                  ...visibleItems.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.name,
                                style: AppTypography.body,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              CurrencyFormatter.format(item.price),
                              style: AppTypography.bodyBold,
                            ),
                          ],
                        ),
                      )),
                  if (remaining > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        '+ $remaining item lainnya',
                        style: AppTypography.caption
                            .copyWith(color: AppColors.accent),
                      ),
                    ),
                ],

                const SizedBox(height: 20),
                const Divider(height: 0, color: AppColors.border),
                const SizedBox(height: 16),

                // ─── Action buttons ─────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.go('/home/detail/${receipt.id}');
                    },
                    child: const Text('Lihat Detail Lengkap'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                    ),
                    child: const Text('Tutup'),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _photoPlaceholder() {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Icon(Icons.receipt_long_outlined,
            size: 40, color: AppColors.textSecondary),
      ),
    );
  }
}

// lib/shared/widgets/receipt_card_widget.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:strukku/core/models/receipt_model.dart';
import 'package:strukku/core/theme/app_colors.dart';
import 'package:strukku/core/theme/app_typography.dart';
import 'package:strukku/core/utils/currency_formatter.dart';
import 'package:strukku/core/utils/date_formatter.dart';
import 'package:strukku/shared/widgets/category_badge.dart';
import 'package:strukku/shared/widgets/reminder_badge.dart';

class ReceiptCardWidget extends StatelessWidget {
  final ReceiptModel receipt;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final VoidCallback? onExport;

  const ReceiptCardWidget({
    super.key,
    required this.receipt,
    this.onTap,
    this.onDelete,
    this.onEdit,
    this.onExport,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('receipt_${receipt.id}'),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => _confirmDelete(context),
      background: _swipeBackground(),
      child: GestureDetector(
        onTap: onTap,
        onLongPress: () => _showContextMenu(context),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border, width: 0.5),
          ),
          child: Row(
            children: [
              // ─── Thumbnail ───────────────────────────────────────────────
              _buildThumbnail(),
              const SizedBox(width: 12),

              // ─── Info ─────────────────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      receipt.storeName,
                      style: AppTypography.bodyBold,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      DateFormatter.formatReceiptCardTime(receipt.date),
                      style: AppTypography.caption,
                    ),
                    const SizedBox(height: 6),
                    CategoryBadge(category: receipt.category),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // ─── Amount + reminder ────────────────────────────────────────
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    CurrencyFormatter.format(receipt.totalAmount),
                    style: AppTypography.bodyBold,
                  ),
                  if (receipt.hasReminder && receipt.reminderDate != null) ...[
                    const SizedBox(height: 4),
                    ReminderBadge(deadline: receipt.reminderDate!),
                  ],
                  const SizedBox(height: 4),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: receipt.photoPath != null
          ? Image.file(
              File(receipt.photoPath!),
              width: 48,
              height: 64,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _placeholderThumb(),
            )
          : _placeholderThumb(),
    );
  }

  Widget _placeholderThumb() {
    return Container(
      width: 48,
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(
        Icons.receipt_long_outlined,
        size: 22,
        color: AppColors.textSecondary,
      ),
    );
  }

  Widget _swipeBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: AppColors.warning,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(Icons.delete_outline_rounded,
          color: Colors.white, size: 24),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context) async {
    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _DeleteConfirmSheet(
        storeName: receipt.storeName,
        onConfirm: () => Navigator.of(ctx).pop(true),
        onCancel: () => Navigator.of(ctx).pop(false),
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _ContextMenuSheet(
        onEdit: onEdit != null
            ? () {
                Navigator.of(ctx).pop();
                onEdit!();
              }
            : null,
        onExport: onExport != null
            ? () {
                Navigator.of(ctx).pop();
                onExport!();
              }
            : null,
        onDelete: onDelete != null
            ? () {
                Navigator.of(ctx).pop();
                onDelete!();
              }
            : null,
      ),
    );
  }
}

// ─── Delete Confirmation Bottom Sheet ─────────────────────────────────────────
class _DeleteConfirmSheet extends StatelessWidget {
  final String storeName;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const _DeleteConfirmSheet({
    required this.storeName,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.warningBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.delete_outline_rounded,
                color: AppColors.warning, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            'Hapus Struk?',
            style: AppTypography.sectionTitle,
          ),
          const SizedBox(height: 8),
          Text(
            'Struk dari $storeName akan dihapus permanen.',
            style: AppTypography.body.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onCancel,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.border),
                    foregroundColor: AppColors.textPrimary,
                  ),
                  child: const Text('Batal'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.warning,
                  ),
                  child: const Text('Hapus'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Context Menu Bottom Sheet ─────────────────────────────────────────────────
class _ContextMenuSheet extends StatelessWidget {
  final VoidCallback? onEdit;
  final VoidCallback? onExport;
  final VoidCallback? onDelete;

  const _ContextMenuSheet({this.onEdit, this.onExport, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 8),
          if (onEdit != null) _menuItem(Icons.edit_outlined, 'Edit', onEdit!),
          if (onExport != null)
            _menuItem(Icons.upload_outlined, 'Export', onExport!),
          if (onDelete != null)
            _menuItem(Icons.delete_outline, 'Hapus', onDelete!,
                color: AppColors.warning),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _menuItem(
    IconData icon,
    String label,
    VoidCallback onTap, {
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 22, color: color ?? AppColors.textPrimary),
            const SizedBox(width: 14),
            Text(label,
                style: AppTypography.body
                    .copyWith(color: color ?? AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }
}

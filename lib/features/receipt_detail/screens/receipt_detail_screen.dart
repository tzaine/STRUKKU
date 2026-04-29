// lib/features/receipt_detail/screens/receipt_detail_screen.dart  [SCREEN 06]
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/models/receipt_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../shared/widgets/category_badge.dart';
import '../../../shared/widgets/reminder_badge.dart';
import '../widgets/anomaly_card.dart';
import '../../home/providers/home_provider.dart';
import '../../reminder/screens/set_reminder_sheet.dart';
import '../../export/widgets/export_bottom_sheet.dart';

class ReceiptDetailScreen extends ConsumerStatefulWidget {
  final int receiptId;

  const ReceiptDetailScreen({super.key, required this.receiptId});

  @override
  ConsumerState<ReceiptDetailScreen> createState() =>
      _ReceiptDetailScreenState();
}

class _ReceiptDetailScreenState extends ConsumerState<ReceiptDetailScreen> {
  ReceiptModel? _receipt;
  bool _anomalyIgnored = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadReceipt();
    });
  }

  Future<void> _loadReceipt() async {
    try {
      final dao = ref.read(receiptsDaoProvider);
      final row = await dao.getReceiptById(widget.receiptId);
      if (row != null && mounted) {
        setState(() => _receipt = dao.toModel(row));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading receipt: $e')),
        );
      }
    }
  }

  Future<void> _deleteReceipt() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Struk?'),
        content: const Text('Struk ini akan dihapus permanen.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Hapus',
                  style: TextStyle(color: AppColors.warning))),
        ],
      ),
    );
    if (confirmed == true) {
      try {
        final dao = ref.read(receiptsDaoProvider);
        await dao.deleteReceipt(widget.receiptId);
        if (mounted) context.go('/history');
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menghapus: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final receipt = _receipt;

    if (receipt == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(receipt.storeName,
            style: AppTypography.sectionTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Photo ──────────────────────────────────────────────────────
            if (receipt.photoPath != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(receipt.photoPath!),
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 200,
                    color: AppColors.surface,
                    child: const Center(
                        child: Icon(Icons.receipt_long_outlined,
                            size: 40,
                            color: AppColors.textSecondary)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // ─── Store info ──────────────────────────────────────────────────
            Text(receipt.storeName, style: AppTypography.storeName),
            const SizedBox(height: 4),
            Text(
              DateFormatter.format(receipt.date),
              style: AppTypography.body
                  .copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
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

            // ─── Reminder inline ─────────────────────────────────────────────
            if (receipt.hasReminder && receipt.reminderDate != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.amberBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppColors.amber.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.alarm_outlined,
                        color: AppColors.amber, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            receipt.reminderType?.label ?? 'Reminder',
                            style: AppTypography.bodyBold,
                          ),
                          Text(
                            DateFormatter.formatReminderCountdown(
                                receipt.reminderDate!),
                            style: AppTypography.caption
                                .copyWith(color: AppColors.amber),
                          ),
                        ],
                      ),
                    ),
                    ReminderBadge(deadline: receipt.reminderDate!),
                  ],
                ),
              ),
            ],

            // ─── Anomaly card ─────────────────────────────────────────────────
            if (receipt.anomalyDetected && !_anomalyIgnored) ...[
              const SizedBox(height: 16),
              AnomalyCard(
                onIgnore: () =>
                    setState(() => _anomalyIgnored = true),
                onEdit: () {
                  // TODO: open edit screen
                },
              ),
            ],

            // ─── Items ──────────────────────────────────────────────────────
            if (receipt.items.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text('Daftar Item', style: AppTypography.sectionTitle),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border, width: 0.5),
                ),
                child: Column(
                  children: receipt.items.asMap().entries.map((e) {
                    final i = e.key;
                    final item = e.value;
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(item.name,
                                    style: AppTypography.body),
                              ),
                              Text(
                                CurrencyFormatter.format(item.price),
                                style: AppTypography.bodyBold,
                              ),
                            ],
                          ),
                        ),
                        if (i < receipt.items.length - 1)
                          const Divider(height: 0),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],

            const SizedBox(height: 24),
          ],
        ),
      ),

      // ─── Bottom action row ───────────────────────────────────────────────
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        decoration: const BoxDecoration(
          color: AppColors.background,
          border: Border(
              top: BorderSide(color: AppColors.border, width: 0.5)),
        ),
        child: Row(
          children: [
            _ActionButton(
              icon: Icons.alarm_add_outlined,
              label: 'Reminder',
              onTap: () => SetReminderSheet.show(context, receipt),
            ),
            _ActionButton(
              icon: Icons.edit_outlined,
              label: 'Edit',
              onTap: () {}, // TODO
            ),
            _ActionButton(
              icon: Icons.upload_outlined,
              label: 'Export',
              onTap: () => ExportBottomSheet.show(context, [receipt]),
            ),
            _ActionButton(
              icon: Icons.delete_outline_rounded,
              label: 'Hapus',
              color: AppColors.warning,
              onTap: _deleteReceipt,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.textPrimary;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: c),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.caption.copyWith(color: c),
            ),
          ],
        ),
      ),
    );
  }
}

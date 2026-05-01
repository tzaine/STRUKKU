// lib/features/reminder/screens/set_reminder_sheet.dart  [SCREEN 07]
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:strukku/core/database/app_database.dart';
import 'package:drift/drift.dart' as drift;
import 'package:strukku/core/models/receipt_model.dart';
import 'package:strukku/core/theme/app_colors.dart';
import 'package:strukku/core/theme/app_typography.dart';
import 'package:strukku/core/services/notification_service.dart';
import 'package:strukku/features/home/providers/home_provider.dart';

class SetReminderSheet extends ConsumerStatefulWidget {
  final ReceiptModel receipt;

  const SetReminderSheet({super.key, required this.receipt});

  static Future<void> show(BuildContext context, ReceiptModel receipt) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (_) => SetReminderSheet(receipt: receipt),
    );
  }

  @override
  ConsumerState<SetReminderSheet> createState() => _SetReminderSheetState();
}

class _SetReminderSheetState extends ConsumerState<SetReminderSheet> {
  bool _returEnabled = false;
  bool _garansiEnabled = false;
  DateTime? _returDeadline;
  DateTime? _garansiDeadline;
  final Set<String> _selectedDays = {'H-7', 'H-1'};
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Default: retur = purchase date + 7 days
    _returDeadline = widget.receipt.date.add(const Duration(days: 7));
    if (widget.receipt.hasReminder) {
      _returEnabled = widget.receipt.reminderType == ReminderType.retur;
      _garansiEnabled = widget.receipt.reminderType == ReminderType.garansi;
      _garansiDeadline = widget.receipt.reminderDate;
    }
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);

    // Determine type and date
    ReminderType? type;
    DateTime? date;

    if (_returEnabled && _returDeadline != null) {
      type = ReminderType.retur;
      date = _returDeadline;
    } else if (_garansiEnabled && _garansiDeadline != null) {
      type = ReminderType.garansi;
      date = _garansiDeadline;
    }

    if (type == null || date == null || widget.receipt.id == null) {
      Navigator.of(context).pop();
      return;
    }

    try {
      final notifService = NotificationService();
      await notifService.requestPermissions();

      final dao = ref.read(remindersDaoProvider);

      // Update receipt with reminder info
      final receiptsDao = ref.read(receiptsDaoProvider);
      final updatedReceipt = widget.receipt.copyWith(
        hasReminder: true,
        reminderDate: date,
        reminderType: type,
      );

      await receiptsDao.updateReceipt(
        receiptsDao.toCompanion(updatedReceipt),
      );

      // Cancel old
      await notifService.cancelAllForReceipt(widget.receipt.id!);

      for (final dayStr in _selectedDays) {
        final daysStr = dayStr.replaceAll('H-', '');
        final days = int.tryParse(daysStr) ?? 1;

        final scheduledDate = date.subtract(Duration(days: days));
        if (scheduledDate.isAfter(DateTime.now())) {
          // Schedule notif
          final notifId = NotificationService.notifId(widget.receipt.id!, days);
          await notifService.scheduleReminder(
            notifId: notifId,
            receiptId: widget.receipt.id!,
            storeName: widget.receipt.storeName,
            reminderType: type.label,
            scheduledDate: scheduledDate,
            daysLabel: dayStr,
          );

          // Save to DB
          await dao.insertReminder(ReminderLogCompanion.insert(
            receiptId: widget.receipt.id!,
            scheduledDate: scheduledDate.toIso8601String(),
            reminderType: type.label,
            isDismissed: const drift.Value(false),
          ));
        }
      }

      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 24),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ─── Handle ───────────────────────────────────────────────────────
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
                Text('Set Reminder', style: AppTypography.sectionTitle),
                const SizedBox(height: 20),

                // ─── Retur toggle ─────────────────────────────────────────
                _ReminderToggle(
                  icon: Icons.undo_rounded,
                  title: 'Reminder Retur',
                  subtitle: _returDeadline != null
                      ? 'Batas: ${DateFormat('dd MMM yyyy', 'id_ID').format(_returDeadline!)}'
                      : 'Belum diatur',
                  value: _returEnabled,
                  onChanged: (v) => setState(() => _returEnabled = v),
                  onDateTap: () async {
                    final d = await showDatePicker(
                      context: context,
                      initialDate: _returDeadline ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (d != null) setState(() => _returDeadline = d);
                  },
                ),
                const SizedBox(height: 12),

                // ─── Garansi date picker ──────────────────────────────────
                _ReminderToggle(
                  icon: Icons.verified_outlined,
                  title: 'Garansi Produk',
                  subtitle: _garansiDeadline != null
                      ? 'Berakhir: ${DateFormat('dd MMM yyyy', 'id_ID').format(_garansiDeadline!)}'
                      : 'Ketuk untuk pilih tanggal',
                  value: _garansiEnabled,
                  onChanged: (v) => setState(() => _garansiEnabled = v),
                  onDateTap: () async {
                    final d = await showDatePicker(
                      context: context,
                      initialDate: _garansiDeadline ??
                          DateTime.now().add(const Duration(days: 30)),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 3650)),
                    );
                    if (d != null) {
                      setState(() {
                        _garansiDeadline = d;
                        _garansiEnabled = true;
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),

                // ─── Notify on ────────────────────────────────────────────
                Text('Ingatkan pada', style: AppTypography.caption),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: ['H-7', 'H-3', 'H-1'].map((day) {
                    final selected = _selectedDays.contains(day);
                    return GestureDetector(
                      onTap: () => setState(() {
                        if (selected) {
                          _selectedDays.remove(day);
                        } else {
                          _selectedDays.add(day);
                        }
                      }),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color:
                              selected ? AppColors.accent : AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color:
                                selected ? AppColors.accent : AppColors.border,
                            width: 0.5,
                          ),
                        ),
                        child: Text(
                          day,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: selected
                                ? Colors.white
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // ─── Save button ──────────────────────────────────────────
                ElevatedButton(
                  onPressed: (_returEnabled || _garansiEnabled) && !_isSaving
                      ? _save
                      : null,
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white)))
                      : const Text('Simpan Reminder'),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReminderToggle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final VoidCallback? onDateTap;

  const _ReminderToggle({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.onDateTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDateTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: value ? AppColors.accent.withOpacity(0.3) : AppColors.border,
            width: 0.5,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.textSecondary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.bodyMedium),
                  Text(subtitle, style: AppTypography.caption),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: AppColors.accent,
            ),
          ],
        ),
      ),
    );
  }
}

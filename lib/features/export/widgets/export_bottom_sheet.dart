// lib/features/export/widgets/export_bottom_sheet.dart  [SCREEN 11]
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/models/receipt_model.dart';
import '../../../core/services/export_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/currency_formatter.dart';

enum ExportFormat { pdf, excel }

class ExportBottomSheet extends StatefulWidget {
  final List<ReceiptModel> receipts;

  const ExportBottomSheet({super.key, required this.receipts});

  static Future<void> show(
      BuildContext context, List<ReceiptModel> receipts) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (_) => ExportBottomSheet(receipts: receipts),
    );
  }

  @override
  State<ExportBottomSheet> createState() => _ExportBottomSheetState();
}

class _ExportBottomSheetState extends State<ExportBottomSheet> {
  ExportFormat _format = ExportFormat.pdf;
  bool _isExporting = false;

  double get _total =>
      widget.receipts.fold(0, (s, r) => s + r.totalAmount);

  Future<void> _export() async {
    setState(() => _isExporting = true);
    final svc = ExportService();
    try {
      final file = _format == ExportFormat.pdf
          ? await svc.exportToPdf(widget.receipts)
          : await svc.exportToExcel(widget.receipts);
      await svc.shareFile(file);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal export: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
        Navigator.of(context).pop();
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
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            Text('Export Struk', style: AppTypography.sectionTitle),
            const SizedBox(height: 20),

            // ─── Format selection ────────────────────────────────────────
            Text('Format', style: AppTypography.caption),
            const SizedBox(height: 10),
            Row(
              children: [
                _FormatOption(
                  icon: Icons.picture_as_pdf_outlined,
                  label: 'PDF',
                  selected: _format == ExportFormat.pdf,
                  onTap: () =>
                      setState(() => _format = ExportFormat.pdf),
                ),
                const SizedBox(width: 12),
                _FormatOption(
                  icon: Icons.table_chart_outlined,
                  label: 'Excel',
                  selected: _format == ExportFormat.excel,
                  onTap: () =>
                      setState(() => _format = ExportFormat.excel),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ─── Preview ─────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.accentLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded,
                      size: 16, color: AppColors.accent),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${widget.receipts.length} struk akan diekspor — total ${CurrencyFormatter.format(_total)}',
                      style: AppTypography.caption
                          .copyWith(color: AppColors.accent),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ─── Export button ───────────────────────────────────────────
            ElevatedButton(
              onPressed: widget.receipts.isEmpty || _isExporting
                  ? null
                  : _export,
              child: _isExporting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation(Colors.white)))
                  : const Text('Export Sekarang'),
            ),
          ],
        ),
      ),
    );
  }
}

class _FormatOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FormatOption({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected ? AppColors.accentLight : AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? AppColors.accent : AppColors.border,
              width: selected ? 1.5 : 0.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon,
                  size: 24,
                  color: selected
                      ? AppColors.accent
                      : AppColors.textSecondary),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: selected
                      ? AppColors.accent
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// lib/features/ocr_review/screens/ocr_review_screen.dart  [SCREEN 05]
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/models/receipt_item.dart';
import '../../../core/models/receipt_model.dart';
import '../../../core/services/ocr_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../shared/widgets/category_badge.dart';
import '../../home/providers/home_provider.dart';

class OcrReviewScreen extends ConsumerStatefulWidget {
  final String photoPath;
  final OcrResult ocrResult;

  const OcrReviewScreen({
    super.key,
    required this.photoPath,
    required this.ocrResult,
  });

  @override
  ConsumerState<OcrReviewScreen> createState() => _OcrReviewScreenState();
}

class _OcrReviewScreenState extends ConsumerState<OcrReviewScreen> {
  late TextEditingController _storeCtrl;
  late TextEditingController _totalCtrl;
  late DateTime _selectedDate;
  late ReceiptCategory _selectedCategory;
  late List<ReceiptItem> _items;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final ocr = widget.ocrResult;
    _storeCtrl = TextEditingController(
        text: ocr.storeName.value ?? '');
    _totalCtrl = TextEditingController(
        text: ocr.total.value?.toStringAsFixed(0) ?? '');
    _selectedDate = ocr.date.value ?? DateTime.now();
    _selectedCategory = ReceiptCategory.lainnya;
    _items = ocr.items
        .map((i) => ReceiptItem(name: i.name, price: i.price ?? 0))
        .toList();
  }

  @override
  void dispose() {
    _storeCtrl.dispose();
    _totalCtrl.dispose();
    super.dispose();
  }

  Color _confidenceBorderColor(OcrConfidence c) {
    switch (c) {
      case OcrConfidence.high:
        return AppColors.border;
      case OcrConfidence.medium:
        return AppColors.amber;
      case OcrConfidence.low:
        return AppColors.warning;
    }
  }

  Color _confidenceBgColor(OcrConfidence c) {
    switch (c) {
      case OcrConfidence.high:
        return AppColors.surface;
      case OcrConfidence.medium:
        return AppColors.ocrLowConfBg;
      case OcrConfidence.low:
        return AppColors.warningBg;
    }
  }

  Future<void> _save() async {
    final storeName = _storeCtrl.text.trim();
    if (storeName.isEmpty) return;

    setState(() => _isSaving = true);

    final total = CurrencyFormatter.parse(_totalCtrl.text) ??
        double.tryParse(_totalCtrl.text) ??
        0;

    final now = DateTime.now();
    final receipt = ReceiptModel(
      storeName: storeName,
      date: _selectedDate,
      totalAmount: total,
      category: _selectedCategory,
      photoPath: widget.photoPath,
      items: _items,
      anomalyDetected: _items.isNotEmpty &&
          (_items.fold<double>(
                      0, (s, i) => s + i.price * (i.quantity ?? 1)) -
                  total)
              .abs() >
          1,
      createdAt: now,
      updatedAt: now,
    );

    try {
      final dao = ref.read(receiptsDaoProvider);
      await dao.insertReceipt(dao.toCompanion(receipt));

      if (mounted) {
        context.go('/history');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ocr = widget.ocrResult;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Review Hasil Scan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go('/camera'),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── Thumbnail ──────────────────────────────────────────
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(widget.photoPath),
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 140,
                        color: AppColors.surface,
                        child: const Center(
                          child: Icon(Icons.receipt_long_outlined,
                            size: 40, color: AppColors.textSecondary)
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ─── Store name ─────────────────────────────────────────
                  _ConfidenceField(
                    label: 'Nama Toko',
                    controller: _storeCtrl,
                    confidence: ocr.storeName.confidence,
                    confidenceBg: _confidenceBgColor,
                    confidenceBorder: _confidenceBorderColor,
                  ),
                  const SizedBox(height: 16),

                  // ─── Date picker ─────────────────────────────────────────
                  _DateField(
                    label: 'Tanggal',
                    date: _selectedDate,
                    confidence: ocr.date.confidence,
                    confidenceBg: _confidenceBgColor,
                    confidenceBorder: _confidenceBorderColor,
                    onChanged: (d) => setState(() => _selectedDate = d),
                  ),
                  const SizedBox(height: 16),

                  // ─── Total ──────────────────────────────────────────────
                  _ConfidenceField(
                    label: 'Total Belanja',
                    controller: _totalCtrl,
                    confidence: ocr.total.confidence,
                    keyboardType: TextInputType.number,
                    confidenceBg: _confidenceBgColor,
                    confidenceBorder: _confidenceBorderColor,
                    prefix: 'Rp ',
                  ),
                  const SizedBox(height: 16),

                  // ─── Category ────────────────────────────────────────────
                  Text('Kategori', style: AppTypography.caption),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ReceiptCategory.values.map((cat) {
                      final selected = _selectedCategory == cat;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _selectedCategory = cat),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.accent
                                : AppColors.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: selected
                                  ? AppColors.accent
                                  : AppColors.border,
                              width: 0.5,
                            ),
                          ),
                          child: Text(
                            cat.label,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
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

                  // ─── Items ───────────────────────────────────────────────
                  if (_items.isNotEmpty) ...[
                    Text('Daftar Item', style: AppTypography.sectionTitle),
                    const SizedBox(height: 8),
                    ...List.generate(_items.length, (i) {
                      final item = _items[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
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
                      );
                    }),
                  ],
                ],
              ),
            ),
          ),

          // ─── Bottom actions ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            child: Column(
              children: [
                OutlinedButton(
                  onPressed: () => context.go('/camera'),
                  child: const Text('Scan Ulang'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _isSaving ? null : _save,
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(
                                  Colors.white)))
                      : const Text('Simpan Struk'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Confidence-aware text field ──────────────────────────────────────────────
class _ConfidenceField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final OcrConfidence confidence;
  final Color Function(OcrConfidence) confidenceBg;
  final Color Function(OcrConfidence) confidenceBorder;
  final TextInputType? keyboardType;
  final String? prefix;

  const _ConfidenceField({
    required this.label,
    required this.controller,
    required this.confidence,
    required this.confidenceBg,
    required this.confidenceBorder,
    this.keyboardType,
    this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = confidenceBorder(confidence);
    final bg = confidenceBg(confidence);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: AppTypography.caption),
            if (confidence != OcrConfidence.high) ...[
              const SizedBox(width: 6),
              Icon(
                Icons.edit_outlined,
                size: 12,
                color: confidence == OcrConfidence.low
                    ? AppColors.warning
                    : AppColors.amber,
              ),
            ],
          ],
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: AppTypography.body,
          decoration: InputDecoration(
            fillColor: bg,
            filled: true,
            prefixText: prefix,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: borderColor,
                width: confidence == OcrConfidence.low ? 1.5 : 0.5,
                style: confidence == OcrConfidence.low
                    ? BorderStyle.solid
                    : BorderStyle.solid,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                  color: AppColors.accent, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Date picker field ────────────────────────────────────────────────────────
class _DateField extends StatelessWidget {
  final String label;
  final DateTime date;
  final OcrConfidence confidence;
  final Color Function(OcrConfidence) confidenceBg;
  final Color Function(OcrConfidence) confidenceBorder;
  final ValueChanged<DateTime> onChanged;

  const _DateField({
    required this.label,
    required this.date,
    required this.confidence,
    required this.confidenceBg,
    required this.confidenceBorder,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.caption),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: date,
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),
            );
            if (picked != null) onChanged(picked);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: confidenceBg(confidence),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: confidenceBorder(confidence), width: 0.5),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    DateFormat('dd MMM yyyy', 'id_ID').format(date),
                    style: AppTypography.body,
                  ),
                ),
                const Icon(Icons.calendar_today_outlined,
                    size: 16, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

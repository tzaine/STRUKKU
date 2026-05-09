// lib/features/receipt_detail/screens/edit_receipt_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:strukku/core/models/receipt_model.dart';
import 'package:strukku/core/models/receipt_item.dart';
import 'package:strukku/core/theme/app_colors.dart';
import 'package:strukku/core/theme/app_typography.dart';
import 'package:strukku/core/utils/currency_formatter.dart';
import 'package:strukku/features/home/providers/home_provider.dart';
import 'package:intl/intl.dart';

class EditReceiptScreen extends ConsumerStatefulWidget {
  final ReceiptModel receipt;

  const EditReceiptScreen({super.key, required this.receipt});

  @override
  ConsumerState<EditReceiptScreen> createState() => _EditReceiptScreenState();
}

class _EditReceiptScreenState extends ConsumerState<EditReceiptScreen> {
  late TextEditingController _storeCtrl;
  late TextEditingController _totalCtrl;
  late TextEditingController _notesCtrl;
  late DateTime _selectedDate;
  late ReceiptCategory _selectedCategory;
  late List<ReceiptItem> _items;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _storeCtrl = TextEditingController(text: widget.receipt.storeName);
    _totalCtrl = TextEditingController(
      text: CurrencyFormatter.formatPlain(widget.receipt.totalAmount),
    );
    _notesCtrl = TextEditingController(text: widget.receipt.notes ?? '');
    _selectedDate = widget.receipt.date;
    _selectedCategory = widget.receipt.category;
    _items = List.from(widget.receipt.items);
  }

  @override
  void dispose() {
    _storeCtrl.dispose();
    _totalCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final storeName = _storeCtrl.text.trim();
    if (storeName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama toko tidak boleh kosong')),
      );
      return;
    }

    setState(() => _isSaving = true);

    final total = CurrencyFormatter.parse(_totalCtrl.text) ??
        double.tryParse(_totalCtrl.text) ??
        widget.receipt.totalAmount;

    final updatedReceipt = widget.receipt.copyWith(
      storeName: storeName,
      date: _selectedDate,
      totalAmount: total,
      category: _selectedCategory,
      items: _items,
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      updatedAt: DateTime.now(),
    );

    try {
      final dao = ref.read(receiptsDaoProvider);
      await dao.updateReceipt(dao.toCompanion(updatedReceipt));

      if (mounted) {
        Navigator.pop(context, true); // return true = data changed
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan: $e')),
        );
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit Struk'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context, false),
        ),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _save,
            child: _isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    'Simpan',
                    style: AppTypography.bodyBold
                        .copyWith(color: AppColors.accent),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Nama Toko ─────────────────────────────────────────────
            Text('Nama Toko', style: AppTypography.caption),
            const SizedBox(height: 6),
            TextField(
              controller: _storeCtrl,
              style: AppTypography.body,
              decoration: InputDecoration(
                hintText: 'Masukkan nama toko',
                fillColor: AppColors.surface,
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: AppColors.border, width: 0.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: AppColors.accent, width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ─── Tanggal ──────────────────────────────────────────────
            Text('Tanggal', style: AppTypography.caption),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (picked != null) setState(() => _selectedDate = picked);
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border, width: 0.5),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        DateFormat('dd MMM yyyy', 'id_ID')
                            .format(_selectedDate),
                        style: AppTypography.body,
                      ),
                    ),
                    const Icon(Icons.calendar_today_outlined,
                        size: 16, color: AppColors.textSecondary),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ─── Total ────────────────────────────────────────────────
            Text('Total Belanja', style: AppTypography.caption),
            const SizedBox(height: 6),
            TextField(
              controller: _totalCtrl,
              keyboardType: TextInputType.number,
              style: AppTypography.body,
              decoration: InputDecoration(
                prefixText: 'Rp ',
                fillColor: AppColors.surface,
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: AppColors.border, width: 0.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: AppColors.accent, width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ─── Kategori ─────────────────────────────────────────────
            Text('Kategori', style: AppTypography.caption),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ReceiptCategory.values.map((cat) {
                final selected = _selectedCategory == cat;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 7),
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
            const SizedBox(height: 16),

            // ─── Catatan ──────────────────────────────────────────────
            Text('Catatan (opsional)', style: AppTypography.caption),
            const SizedBox(height: 6),
            TextField(
              controller: _notesCtrl,
              maxLines: 3,
              style: AppTypography.body,
              decoration: InputDecoration(
                hintText: 'Tambahkan catatan...',
                fillColor: AppColors.surface,
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: AppColors.border, width: 0.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: AppColors.accent, width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ─── Items ────────────────────────────────────────────────
            if (_items.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Daftar Item', style: AppTypography.sectionTitle),
                  Text('${_items.length} Item', style: AppTypography.caption),
                ],
              ),
              const SizedBox(height: 12),
              ...List.generate(_items.length, (i) {
                final item = _items[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: AppColors.border, width: 0.5),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.name,
                                style: AppTypography.body,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 4),
                            Text(
                              CurrencyFormatter.format(item.price),
                              style: AppTypography.bodyBold
                                  .copyWith(color: AppColors.accent),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded,
                            color: AppColors.warning, size: 20),
                        onPressed: () {
                          setState(() => _items.removeAt(i));
                        },
                      ),
                    ],
                  ),
                );
              }),
            ],

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

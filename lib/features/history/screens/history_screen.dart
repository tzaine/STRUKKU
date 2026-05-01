// lib/features/history/screens/history_screen.dart  [SCREEN 08]
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:strukku/core/models/receipt_model.dart';
import 'package:strukku/core/theme/app_colors.dart';
import 'package:strukku/core/theme/app_typography.dart';
import 'package:strukku/shared/widgets/receipt_card_widget.dart';
import 'package:strukku/shared/widgets/empty_state_widget.dart';
import 'package:strukku/shared/widgets/shimmer_loader.dart';
import 'package:strukku/features/home/providers/home_provider.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  final _searchCtrl = TextEditingController();
  ReceiptCategory? _selectedCategory;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final receiptsAsync = ref.watch(allReceiptsStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ─── Header ───────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Riwayat Struk', style: AppTypography.pageTitle),
                  IconButton(
                    icon: const Icon(Icons.search_rounded),
                    onPressed: () => context.go('/search'),
                  ),
                ],
              ),
            ),

            // ─── Search bar ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: TextField(
                controller: _searchCtrl,
                decoration: const InputDecoration(
                  hintText: 'Cari struk...',
                  prefixIcon: Icon(Icons.search_rounded,
                      color: AppColors.textSecondary, size: 20),
                ),
                onChanged: (q) => setState(() => _searchQuery = q),
              ),
            ),

            // ─── Category filter chips ─────────────────────────────────────
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _FilterChip(
                    label: 'Semua',
                    selected: _selectedCategory == null,
                    onTap: () => setState(() => _selectedCategory = null),
                  ),
                  ...ReceiptCategory.values.map((cat) => _FilterChip(
                        label: cat.label,
                        selected: _selectedCategory == cat,
                        onTap: () => setState(() => _selectedCategory = cat),
                      )),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ─── List ─────────────────────────────────────────────────────
            Expanded(
              child: receiptsAsync.when(
                loading: () => ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: 6,
                  itemBuilder: (_, __) => const ReceiptCardShimmer(),
                ),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (allReceipts) {
                  // Apply filters
                  var filtered = allReceipts.where((r) {
                    final matchSearch = _searchQuery.isEmpty ||
                        r.storeName
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase());
                    final matchCat = _selectedCategory == null ||
                        r.category == _selectedCategory;
                    return matchSearch && matchCat;
                  }).toList();

                  if (filtered.isEmpty) {
                    return const EmptyStateWidget(
                      icon: Icons.search_off_rounded,
                      title: 'Tidak ada struk ditemukan',
                      subtitle: 'Coba kata kunci atau filter yang berbeda.',
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) {
                      final r = filtered[i];
                      return ReceiptCardWidget(
                        receipt: r,
                        onTap: () => context.go('/home/detail/${r.id}'),
                        onDelete: () async {
                          final dao = ref.read(receiptsDaoProvider);
                          await dao.deleteReceipt(r.id!);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.accent : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.accent : AppColors.border,
            width: 0.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

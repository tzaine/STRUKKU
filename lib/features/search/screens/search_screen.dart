// lib/features/search/screens/search_screen.dart  [SCREEN 12]
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:strukku/core/models/receipt_model.dart';
import 'package:strukku/core/theme/app_colors.dart';
import 'package:strukku/core/theme/app_typography.dart';
import 'package:strukku/shared/widgets/empty_state_widget.dart';
import 'package:strukku/shared/widgets/receipt_card_widget.dart';
import 'package:strukku/features/home/providers/home_provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    // Auto-focus
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _searchCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final receiptsAsync = ref.watch(allReceiptsStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: TextField(
          controller: _searchCtrl,
          focusNode: _focusNode,
          decoration: const InputDecoration(
            hintText: 'Cari struk, toko, kategori...',
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            filled: false,
            contentPadding: EdgeInsets.zero,
          ),
          onChanged: (q) => setState(() => _query = q),
        ),
        actions: [
          if (_query.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: () {
                _searchCtrl.clear();
                setState(() => _query = '');
              },
            ),
        ],
      ),
      body: receiptsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (all) {
          if (_query.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.search_rounded,
                      size: 48, color: AppColors.border),
                  const SizedBox(height: 12),
                  Text('Ketik untuk mencari struk',
                      style: AppTypography.body
                          .copyWith(color: AppColors.textSecondary)),
                ],
              ),
            );
          }

          final results = all.where((r) {
            final q = _query.toLowerCase();
            return r.storeName.toLowerCase().contains(q) ||
                r.category.label.toLowerCase().contains(q) ||
                (r.notes?.toLowerCase().contains(q) ?? false);
          }).toList();

          if (results.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.search_off_rounded,
              title: 'Tidak ada struk ditemukan',
              subtitle: 'Coba kata kunci atau filter yang berbeda.',
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: results.length,
            itemBuilder: (_, i) {
              final r = results[i];
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
    );
  }
}

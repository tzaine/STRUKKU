// lib/features/home/screens/home_screen.dart  [SCREEN 02]
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:strukku/core/theme/app_colors.dart';
import 'package:strukku/core/theme/app_typography.dart';
import 'package:strukku/core/utils/currency_formatter.dart';
import 'package:strukku/core/utils/date_formatter.dart';
import 'package:strukku/shared/widgets/receipt_card_widget.dart';
import 'package:strukku/shared/widgets/empty_state_widget.dart';
import 'package:strukku/shared/widgets/shimmer_loader.dart';
import 'package:strukku/features/onboarding/providers/onboarding_provider.dart';
import 'package:strukku/features/home/providers/home_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userName = ref.watch(userNameProvider) ?? 'Kamu';
    final stats = ref.watch(homeStatsProvider);
    final recentReceipts = ref.watch(recentReceiptsProvider);
    final receiptsAsync = ref.watch(allReceiptsStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ─── Header ───────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormatter.formatFull(DateTime.now()),
                          style: AppTypography.caption,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Halo, $userName!',
                          style: AppTypography.pageTitle,
                        ),
                      ],
                    ),
                    // Notification bell
                    Stack(
                      children: [
                        IconButton(
                          onPressed: () => context.go('/reminders'),
                          icon: const Icon(
                            Icons.notifications_outlined,
                            size: 24,
                          ),
                        ),
                        if (stats.activeReminderCount > 0)
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.warning,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ─── Metric cards ──────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: _MetricCard(
                        title: 'Struk Bulan Ini',
                        value: '${stats.receiptCountThisMonth}',
                        unit: 'struk tersimpan',
                        icon: Icons.receipt_long_outlined,
                        iconColor: AppColors.accent,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _MetricCard(
                        title: 'Pengingat Aktif',
                        value: '${stats.activeReminderCount}',
                        unit: 'menunggu tindakan',
                        icon: Icons.warning_amber_rounded,
                        iconColor: stats.activeReminderCount > 0
                            ? AppColors.amber
                            : AppColors.textSecondary,
                        highlight: stats.activeReminderCount > 0,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ─── Struk Terbaru section ─────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Struk Terbaru', style: AppTypography.sectionTitle),
                    TextButton(
                      onPressed: () => context.go('/history'),
                      child: const Text('Lihat Semua →'),
                    ),
                  ],
                ),
              ),
            ),

            // ─── Recent receipts list ──────────────────────────────────────
            receiptsAsync.when(
              loading: () => SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, __) => const ReceiptCardShimmer(),
                    childCount: 3,
                  ),
                ),
              ),
              error: (e, _) => SliverToBoxAdapter(
                child: Center(child: Text('Error: $e')),
              ),
              data: (allReceipts) {
                if (allReceipts.isEmpty) {
                  return SliverToBoxAdapter(
                    child: EmptyStateWidget(
                      icon: Icons.receipt_long_outlined,
                      title: 'Belum ada struk tersimpan, $userName.',
                      subtitle: 'Ketuk tombol kamera untuk mulai scan.',
                      ctaLabel: 'Scan Sekarang',
                      onCta: () => context.go('/camera'),
                    ),
                  );
                }
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) {
                        final r = recentReceipts[i];
                        return ReceiptCardWidget(
                          receipt: r,
                          onTap: () => context.go('/home/detail/${r.id}'),
                          onDelete: () async {
                            final dao = ref.read(receiptsDaoProvider);
                            await dao.deleteReceipt(r.id!);
                          },
                        );
                      },
                      childCount: recentReceipts.length,
                    ),
                  ),
                );
              },
            ),

            // ─── Total spend card ──────────────────────────────────────────
            if (stats.totalThisMonth > 0)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: GestureDetector(
                    onTap: () => context.go('/analytics'),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.accentLight,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: AppColors.accent.withOpacity(0.2),
                            width: 0.5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total pengeluaran bulan ini',
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.accent,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                CurrencyFormatter.format(stats.totalThisMonth),
                                style: AppTypography.pageTitle.copyWith(
                                  color: AppColors.accent,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          const Icon(Icons.chevron_right_rounded,
                              color: AppColors.accent),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}

// ─── Metric Card ──────────────────────────────────────────────────────────────
class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final IconData icon;
  final Color iconColor;
  final bool highlight;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    required this.iconColor,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: AppTypography.caption
                      .copyWith(color: AppColors.textSecondary)),
              Icon(icon, size: 16, color: iconColor),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTypography.pageTitle.copyWith(
              fontSize: 28,
              color: highlight ? AppColors.amber : AppColors.textPrimary,
            ),
          ),
          Text(unit, style: AppTypography.caption),
        ],
      ),
    );
  }
}

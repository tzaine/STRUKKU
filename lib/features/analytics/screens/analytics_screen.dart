// lib/features/analytics/screens/analytics_screen.dart  [SCREEN 09]
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:strukku/core/models/receipt_model.dart';
import 'package:strukku/core/theme/app_colors.dart';
import 'package:strukku/core/theme/app_typography.dart';
import 'package:strukku/core/utils/category_helper.dart';
import 'package:strukku/core/utils/currency_formatter.dart';
import 'package:strukku/features/home/providers/home_provider.dart';

enum AnalyticsPeriod { week, month, threeMonths }

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  AnalyticsPeriod _period = AnalyticsPeriod.month;

  List<ReceiptModel> _getFiltered(List<ReceiptModel> all) {
    final now = DateTime.now();
    DateTime from;
    switch (_period) {
      case AnalyticsPeriod.week:
        from = now.subtract(const Duration(days: 7));
        break;
      case AnalyticsPeriod.month:
        from = DateTime(now.year, now.month, 1);
        break;
      case AnalyticsPeriod.threeMonths:
        from = DateTime(now.year, now.month - 2, 1);
        break;
    }
    return all.where((r) => r.date.isAfter(from)).toList();
  }

  Map<ReceiptCategory, double> _categoryTotals(List<ReceiptModel> list) {
    final map = <ReceiptCategory, double>{};
    for (final r in list) {
      map[r.category] = (map[r.category] ?? 0) + r.totalAmount;
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final receiptsAsync = ref.watch(allReceiptsStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: receiptsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (all) {
            final filtered = _getFiltered(all);
            final totalSpend =
                filtered.fold<double>(0, (s, r) => s + r.totalAmount);
            final catTotals = _categoryTotals(filtered);
            final sortedCats = catTotals.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value));

            return CustomScrollView(
              slivers: [
                // ─── Header ─────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Text('Analitik', style: AppTypography.pageTitle),
                  ),
                ),

                // ─── Period chips ────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Row(
                      children: AnalyticsPeriod.values.map((p) {
                        final label = switch (p) {
                          AnalyticsPeriod.week => 'Minggu ini',
                          AnalyticsPeriod.month => 'Bulan ini',
                          AnalyticsPeriod.threeMonths => '3 Bulan',
                        };
                        final selected = _period == p;
                        return GestureDetector(
                          onTap: () => setState(() => _period = p),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            margin: const EdgeInsets.only(right: 8),
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
                              ),
                            ),
                            child: Text(
                              label,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                fontWeight: selected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: selected
                                    ? Colors.white
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                // ─── Total stat ──────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border, width: 0.5),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Total Periode Ini',
                                    style: AppTypography.caption),
                                const SizedBox(height: 4),
                                Text(
                                  CurrencyFormatter.format(totalSpend),
                                  style: AppTypography.pageTitle
                                      .copyWith(color: AppColors.accent),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.accentLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('${filtered.length} struk',
                                style: AppTypography.caption
                                    .copyWith(color: AppColors.accent)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ─── Bar chart ───────────────────────────────────────────
                if (filtered.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Pengeluaran',
                              style: AppTypography.sectionTitle),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 180,
                            child: BarChart(
                              BarChartData(
                                alignment: BarChartAlignment.spaceAround,
                                maxY: catTotals.values.isEmpty
                                    ? 100
                                    : catTotals.values
                                            .reduce((a, b) => a > b ? a : b) *
                                        1.2,
                                barGroups: _buildSimpleBarGroups(filtered),
                                gridData: const FlGridData(show: false),
                                borderData: FlBorderData(show: false),
                                titlesData: const FlTitlesData(
                                  leftTitles: AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                  rightTitles: AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                  topTitles: AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                  bottomTitles: AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                ),
                              ),
                              swapAnimationDuration:
                                  const Duration(milliseconds: 400),
                              swapAnimationCurve: Curves.easeOut,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // ─── Donut chart ─────────────────────────────────────────
                if (catTotals.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Per Kategori',
                              style: AppTypography.sectionTitle),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 160,
                            child: Row(
                              children: [
                                Expanded(
                                  child: PieChart(
                                    PieChartData(
                                      sections: catTotals.entries
                                          .toList()
                                          .asMap()
                                          .entries
                                          .map((e) {
                                        final pct = totalSpend > 0
                                            ? e.value.value / totalSpend * 100
                                            : 0.0;
                                        return PieChartSectionData(
                                          value: e.value.value,
                                          color: CategoryHelper.getChartColor(
                                              e.value.key),
                                          radius: 40,
                                          title: '${pct.toStringAsFixed(0)}%',
                                          titleStyle: const TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        );
                                      }).toList(),
                                      centerSpaceRadius: 40,
                                      sectionsSpace: 2,
                                    ),
                                    swapAnimationDuration:
                                        const Duration(milliseconds: 500),
                                    swapAnimationCurve: Curves.easeInOut,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Legend
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: catTotals.entries
                                      .toList()
                                      .asMap()
                                      .entries
                                      .take(4)
                                      .map((e) => Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 10,
                                                  height: 10,
                                                  decoration: BoxDecoration(
                                                    color: CategoryHelper
                                                        .getChartColor(
                                                            e.value.key),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            3),
                                                  ),
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  e.value.key.label,
                                                  style: AppTypography.caption,
                                                ),
                                              ],
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // ─── Top categories ──────────────────────────────────────
                if (sortedCats.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Kategori Terbesar',
                              style: AppTypography.sectionTitle),
                          const SizedBox(height: 12),
                          ...sortedCats.take(3).map((e) {
                            final pct =
                                totalSpend > 0 ? e.value / totalSpend : 0.0;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        CategoryHelper.getIcon(e.key),
                                        size: 16,
                                        color: AppColors.textSecondary,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(e.key.label,
                                            style: AppTypography.body),
                                      ),
                                      Text(
                                        CurrencyFormatter.format(e.value),
                                        style: AppTypography.bodyBold,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: pct,
                                      backgroundColor: AppColors.border,
                                      valueColor: const AlwaysStoppedAnimation(
                                          AppColors.accent),
                                      minHeight: 4,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            );
          },
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildSimpleBarGroups(List<ReceiptModel> list) {
    if (list.isEmpty) return [];
    // Group by day of month
    final map = <int, double>{};
    for (final r in list) {
      final key = r.date.day;
      map[key] = (map[key] ?? 0) + r.totalAmount;
    }
    final sorted = map.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
    return sorted.asMap().entries.map((e) {
      return BarChartGroupData(
        x: e.key,
        barRods: [
          BarChartRodData(
            toY: e.value.value,
            color: AppColors.accent,
            width: 16,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      );
    }).toList();
  }
}

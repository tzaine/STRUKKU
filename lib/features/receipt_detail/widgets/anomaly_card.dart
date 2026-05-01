// lib/features/receipt_detail/widgets/anomaly_card.dart
import 'package:flutter/material.dart';
import 'package:strukku/core/theme/app_colors.dart';
import 'package:strukku/core/theme/app_typography.dart';

class AnomalyCard extends StatelessWidget {
  final VoidCallback? onIgnore;
  final VoidCallback? onEdit;

  const AnomalyCard({super.key, this.onIgnore, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.warningBg,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: const BorderSide(color: AppColors.warning, width: 3),
          top:
              BorderSide(color: AppColors.warning.withOpacity(0.2), width: 0.5),
          right:
              BorderSide(color: AppColors.warning.withOpacity(0.2), width: 0.5),
          bottom:
              BorderSide(color: AppColors.warning.withOpacity(0.2), width: 0.5),
        ),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded,
                  color: AppColors.warning, size: 16),
              const SizedBox(width: 6),
              Text(
                'Total tidak sesuai',
                style: AppTypography.bodySemiBold
                    .copyWith(color: AppColors.warning),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Total tidak sesuai penjumlahan item',
            style: AppTypography.caption.copyWith(color: AppColors.warning),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onIgnore,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.border),
                    foregroundColor: AppColors.textSecondary,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    minimumSize: const Size(0, 38),
                  ),
                  child: const Text('Abaikan', style: TextStyle(fontSize: 13)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: onEdit,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.warning),
                    foregroundColor: AppColors.warning,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    minimumSize: const Size(0, 38),
                  ),
                  child:
                      const Text('Edit Manual', style: TextStyle(fontSize: 13)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

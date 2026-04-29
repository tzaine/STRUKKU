// lib/shared/widgets/reminder_badge.dart
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/date_formatter.dart';

enum ReminderUrgency { normal, approaching, critical, expired }

class ReminderBadge extends StatelessWidget {
  final DateTime deadline;

  const ReminderBadge({super.key, required this.deadline});

  ReminderUrgency get _urgency {
    final now = DateTime.now();
    final diff = deadline.difference(now);
    if (diff.isNegative) return ReminderUrgency.expired;
    if (diff.inDays <= 2) return ReminderUrgency.critical;
    if (diff.inDays <= 7) return ReminderUrgency.approaching;
    return ReminderUrgency.normal;
  }

  @override
  Widget build(BuildContext context) {
    final urgency = _urgency;
    final label = DateFormatter.formatReminderCountdown(deadline);

    Color bg, textColor;
    switch (urgency) {
      case ReminderUrgency.normal:
        bg = const Color(0xFFF2F2F0);
        textColor = AppColors.textSecondary;
        break;
      case ReminderUrgency.approaching:
        bg = AppColors.amberBg;
        textColor = AppColors.amber;
        break;
      case ReminderUrgency.critical:
      case ReminderUrgency.expired:
        bg = AppColors.warningBg;
        textColor = AppColors.warning;
        break;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.alarm_outlined, size: 10, color: textColor),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

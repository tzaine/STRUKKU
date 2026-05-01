// lib/features/reminder/screens/reminder_list_screen.dart  [SCREEN 10]
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:strukku/core/database/app_database.dart';
import 'package:strukku/core/theme/app_colors.dart';
import 'package:strukku/core/theme/app_typography.dart';
import 'package:strukku/core/utils/date_formatter.dart';
import 'package:strukku/shared/widgets/empty_state_widget.dart';
import 'package:strukku/shared/widgets/reminder_badge.dart';
import 'package:strukku/features/home/providers/home_provider.dart';

class ReminderListScreen extends ConsumerWidget {
  const ReminderListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remindersAsync = ref.watch(remindersStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Text('Reminder Aktif', style: AppTypography.pageTitle),
            ),
            Expanded(
              child: remindersAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (reminders) {
                  if (reminders.isEmpty) {
                    return const EmptyStateWidget(
                      icon: Icons.notifications_none_rounded,
                      title: 'Semua aman, tidak ada deadline.',
                      subtitle: 'Tidak ada reminder aktif saat ini.',
                    );
                  }

                  final sorted = List.of(reminders)
                    ..sort((a, b) => DateTime.parse(a.scheduledDate)
                        .compareTo(DateTime.parse(b.scheduledDate)));

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
                    itemCount: sorted.length,
                    itemBuilder: (_, i) {
                      final r = sorted[i];
                      final deadline = DateTime.parse(r.scheduledDate);
                      return _ReminderCard(
                        reminder: r,
                        deadline: deadline,
                        onTap: () => context.go('/home/detail/${r.receiptId}'),
                        onDismiss: () async {
                          final dao = ref.read(remindersDaoProvider);
                          await dao.dismissReminder(r.id);
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

class _ReminderCard extends StatelessWidget {
  final ReminderLogData reminder;
  final DateTime deadline;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const _ReminderCard({
    required this.reminder,
    required this.deadline,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('reminder_${reminder.id}'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.warning,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline_rounded,
            color: Colors.white, size: 24),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border, width: 0.5),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.accentLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.alarm_outlined,
                    color: AppColors.accent, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reminder.reminderType,
                      style: AppTypography.bodyBold,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      DateFormatter.format(deadline),
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ),
              ReminderBadge(deadline: deadline),
            ],
          ),
        ),
      ),
    );
  }
}

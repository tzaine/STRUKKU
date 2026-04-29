// lib/features/home/providers/home_provider.dart
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/daos/receipts_dao.dart';
import '../../../core/database/daos/reminders_dao.dart';
import '../../../core/models/receipt_model.dart';
import '../../onboarding/providers/onboarding_provider.dart';

// ─── Database provider ────────────────────────────────────────────────────────
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final receiptsDaoProvider = Provider<ReceiptsDao>((ref) {
  return ref.watch(appDatabaseProvider).receiptsDao;
});

final remindersDaoProvider = Provider<RemindersDao>((ref) {
  return ref.watch(appDatabaseProvider).remindersDao;
});

// ─── Stream providers ─────────────────────────────────────────────────────────
final allReceiptsStreamProvider = StreamProvider<List<ReceiptModel>>((ref) {
  final dao = ref.watch(receiptsDaoProvider);
  return dao.watchAllReceipts().map(
        (rows) => rows.map(dao.toModel).toList(),
      );
});

final recentReceiptsProvider = Provider<List<ReceiptModel>>((ref) {
  return ref.watch(allReceiptsStreamProvider).maybeWhen(
        data: (list) => list.take(3).toList(),
        orElse: () => [],
      );
});

final thisMonthReceiptsProvider = StreamProvider<List<ReceiptModel>>((ref) {
  final dao = ref.watch(receiptsDaoProvider);
  return dao.watchReceiptsThisMonth().map(
        (rows) => rows.map(dao.toModel).toList(),
      );
});

final remindersStreamProvider =
    StreamProvider<List<ReminderLogData>>((ref) {
  final dao = ref.watch(remindersDaoProvider);
  return dao.watchAllReminders();
});

// ─── Home stats ───────────────────────────────────────────────────────────────
class HomeStats {
  final int receiptCountThisMonth;
  final int activeReminderCount;
  final double totalThisMonth;

  const HomeStats({
    required this.receiptCountThisMonth,
    required this.activeReminderCount,
    required this.totalThisMonth,
  });
}

final homeStatsProvider = Provider<HomeStats>((ref) {
  final monthly = ref.watch(thisMonthReceiptsProvider).maybeWhen(
        data: (list) => list,
        orElse: () => <ReceiptModel>[],
      );
  final reminders = ref.watch(remindersStreamProvider).maybeWhen(
        data: (list) => list,
        orElse: () => <ReminderLogData>[],
      );

  return HomeStats(
    receiptCountThisMonth: monthly.length,
    activeReminderCount: reminders.length,
    totalThisMonth:
        monthly.fold(0, (sum, r) => sum + r.totalAmount),
  );
});

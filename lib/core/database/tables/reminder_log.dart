// lib/core/database/tables/reminder_log.dart
import 'package:drift/drift.dart';
import 'package:strukku/core/database/tables/receipts.dart';

class ReminderLog extends Table {
  IntColumn get id => integer().autoIncrement()();

  // BUG FIX: Use proper Drift foreign-key reference with cascade delete
  // This prevents orphan reminder rows when a receipt is deleted.
  IntColumn get receiptId =>
      integer().references(Receipts, #id, onDelete: KeyAction.cascade)();

  TextColumn get reminderType => text()(); // 'Retur' | 'Garansi'
  TextColumn get scheduledDate => text()(); // ISO-8601
  BoolColumn get isSent => boolean().withDefault(const Constant(false))();
  BoolColumn get isDismissed => boolean().withDefault(const Constant(false))();
}

// lib/core/database/daos/reminders_dao.dart
import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/reminder_log.dart';

part 'reminders_dao.g.dart';

@DriftAccessor(tables: [ReminderLog])
class RemindersDao extends DatabaseAccessor<AppDatabase>
    with _$RemindersDaoMixin {
  RemindersDao(super.db);

  Stream<List<ReminderLogData>> watchAllReminders() {
    return (select(reminderLog)
          ..where((t) => t.isDismissed.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.scheduledDate)]))
        .watch();
  }

  Future<List<ReminderLogData>> getPendingReminders() {
    return (select(reminderLog)
          ..where((t) =>
              t.isSent.equals(false) & t.isDismissed.equals(false)))
        .get();
  }

  Future<List<ReminderLogData>> getRemindersForReceipt(int receiptId) {
    return (select(reminderLog)
          ..where((t) => t.receiptId.equals(receiptId)))
        .get();
  }

  Future<int> insertReminder(ReminderLogCompanion companion) {
    return into(reminderLog).insert(companion);
  }

  Future<int> dismissReminder(int id) {
    return (update(reminderLog)..where((t) => t.id.equals(id)))
        .write(const ReminderLogCompanion(isDismissed: Value(true)));
  }

  Future<int> markSent(int id) {
    return (update(reminderLog)..where((t) => t.id.equals(id)))
        .write(const ReminderLogCompanion(isSent: Value(true)));
  }

  Future<int> deleteRemindersForReceipt(int receiptId) {
    return (delete(reminderLog)
          ..where((t) => t.receiptId.equals(receiptId)))
        .go();
  }

  Future<int> deleteReminder(int id) {
    return (delete(reminderLog)..where((t) => t.id.equals(id))).go();
  }
}

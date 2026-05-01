// lib/core/database/daos/receipts_dao.dart
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:strukku/core/database/app_database.dart';
import 'package:strukku/core/models/receipt_model.dart';
import 'package:strukku/core/models/receipt_item.dart';
import 'package:strukku/core/database/tables/receipts.dart';

part 'receipts_dao.g.dart';

@DriftAccessor(tables: [Receipts])
class ReceiptsDao extends DatabaseAccessor<AppDatabase>
    with _$ReceiptsDaoMixin {
  ReceiptsDao(super.db);

  // ─── Stream all receipts, newest first ────────────────────────────────────
  Stream<List<Receipt>> watchAllReceipts() {
    return (select(receipts)..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  // ─── Watch receipts for this month ────────────────────────────────────────
  Stream<List<Receipt>> watchReceiptsThisMonth() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1).toIso8601String();
    return (select(receipts)
          ..where((t) => t.date.isBiggerOrEqualValue(startOfMonth))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .watch();
  }

  // ─── Watch receipts with active reminders ─────────────────────────────────
  Stream<List<Receipt>> watchReceiptsWithReminders() {
    return (select(receipts)
          ..where((t) => t.hasReminder.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.reminderDate)]))
        .watch();
  }

  // ─── Get single receipt ────────────────────────────────────────────────────
  Future<Receipt?> getReceiptById(int id) {
    return (select(receipts)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  // ─── Insert ───────────────────────────────────────────────────────────────
  Future<int> insertReceipt(ReceiptsCompanion companion) {
    return into(receipts).insert(companion);
  }

  // ─── Update ───────────────────────────────────────────────────────────────
  Future<bool> updateReceipt(ReceiptsCompanion companion) {
    return update(receipts).replace(companion);
  }

  // ─── Delete ───────────────────────────────────────────────────────────────
  Future<int> deleteReceipt(int id) {
    return (delete(receipts)..where((t) => t.id.equals(id))).go();
  }

  // ─── Search by store name ─────────────────────────────────────────────────
  Stream<List<Receipt>> searchReceipts(String query) {
    return (select(receipts)
          ..where((t) => t.storeName.like('%$query%'))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .watch();
  }

  // ─── Filter by category ───────────────────────────────────────────────────
  Stream<List<Receipt>> watchByCategory(String category) {
    return (select(receipts)
          ..where((t) => t.category.equals(category))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .watch();
  }

  // ─── Analytics: receipts in date range ────────────────────────────────────
  Future<List<Receipt>> getReceiptsInRange(DateTime from, DateTime to) {
    return (select(receipts)
          ..where((t) =>
              t.date.isBiggerOrEqualValue(from.toIso8601String()) &
              t.date.isSmallerOrEqualValue(to.toIso8601String()))
          ..orderBy([(t) => OrderingTerm.asc(t.date)]))
        .get();
  }

  // ─── Helper: convert DB row to domain model ───────────────────────────────
  ReceiptModel toModel(Receipt row) {
    List<ReceiptItem> items = [];
    if (row.itemsJson != null) {
      try {
        final jsonList = jsonDecode(row.itemsJson!) as List<dynamic>;
        items = jsonList
            .map((e) => ReceiptItem.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (_) {}
    }

    List<String> notifDays = [];
    if (row.notifDays != null) {
      try {
        notifDays = List<String>.from(jsonDecode(row.notifDays!));
      } catch (_) {}
    }

    return ReceiptModel(
      id: row.id,
      storeName: row.storeName,
      date: DateTime.parse(row.date),
      totalAmount: row.totalAmount,
      category: ReceiptCategory.fromString(row.category),
      photoPath: row.photoPath,
      items: items,
      notes: row.notes,
      hasReminder: row.hasReminder,
      reminderType: ReminderType.fromString(row.reminderType),
      reminderDate:
          row.reminderDate != null ? DateTime.parse(row.reminderDate!) : null,
      notifDays: notifDays,
      anomalyDetected: row.anomalyDetected,
      createdAt: DateTime.parse(row.createdAt),
      updatedAt: DateTime.parse(row.updatedAt),
    );
  }

  // ─── Helper: domain model to companion ───────────────────────────────────
  ReceiptsCompanion toCompanion(ReceiptModel model) {
    final now = DateTime.now().toIso8601String();
    return ReceiptsCompanion(
      id: model.id != null ? Value(model.id!) : const Value.absent(),
      storeName: Value(model.storeName),
      date: Value(model.date.toIso8601String()),
      totalAmount: Value(model.totalAmount),
      category: Value(model.category.label),
      photoPath: Value(model.photoPath),
      itemsJson: Value(jsonEncode(model.items.map((e) => e.toJson()).toList())),
      notes: Value(model.notes),
      hasReminder: Value(model.hasReminder),
      reminderType: Value(model.reminderType?.label),
      reminderDate: Value(model.reminderDate?.toIso8601String()),
      notifDays: Value(jsonEncode(model.notifDays)),
      anomalyDetected: Value(model.anomalyDetected),
      createdAt: Value(model.createdAt.toIso8601String()),
      updatedAt: Value(now),
    );
  }
}

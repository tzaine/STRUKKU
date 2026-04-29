// lib/core/database/tables/receipts.dart
import 'package:drift/drift.dart';

@TableIndex(name: 'receipts_date_idx', columns: {#date})
@TableIndex(name: 'receipts_category_idx', columns: {#category})
class Receipts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get storeName => text()();
  TextColumn get date => text()(); // ISO-8601
  RealColumn get totalAmount => real()();
  TextColumn get category => text().withDefault(const Constant('Lainnya'))();
  TextColumn get photoPath => text().nullable()();
  TextColumn get itemsJson => text().nullable()(); // JSON array
  TextColumn get notes => text().nullable()();
  BoolColumn get hasReminder => boolean().withDefault(const Constant(false))();
  TextColumn get reminderType => text().nullable()();
  TextColumn get reminderDate => text().nullable()(); // ISO-8601
  TextColumn get notifDays => text().nullable()(); // JSON array
  BoolColumn get anomalyDetected =>
      boolean().withDefault(const Constant(false))();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

}

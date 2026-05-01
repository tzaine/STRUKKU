// lib/core/database/app_database.dart
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:strukku/core/database/tables/receipts.dart';
import 'package:strukku/core/database/tables/reminder_log.dart';
import 'package:strukku/core/database/daos/receipts_dao.dart';
import 'package:strukku/core/database/daos/reminders_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Receipts, ReminderLog],
  daos: [ReceiptsDao, RemindersDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
      },
      onUpgrade: (m, from, to) async {
        // Future migrations go here
      },
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'strukku_db',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.dart.js'),
      ),
    );
  }
}

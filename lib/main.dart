// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app.dart';
import 'core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Indonesian locale
  await initializeDateFormatting('id_ID', null);

  // Initialize notifications
  final notifService = NotificationService();
  await notifService.init(
    onTap: (receiptId) {
      // Deep link handled in router via extra state
    },
  );

  runApp(
    const ProviderScope(
      child: StrukuApp(),
    ),
  );
}

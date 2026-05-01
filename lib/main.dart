// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:strukku/app.dart';
import 'package:strukku/core/services/notification_service.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

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

// lib/core/services/notification_service.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static const String _channelId = 'strukku_reminders';
  static const String _channelName = 'Strukku Reminders';
  static const String _channelDesc = 'Pengingat retur dan garansi produk Anda';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  // Callback for handling notification taps → used for deep linking
  Function(int receiptId)? onNotificationTap;

  Future<void> init({Function(int receiptId)? onTap}) async {
    onNotificationTap = onTap;
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );

    // Create Android notification channel
    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDesc,
      importance: Importance.high,
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  void _onNotificationResponse(NotificationResponse response) {
    final payload = response.payload;
    if (payload != null) {
      final receiptId = int.tryParse(payload);
      if (receiptId != null) {
        onNotificationTap?.call(receiptId);
      }
    }
  }

  Future<bool> requestPermissions() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final granted = await android?.requestNotificationsPermission() ?? false;

    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    await ios?.requestPermissions(alert: true, badge: true, sound: true);

    return granted;
  }

  /// Schedule reminder notification
  Future<void> scheduleReminder({
    required int notifId,
    required int receiptId,
    required String storeName,
    required String reminderType, // 'Retur' | 'Garansi'
    required DateTime scheduledDate,
    required String daysLabel, // 'besok' | 'X hari lagi'
  }) async {
    final title = reminderType == 'Retur'
        ? 'Strukku — Batas Retur Mendekat'
        : 'Strukku — Garansi Akan Habis';

    final body = reminderType == 'Retur'
        ? 'Struk $storeName batas retur-nya $daysLabel.'
        : 'Garansi produk dari $storeName berakhir $daysLabel.';

    final scheduledTz = tz.TZDateTime.from(scheduledDate, tz.local);

    if (scheduledTz.isBefore(tz.TZDateTime.now(tz.local))) return;

    await _plugin.zonedSchedule(
      notifId,
      title,
      body,
      scheduledTz,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: receiptId.toString(),
    );
  }

  Future<void> cancelNotification(int notifId) async {
    await _plugin.cancel(notifId);
  }

  Future<void> cancelAllForReceipt(int receiptId) async {
    // IDs are generated as receiptId * 100 + offset
    for (int i = 0; i < 5; i++) {
      await _plugin.cancel(receiptId * 100 + i);
    }
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  /// Generate notification IDs for a receipt
  static int notifId(int receiptId, int dayOffset) =>
      receiptId * 100 + dayOffset;
}

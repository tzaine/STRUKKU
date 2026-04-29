// lib/core/utils/date_formatter.dart
import 'package:intl/intl.dart';

class DateFormatter {
  static final DateFormat _full = DateFormat('dd MMM yyyy', 'id_ID');
  static final DateFormat _withTime = DateFormat('dd MMM yyyy • HH:mm', 'id_ID');
  static final DateFormat _short = DateFormat('d MMM', 'id_ID');
  static final DateFormat _monthYear = DateFormat('MMMM yyyy', 'id_ID');
  static final DateFormat _dayName = DateFormat('EEEE, d MMMM yyyy', 'id_ID');

  static String format(DateTime date) => _full.format(date);
  static String formatWithTime(DateTime date) => _withTime.format(date);
  static String formatShort(DateTime date) => _short.format(date);
  static String formatMonthYear(DateTime date) => _monthYear.format(date);
  static String formatFull(DateTime date) => _dayName.format(date);

  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) return 'Hari ini';
    if (diff.inDays == 1) return 'Kemarin';
    if (diff.inDays < 7) return '${diff.inDays} hari lalu';
    return _full.format(date);
  }

  static String formatReminderCountdown(DateTime deadline) {
    final now = DateTime.now();
    final diff = deadline.difference(now);

    if (diff.isNegative) return 'Terlewat';
    if (diff.inDays == 0) return 'Hari ini!';
    if (diff.inDays == 1) return 'Besok!';
    return '${diff.inDays} hari lagi';
  }

  static String formatReceiptCardTime(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return 'Hari ini • ${DateFormat('HH:mm').format(date)} WIB';
    }
    if (diff.inDays == 1) {
      return 'Kemarin • ${DateFormat('HH:mm').format(date)} WIB';
    }
    return '${_short.format(date)} • ${DateFormat('HH:mm').format(date)} WIB';
  }
}

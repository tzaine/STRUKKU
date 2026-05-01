// lib/core/utils/currency_formatter.dart
import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _fmt = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  static final NumberFormat _plainFmt = NumberFormat.decimalPattern('id_ID');

  /// Format a double to Indonesian Rupiah string (e.g., Rp 15.000)
  static String format(double amount) => _fmt.format(amount);

  /// Format a double to decimal string with dots (e.g., 15.000)
  static String formatPlain(double amount) => _plainFmt.format(amount);

  /// Parse a formatted string back to double (strips Rp, dots, commas)
  static double? parse(String input) {
    if (input.isEmpty) return null;
    final cleaned = input
        .replaceAll('Rp', '')
        .replaceAll(' ', '')
        .replaceAll('.', '')
        .replaceAll(',', '.')
        .trim();
    return double.tryParse(cleaned);
  }
}

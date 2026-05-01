// lib/core/models/receipt_model.dart
import 'package:strukku/core/models/receipt_item.dart';

enum ReceiptCategory {
  makanan('Makanan'),
  elektronik('Elektronik'),
  kesehatan('Kesehatan'),
  transportasi('Transportasi'),
  lainnya('Lainnya');

  const ReceiptCategory(this.label);
  final String label;

  static ReceiptCategory fromString(String value) {
    return ReceiptCategory.values.firstWhere(
      (e) => e.label.toLowerCase() == value.toLowerCase(),
      orElse: () => ReceiptCategory.lainnya,
    );
  }
}

enum ReminderType {
  retur('Retur'),
  garansi('Garansi');

  const ReminderType(this.label);
  final String label;

  static ReminderType? fromString(String? value) {
    if (value == null) return null;
    return ReminderType.values.firstWhere(
      (e) => e.label.toLowerCase() == value.toLowerCase(),
      orElse: () => ReminderType.retur,
    );
  }
}

class ReceiptModel {
  final int? id;
  final String storeName;
  final DateTime date;
  final double totalAmount;
  final ReceiptCategory category;
  final String? photoPath;
  final List<ReceiptItem> items;
  final String? notes;
  final bool hasReminder;
  final ReminderType? reminderType;
  final DateTime? reminderDate;
  final List<String> notifDays; // ["H-7","H-3","H-1"]
  final bool anomalyDetected;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ReceiptModel({
    this.id,
    required this.storeName,
    required this.date,
    required this.totalAmount,
    this.category = ReceiptCategory.lainnya,
    this.photoPath,
    this.items = const [],
    this.notes,
    this.hasReminder = false,
    this.reminderType,
    this.reminderDate,
    this.notifDays = const [],
    this.anomalyDetected = false,
    required this.createdAt,
    required this.updatedAt,
  });

  List<ReceiptItem> get parsedItems => items;

  double get calculatedTotal =>
      items.fold(0, (sum, item) => sum + item.price * (item.quantity ?? 1));

  bool get hasAnomaly =>
      items.isNotEmpty && (calculatedTotal - totalAmount).abs() > 1.0;

  ReceiptModel copyWith({
    int? id,
    String? storeName,
    DateTime? date,
    double? totalAmount,
    ReceiptCategory? category,
    String? photoPath,
    List<ReceiptItem>? items,
    String? notes,
    bool? hasReminder,
    ReminderType? reminderType,
    DateTime? reminderDate,
    List<String>? notifDays,
    bool? anomalyDetected,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReceiptModel(
      id: id ?? this.id,
      storeName: storeName ?? this.storeName,
      date: date ?? this.date,
      totalAmount: totalAmount ?? this.totalAmount,
      category: category ?? this.category,
      photoPath: photoPath ?? this.photoPath,
      items: items ?? this.items,
      notes: notes ?? this.notes,
      hasReminder: hasReminder ?? this.hasReminder,
      reminderType: reminderType ?? this.reminderType,
      reminderDate: reminderDate ?? this.reminderDate,
      notifDays: notifDays ?? this.notifDays,
      anomalyDetected: anomalyDetected ?? this.anomalyDetected,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ReceiptsTable extends Receipts with TableInfo<$ReceiptsTable, Receipt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReceiptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _storeNameMeta =
      const VerificationMeta('storeName');
  @override
  late final GeneratedColumn<String> storeName = GeneratedColumn<String>(
      'store_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _totalAmountMeta =
      const VerificationMeta('totalAmount');
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
      'total_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Lainnya'));
  static const VerificationMeta _photoPathMeta =
      const VerificationMeta('photoPath');
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
      'photo_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _itemsJsonMeta =
      const VerificationMeta('itemsJson');
  @override
  late final GeneratedColumn<String> itemsJson = GeneratedColumn<String>(
      'items_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _hasReminderMeta =
      const VerificationMeta('hasReminder');
  @override
  late final GeneratedColumn<bool> hasReminder = GeneratedColumn<bool>(
      'has_reminder', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("has_reminder" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _reminderTypeMeta =
      const VerificationMeta('reminderType');
  @override
  late final GeneratedColumn<String> reminderType = GeneratedColumn<String>(
      'reminder_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _reminderDateMeta =
      const VerificationMeta('reminderDate');
  @override
  late final GeneratedColumn<String> reminderDate = GeneratedColumn<String>(
      'reminder_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notifDaysMeta =
      const VerificationMeta('notifDays');
  @override
  late final GeneratedColumn<String> notifDays = GeneratedColumn<String>(
      'notif_days', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _anomalyDetectedMeta =
      const VerificationMeta('anomalyDetected');
  @override
  late final GeneratedColumn<bool> anomalyDetected = GeneratedColumn<bool>(
      'anomaly_detected', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("anomaly_detected" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        storeName,
        date,
        totalAmount,
        category,
        photoPath,
        itemsJson,
        notes,
        hasReminder,
        reminderType,
        reminderDate,
        notifDays,
        anomalyDetected,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'receipts';
  @override
  VerificationContext validateIntegrity(Insertable<Receipt> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('store_name')) {
      context.handle(_storeNameMeta,
          storeName.isAcceptableOrUnknown(data['store_name']!, _storeNameMeta));
    } else if (isInserting) {
      context.missing(_storeNameMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('total_amount')) {
      context.handle(
          _totalAmountMeta,
          totalAmount.isAcceptableOrUnknown(
              data['total_amount']!, _totalAmountMeta));
    } else if (isInserting) {
      context.missing(_totalAmountMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('photo_path')) {
      context.handle(_photoPathMeta,
          photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta));
    }
    if (data.containsKey('items_json')) {
      context.handle(_itemsJsonMeta,
          itemsJson.isAcceptableOrUnknown(data['items_json']!, _itemsJsonMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('has_reminder')) {
      context.handle(
          _hasReminderMeta,
          hasReminder.isAcceptableOrUnknown(
              data['has_reminder']!, _hasReminderMeta));
    }
    if (data.containsKey('reminder_type')) {
      context.handle(
          _reminderTypeMeta,
          reminderType.isAcceptableOrUnknown(
              data['reminder_type']!, _reminderTypeMeta));
    }
    if (data.containsKey('reminder_date')) {
      context.handle(
          _reminderDateMeta,
          reminderDate.isAcceptableOrUnknown(
              data['reminder_date']!, _reminderDateMeta));
    }
    if (data.containsKey('notif_days')) {
      context.handle(_notifDaysMeta,
          notifDays.isAcceptableOrUnknown(data['notif_days']!, _notifDaysMeta));
    }
    if (data.containsKey('anomaly_detected')) {
      context.handle(
          _anomalyDetectedMeta,
          anomalyDetected.isAcceptableOrUnknown(
              data['anomaly_detected']!, _anomalyDetectedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Receipt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Receipt(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      storeName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}store_name'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      totalAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_amount'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      photoPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}photo_path']),
      itemsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}items_json']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      hasReminder: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}has_reminder'])!,
      reminderType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reminder_type']),
      reminderDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reminder_date']),
      notifDays: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notif_days']),
      anomalyDetected: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}anomaly_detected'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ReceiptsTable createAlias(String alias) {
    return $ReceiptsTable(attachedDatabase, alias);
  }
}

class Receipt extends DataClass implements Insertable<Receipt> {
  final int id;
  final String storeName;
  final String date;
  final double totalAmount;
  final String category;
  final String? photoPath;
  final String? itemsJson;
  final String? notes;
  final bool hasReminder;
  final String? reminderType;
  final String? reminderDate;
  final String? notifDays;
  final bool anomalyDetected;
  final String createdAt;
  final String updatedAt;
  const Receipt(
      {required this.id,
      required this.storeName,
      required this.date,
      required this.totalAmount,
      required this.category,
      this.photoPath,
      this.itemsJson,
      this.notes,
      required this.hasReminder,
      this.reminderType,
      this.reminderDate,
      this.notifDays,
      required this.anomalyDetected,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['store_name'] = Variable<String>(storeName);
    map['date'] = Variable<String>(date);
    map['total_amount'] = Variable<double>(totalAmount);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    if (!nullToAbsent || itemsJson != null) {
      map['items_json'] = Variable<String>(itemsJson);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['has_reminder'] = Variable<bool>(hasReminder);
    if (!nullToAbsent || reminderType != null) {
      map['reminder_type'] = Variable<String>(reminderType);
    }
    if (!nullToAbsent || reminderDate != null) {
      map['reminder_date'] = Variable<String>(reminderDate);
    }
    if (!nullToAbsent || notifDays != null) {
      map['notif_days'] = Variable<String>(notifDays);
    }
    map['anomaly_detected'] = Variable<bool>(anomalyDetected);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  ReceiptsCompanion toCompanion(bool nullToAbsent) {
    return ReceiptsCompanion(
      id: Value(id),
      storeName: Value(storeName),
      date: Value(date),
      totalAmount: Value(totalAmount),
      category: Value(category),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      itemsJson: itemsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(itemsJson),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      hasReminder: Value(hasReminder),
      reminderType: reminderType == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderType),
      reminderDate: reminderDate == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderDate),
      notifDays: notifDays == null && nullToAbsent
          ? const Value.absent()
          : Value(notifDays),
      anomalyDetected: Value(anomalyDetected),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Receipt.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Receipt(
      id: serializer.fromJson<int>(json['id']),
      storeName: serializer.fromJson<String>(json['storeName']),
      date: serializer.fromJson<String>(json['date']),
      totalAmount: serializer.fromJson<double>(json['totalAmount']),
      category: serializer.fromJson<String>(json['category']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      itemsJson: serializer.fromJson<String?>(json['itemsJson']),
      notes: serializer.fromJson<String?>(json['notes']),
      hasReminder: serializer.fromJson<bool>(json['hasReminder']),
      reminderType: serializer.fromJson<String?>(json['reminderType']),
      reminderDate: serializer.fromJson<String?>(json['reminderDate']),
      notifDays: serializer.fromJson<String?>(json['notifDays']),
      anomalyDetected: serializer.fromJson<bool>(json['anomalyDetected']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'storeName': serializer.toJson<String>(storeName),
      'date': serializer.toJson<String>(date),
      'totalAmount': serializer.toJson<double>(totalAmount),
      'category': serializer.toJson<String>(category),
      'photoPath': serializer.toJson<String?>(photoPath),
      'itemsJson': serializer.toJson<String?>(itemsJson),
      'notes': serializer.toJson<String?>(notes),
      'hasReminder': serializer.toJson<bool>(hasReminder),
      'reminderType': serializer.toJson<String?>(reminderType),
      'reminderDate': serializer.toJson<String?>(reminderDate),
      'notifDays': serializer.toJson<String?>(notifDays),
      'anomalyDetected': serializer.toJson<bool>(anomalyDetected),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  Receipt copyWith(
          {int? id,
          String? storeName,
          String? date,
          double? totalAmount,
          String? category,
          Value<String?> photoPath = const Value.absent(),
          Value<String?> itemsJson = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          bool? hasReminder,
          Value<String?> reminderType = const Value.absent(),
          Value<String?> reminderDate = const Value.absent(),
          Value<String?> notifDays = const Value.absent(),
          bool? anomalyDetected,
          String? createdAt,
          String? updatedAt}) =>
      Receipt(
        id: id ?? this.id,
        storeName: storeName ?? this.storeName,
        date: date ?? this.date,
        totalAmount: totalAmount ?? this.totalAmount,
        category: category ?? this.category,
        photoPath: photoPath.present ? photoPath.value : this.photoPath,
        itemsJson: itemsJson.present ? itemsJson.value : this.itemsJson,
        notes: notes.present ? notes.value : this.notes,
        hasReminder: hasReminder ?? this.hasReminder,
        reminderType:
            reminderType.present ? reminderType.value : this.reminderType,
        reminderDate:
            reminderDate.present ? reminderDate.value : this.reminderDate,
        notifDays: notifDays.present ? notifDays.value : this.notifDays,
        anomalyDetected: anomalyDetected ?? this.anomalyDetected,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Receipt copyWithCompanion(ReceiptsCompanion data) {
    return Receipt(
      id: data.id.present ? data.id.value : this.id,
      storeName: data.storeName.present ? data.storeName.value : this.storeName,
      date: data.date.present ? data.date.value : this.date,
      totalAmount:
          data.totalAmount.present ? data.totalAmount.value : this.totalAmount,
      category: data.category.present ? data.category.value : this.category,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      itemsJson: data.itemsJson.present ? data.itemsJson.value : this.itemsJson,
      notes: data.notes.present ? data.notes.value : this.notes,
      hasReminder:
          data.hasReminder.present ? data.hasReminder.value : this.hasReminder,
      reminderType: data.reminderType.present
          ? data.reminderType.value
          : this.reminderType,
      reminderDate: data.reminderDate.present
          ? data.reminderDate.value
          : this.reminderDate,
      notifDays: data.notifDays.present ? data.notifDays.value : this.notifDays,
      anomalyDetected: data.anomalyDetected.present
          ? data.anomalyDetected.value
          : this.anomalyDetected,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Receipt(')
          ..write('id: $id, ')
          ..write('storeName: $storeName, ')
          ..write('date: $date, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('category: $category, ')
          ..write('photoPath: $photoPath, ')
          ..write('itemsJson: $itemsJson, ')
          ..write('notes: $notes, ')
          ..write('hasReminder: $hasReminder, ')
          ..write('reminderType: $reminderType, ')
          ..write('reminderDate: $reminderDate, ')
          ..write('notifDays: $notifDays, ')
          ..write('anomalyDetected: $anomalyDetected, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      storeName,
      date,
      totalAmount,
      category,
      photoPath,
      itemsJson,
      notes,
      hasReminder,
      reminderType,
      reminderDate,
      notifDays,
      anomalyDetected,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Receipt &&
          other.id == this.id &&
          other.storeName == this.storeName &&
          other.date == this.date &&
          other.totalAmount == this.totalAmount &&
          other.category == this.category &&
          other.photoPath == this.photoPath &&
          other.itemsJson == this.itemsJson &&
          other.notes == this.notes &&
          other.hasReminder == this.hasReminder &&
          other.reminderType == this.reminderType &&
          other.reminderDate == this.reminderDate &&
          other.notifDays == this.notifDays &&
          other.anomalyDetected == this.anomalyDetected &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ReceiptsCompanion extends UpdateCompanion<Receipt> {
  final Value<int> id;
  final Value<String> storeName;
  final Value<String> date;
  final Value<double> totalAmount;
  final Value<String> category;
  final Value<String?> photoPath;
  final Value<String?> itemsJson;
  final Value<String?> notes;
  final Value<bool> hasReminder;
  final Value<String?> reminderType;
  final Value<String?> reminderDate;
  final Value<String?> notifDays;
  final Value<bool> anomalyDetected;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  const ReceiptsCompanion({
    this.id = const Value.absent(),
    this.storeName = const Value.absent(),
    this.date = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.category = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.itemsJson = const Value.absent(),
    this.notes = const Value.absent(),
    this.hasReminder = const Value.absent(),
    this.reminderType = const Value.absent(),
    this.reminderDate = const Value.absent(),
    this.notifDays = const Value.absent(),
    this.anomalyDetected = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ReceiptsCompanion.insert({
    this.id = const Value.absent(),
    required String storeName,
    required String date,
    required double totalAmount,
    this.category = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.itemsJson = const Value.absent(),
    this.notes = const Value.absent(),
    this.hasReminder = const Value.absent(),
    this.reminderType = const Value.absent(),
    this.reminderDate = const Value.absent(),
    this.notifDays = const Value.absent(),
    this.anomalyDetected = const Value.absent(),
    required String createdAt,
    required String updatedAt,
  })  : storeName = Value(storeName),
        date = Value(date),
        totalAmount = Value(totalAmount),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Receipt> custom({
    Expression<int>? id,
    Expression<String>? storeName,
    Expression<String>? date,
    Expression<double>? totalAmount,
    Expression<String>? category,
    Expression<String>? photoPath,
    Expression<String>? itemsJson,
    Expression<String>? notes,
    Expression<bool>? hasReminder,
    Expression<String>? reminderType,
    Expression<String>? reminderDate,
    Expression<String>? notifDays,
    Expression<bool>? anomalyDetected,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (storeName != null) 'store_name': storeName,
      if (date != null) 'date': date,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (category != null) 'category': category,
      if (photoPath != null) 'photo_path': photoPath,
      if (itemsJson != null) 'items_json': itemsJson,
      if (notes != null) 'notes': notes,
      if (hasReminder != null) 'has_reminder': hasReminder,
      if (reminderType != null) 'reminder_type': reminderType,
      if (reminderDate != null) 'reminder_date': reminderDate,
      if (notifDays != null) 'notif_days': notifDays,
      if (anomalyDetected != null) 'anomaly_detected': anomalyDetected,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ReceiptsCompanion copyWith(
      {Value<int>? id,
      Value<String>? storeName,
      Value<String>? date,
      Value<double>? totalAmount,
      Value<String>? category,
      Value<String?>? photoPath,
      Value<String?>? itemsJson,
      Value<String?>? notes,
      Value<bool>? hasReminder,
      Value<String?>? reminderType,
      Value<String?>? reminderDate,
      Value<String?>? notifDays,
      Value<bool>? anomalyDetected,
      Value<String>? createdAt,
      Value<String>? updatedAt}) {
    return ReceiptsCompanion(
      id: id ?? this.id,
      storeName: storeName ?? this.storeName,
      date: date ?? this.date,
      totalAmount: totalAmount ?? this.totalAmount,
      category: category ?? this.category,
      photoPath: photoPath ?? this.photoPath,
      itemsJson: itemsJson ?? this.itemsJson,
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

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (storeName.present) {
      map['store_name'] = Variable<String>(storeName.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (itemsJson.present) {
      map['items_json'] = Variable<String>(itemsJson.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (hasReminder.present) {
      map['has_reminder'] = Variable<bool>(hasReminder.value);
    }
    if (reminderType.present) {
      map['reminder_type'] = Variable<String>(reminderType.value);
    }
    if (reminderDate.present) {
      map['reminder_date'] = Variable<String>(reminderDate.value);
    }
    if (notifDays.present) {
      map['notif_days'] = Variable<String>(notifDays.value);
    }
    if (anomalyDetected.present) {
      map['anomaly_detected'] = Variable<bool>(anomalyDetected.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReceiptsCompanion(')
          ..write('id: $id, ')
          ..write('storeName: $storeName, ')
          ..write('date: $date, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('category: $category, ')
          ..write('photoPath: $photoPath, ')
          ..write('itemsJson: $itemsJson, ')
          ..write('notes: $notes, ')
          ..write('hasReminder: $hasReminder, ')
          ..write('reminderType: $reminderType, ')
          ..write('reminderDate: $reminderDate, ')
          ..write('notifDays: $notifDays, ')
          ..write('anomalyDetected: $anomalyDetected, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ReminderLogTable extends ReminderLog
    with TableInfo<$ReminderLogTable, ReminderLogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReminderLogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _receiptIdMeta =
      const VerificationMeta('receiptId');
  @override
  late final GeneratedColumn<int> receiptId = GeneratedColumn<int>(
      'receipt_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES receipts (id) ON DELETE CASCADE'));
  static const VerificationMeta _reminderTypeMeta =
      const VerificationMeta('reminderType');
  @override
  late final GeneratedColumn<String> reminderType = GeneratedColumn<String>(
      'reminder_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _scheduledDateMeta =
      const VerificationMeta('scheduledDate');
  @override
  late final GeneratedColumn<String> scheduledDate = GeneratedColumn<String>(
      'scheduled_date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isSentMeta = const VerificationMeta('isSent');
  @override
  late final GeneratedColumn<bool> isSent = GeneratedColumn<bool>(
      'is_sent', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_sent" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isDismissedMeta =
      const VerificationMeta('isDismissed');
  @override
  late final GeneratedColumn<bool> isDismissed = GeneratedColumn<bool>(
      'is_dismissed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_dismissed" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, receiptId, reminderType, scheduledDate, isSent, isDismissed];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminder_log';
  @override
  VerificationContext validateIntegrity(Insertable<ReminderLogData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('receipt_id')) {
      context.handle(_receiptIdMeta,
          receiptId.isAcceptableOrUnknown(data['receipt_id']!, _receiptIdMeta));
    } else if (isInserting) {
      context.missing(_receiptIdMeta);
    }
    if (data.containsKey('reminder_type')) {
      context.handle(
          _reminderTypeMeta,
          reminderType.isAcceptableOrUnknown(
              data['reminder_type']!, _reminderTypeMeta));
    } else if (isInserting) {
      context.missing(_reminderTypeMeta);
    }
    if (data.containsKey('scheduled_date')) {
      context.handle(
          _scheduledDateMeta,
          scheduledDate.isAcceptableOrUnknown(
              data['scheduled_date']!, _scheduledDateMeta));
    } else if (isInserting) {
      context.missing(_scheduledDateMeta);
    }
    if (data.containsKey('is_sent')) {
      context.handle(_isSentMeta,
          isSent.isAcceptableOrUnknown(data['is_sent']!, _isSentMeta));
    }
    if (data.containsKey('is_dismissed')) {
      context.handle(
          _isDismissedMeta,
          isDismissed.isAcceptableOrUnknown(
              data['is_dismissed']!, _isDismissedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReminderLogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReminderLogData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      receiptId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}receipt_id'])!,
      reminderType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reminder_type'])!,
      scheduledDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}scheduled_date'])!,
      isSent: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_sent'])!,
      isDismissed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_dismissed'])!,
    );
  }

  @override
  $ReminderLogTable createAlias(String alias) {
    return $ReminderLogTable(attachedDatabase, alias);
  }
}

class ReminderLogData extends DataClass implements Insertable<ReminderLogData> {
  final int id;
  final int receiptId;
  final String reminderType;
  final String scheduledDate;
  final bool isSent;
  final bool isDismissed;
  const ReminderLogData(
      {required this.id,
      required this.receiptId,
      required this.reminderType,
      required this.scheduledDate,
      required this.isSent,
      required this.isDismissed});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['receipt_id'] = Variable<int>(receiptId);
    map['reminder_type'] = Variable<String>(reminderType);
    map['scheduled_date'] = Variable<String>(scheduledDate);
    map['is_sent'] = Variable<bool>(isSent);
    map['is_dismissed'] = Variable<bool>(isDismissed);
    return map;
  }

  ReminderLogCompanion toCompanion(bool nullToAbsent) {
    return ReminderLogCompanion(
      id: Value(id),
      receiptId: Value(receiptId),
      reminderType: Value(reminderType),
      scheduledDate: Value(scheduledDate),
      isSent: Value(isSent),
      isDismissed: Value(isDismissed),
    );
  }

  factory ReminderLogData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReminderLogData(
      id: serializer.fromJson<int>(json['id']),
      receiptId: serializer.fromJson<int>(json['receiptId']),
      reminderType: serializer.fromJson<String>(json['reminderType']),
      scheduledDate: serializer.fromJson<String>(json['scheduledDate']),
      isSent: serializer.fromJson<bool>(json['isSent']),
      isDismissed: serializer.fromJson<bool>(json['isDismissed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'receiptId': serializer.toJson<int>(receiptId),
      'reminderType': serializer.toJson<String>(reminderType),
      'scheduledDate': serializer.toJson<String>(scheduledDate),
      'isSent': serializer.toJson<bool>(isSent),
      'isDismissed': serializer.toJson<bool>(isDismissed),
    };
  }

  ReminderLogData copyWith(
          {int? id,
          int? receiptId,
          String? reminderType,
          String? scheduledDate,
          bool? isSent,
          bool? isDismissed}) =>
      ReminderLogData(
        id: id ?? this.id,
        receiptId: receiptId ?? this.receiptId,
        reminderType: reminderType ?? this.reminderType,
        scheduledDate: scheduledDate ?? this.scheduledDate,
        isSent: isSent ?? this.isSent,
        isDismissed: isDismissed ?? this.isDismissed,
      );
  ReminderLogData copyWithCompanion(ReminderLogCompanion data) {
    return ReminderLogData(
      id: data.id.present ? data.id.value : this.id,
      receiptId: data.receiptId.present ? data.receiptId.value : this.receiptId,
      reminderType: data.reminderType.present
          ? data.reminderType.value
          : this.reminderType,
      scheduledDate: data.scheduledDate.present
          ? data.scheduledDate.value
          : this.scheduledDate,
      isSent: data.isSent.present ? data.isSent.value : this.isSent,
      isDismissed:
          data.isDismissed.present ? data.isDismissed.value : this.isDismissed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReminderLogData(')
          ..write('id: $id, ')
          ..write('receiptId: $receiptId, ')
          ..write('reminderType: $reminderType, ')
          ..write('scheduledDate: $scheduledDate, ')
          ..write('isSent: $isSent, ')
          ..write('isDismissed: $isDismissed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, receiptId, reminderType, scheduledDate, isSent, isDismissed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReminderLogData &&
          other.id == this.id &&
          other.receiptId == this.receiptId &&
          other.reminderType == this.reminderType &&
          other.scheduledDate == this.scheduledDate &&
          other.isSent == this.isSent &&
          other.isDismissed == this.isDismissed);
}

class ReminderLogCompanion extends UpdateCompanion<ReminderLogData> {
  final Value<int> id;
  final Value<int> receiptId;
  final Value<String> reminderType;
  final Value<String> scheduledDate;
  final Value<bool> isSent;
  final Value<bool> isDismissed;
  const ReminderLogCompanion({
    this.id = const Value.absent(),
    this.receiptId = const Value.absent(),
    this.reminderType = const Value.absent(),
    this.scheduledDate = const Value.absent(),
    this.isSent = const Value.absent(),
    this.isDismissed = const Value.absent(),
  });
  ReminderLogCompanion.insert({
    this.id = const Value.absent(),
    required int receiptId,
    required String reminderType,
    required String scheduledDate,
    this.isSent = const Value.absent(),
    this.isDismissed = const Value.absent(),
  })  : receiptId = Value(receiptId),
        reminderType = Value(reminderType),
        scheduledDate = Value(scheduledDate);
  static Insertable<ReminderLogData> custom({
    Expression<int>? id,
    Expression<int>? receiptId,
    Expression<String>? reminderType,
    Expression<String>? scheduledDate,
    Expression<bool>? isSent,
    Expression<bool>? isDismissed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (receiptId != null) 'receipt_id': receiptId,
      if (reminderType != null) 'reminder_type': reminderType,
      if (scheduledDate != null) 'scheduled_date': scheduledDate,
      if (isSent != null) 'is_sent': isSent,
      if (isDismissed != null) 'is_dismissed': isDismissed,
    });
  }

  ReminderLogCompanion copyWith(
      {Value<int>? id,
      Value<int>? receiptId,
      Value<String>? reminderType,
      Value<String>? scheduledDate,
      Value<bool>? isSent,
      Value<bool>? isDismissed}) {
    return ReminderLogCompanion(
      id: id ?? this.id,
      receiptId: receiptId ?? this.receiptId,
      reminderType: reminderType ?? this.reminderType,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      isSent: isSent ?? this.isSent,
      isDismissed: isDismissed ?? this.isDismissed,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (receiptId.present) {
      map['receipt_id'] = Variable<int>(receiptId.value);
    }
    if (reminderType.present) {
      map['reminder_type'] = Variable<String>(reminderType.value);
    }
    if (scheduledDate.present) {
      map['scheduled_date'] = Variable<String>(scheduledDate.value);
    }
    if (isSent.present) {
      map['is_sent'] = Variable<bool>(isSent.value);
    }
    if (isDismissed.present) {
      map['is_dismissed'] = Variable<bool>(isDismissed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReminderLogCompanion(')
          ..write('id: $id, ')
          ..write('receiptId: $receiptId, ')
          ..write('reminderType: $reminderType, ')
          ..write('scheduledDate: $scheduledDate, ')
          ..write('isSent: $isSent, ')
          ..write('isDismissed: $isDismissed')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ReceiptsTable receipts = $ReceiptsTable(this);
  late final $ReminderLogTable reminderLog = $ReminderLogTable(this);
  late final Index receiptsDateIdx = Index(
      'receipts_date_idx', 'CREATE INDEX receipts_date_idx ON receipts (date)');
  late final Index receiptsCategoryIdx = Index('receipts_category_idx',
      'CREATE INDEX receipts_category_idx ON receipts (category)');
  late final ReceiptsDao receiptsDao = ReceiptsDao(this as AppDatabase);
  late final RemindersDao remindersDao = RemindersDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [receipts, reminderLog, receiptsDateIdx, receiptsCategoryIdx];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('receipts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('reminder_log', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$ReceiptsTableCreateCompanionBuilder = ReceiptsCompanion Function({
  Value<int> id,
  required String storeName,
  required String date,
  required double totalAmount,
  Value<String> category,
  Value<String?> photoPath,
  Value<String?> itemsJson,
  Value<String?> notes,
  Value<bool> hasReminder,
  Value<String?> reminderType,
  Value<String?> reminderDate,
  Value<String?> notifDays,
  Value<bool> anomalyDetected,
  required String createdAt,
  required String updatedAt,
});
typedef $$ReceiptsTableUpdateCompanionBuilder = ReceiptsCompanion Function({
  Value<int> id,
  Value<String> storeName,
  Value<String> date,
  Value<double> totalAmount,
  Value<String> category,
  Value<String?> photoPath,
  Value<String?> itemsJson,
  Value<String?> notes,
  Value<bool> hasReminder,
  Value<String?> reminderType,
  Value<String?> reminderDate,
  Value<String?> notifDays,
  Value<bool> anomalyDetected,
  Value<String> createdAt,
  Value<String> updatedAt,
});

final class $$ReceiptsTableReferences
    extends BaseReferences<_$AppDatabase, $ReceiptsTable, Receipt> {
  $$ReceiptsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ReminderLogTable, List<ReminderLogData>>
      _reminderLogRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.reminderLog,
          aliasName:
              $_aliasNameGenerator(db.receipts.id, db.reminderLog.receiptId));

  $$ReminderLogTableProcessedTableManager get reminderLogRefs {
    final manager = $$ReminderLogTableTableManager($_db, $_db.reminderLog)
        .filter((f) => f.receiptId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_reminderLogRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ReceiptsTableFilterComposer
    extends Composer<_$AppDatabase, $ReceiptsTable> {
  $$ReceiptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get storeName => $composableBuilder(
      column: $table.storeName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get photoPath => $composableBuilder(
      column: $table.photoPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemsJson => $composableBuilder(
      column: $table.itemsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get hasReminder => $composableBuilder(
      column: $table.hasReminder, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reminderType => $composableBuilder(
      column: $table.reminderType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reminderDate => $composableBuilder(
      column: $table.reminderDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notifDays => $composableBuilder(
      column: $table.notifDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get anomalyDetected => $composableBuilder(
      column: $table.anomalyDetected,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> reminderLogRefs(
      Expression<bool> Function($$ReminderLogTableFilterComposer f) f) {
    final $$ReminderLogTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.reminderLog,
        getReferencedColumn: (t) => t.receiptId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReminderLogTableFilterComposer(
              $db: $db,
              $table: $db.reminderLog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ReceiptsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReceiptsTable> {
  $$ReceiptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get storeName => $composableBuilder(
      column: $table.storeName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get photoPath => $composableBuilder(
      column: $table.photoPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemsJson => $composableBuilder(
      column: $table.itemsJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get hasReminder => $composableBuilder(
      column: $table.hasReminder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reminderType => $composableBuilder(
      column: $table.reminderType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reminderDate => $composableBuilder(
      column: $table.reminderDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notifDays => $composableBuilder(
      column: $table.notifDays, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get anomalyDetected => $composableBuilder(
      column: $table.anomalyDetected,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ReceiptsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReceiptsTable> {
  $$ReceiptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get storeName =>
      $composableBuilder(column: $table.storeName, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<String> get itemsJson =>
      $composableBuilder(column: $table.itemsJson, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get hasReminder => $composableBuilder(
      column: $table.hasReminder, builder: (column) => column);

  GeneratedColumn<String> get reminderType => $composableBuilder(
      column: $table.reminderType, builder: (column) => column);

  GeneratedColumn<String> get reminderDate => $composableBuilder(
      column: $table.reminderDate, builder: (column) => column);

  GeneratedColumn<String> get notifDays =>
      $composableBuilder(column: $table.notifDays, builder: (column) => column);

  GeneratedColumn<bool> get anomalyDetected => $composableBuilder(
      column: $table.anomalyDetected, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> reminderLogRefs<T extends Object>(
      Expression<T> Function($$ReminderLogTableAnnotationComposer a) f) {
    final $$ReminderLogTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.reminderLog,
        getReferencedColumn: (t) => t.receiptId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReminderLogTableAnnotationComposer(
              $db: $db,
              $table: $db.reminderLog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ReceiptsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ReceiptsTable,
    Receipt,
    $$ReceiptsTableFilterComposer,
    $$ReceiptsTableOrderingComposer,
    $$ReceiptsTableAnnotationComposer,
    $$ReceiptsTableCreateCompanionBuilder,
    $$ReceiptsTableUpdateCompanionBuilder,
    (Receipt, $$ReceiptsTableReferences),
    Receipt,
    PrefetchHooks Function({bool reminderLogRefs})> {
  $$ReceiptsTableTableManager(_$AppDatabase db, $ReceiptsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReceiptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReceiptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReceiptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> storeName = const Value.absent(),
            Value<String> date = const Value.absent(),
            Value<double> totalAmount = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String?> photoPath = const Value.absent(),
            Value<String?> itemsJson = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<bool> hasReminder = const Value.absent(),
            Value<String?> reminderType = const Value.absent(),
            Value<String?> reminderDate = const Value.absent(),
            Value<String?> notifDays = const Value.absent(),
            Value<bool> anomalyDetected = const Value.absent(),
            Value<String> createdAt = const Value.absent(),
            Value<String> updatedAt = const Value.absent(),
          }) =>
              ReceiptsCompanion(
            id: id,
            storeName: storeName,
            date: date,
            totalAmount: totalAmount,
            category: category,
            photoPath: photoPath,
            itemsJson: itemsJson,
            notes: notes,
            hasReminder: hasReminder,
            reminderType: reminderType,
            reminderDate: reminderDate,
            notifDays: notifDays,
            anomalyDetected: anomalyDetected,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String storeName,
            required String date,
            required double totalAmount,
            Value<String> category = const Value.absent(),
            Value<String?> photoPath = const Value.absent(),
            Value<String?> itemsJson = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<bool> hasReminder = const Value.absent(),
            Value<String?> reminderType = const Value.absent(),
            Value<String?> reminderDate = const Value.absent(),
            Value<String?> notifDays = const Value.absent(),
            Value<bool> anomalyDetected = const Value.absent(),
            required String createdAt,
            required String updatedAt,
          }) =>
              ReceiptsCompanion.insert(
            id: id,
            storeName: storeName,
            date: date,
            totalAmount: totalAmount,
            category: category,
            photoPath: photoPath,
            itemsJson: itemsJson,
            notes: notes,
            hasReminder: hasReminder,
            reminderType: reminderType,
            reminderDate: reminderDate,
            notifDays: notifDays,
            anomalyDetected: anomalyDetected,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ReceiptsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({reminderLogRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (reminderLogRefs) db.reminderLog],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (reminderLogRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$ReceiptsTableReferences._reminderLogRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ReceiptsTableReferences(db, table, p0)
                                .reminderLogRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.receiptId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ReceiptsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ReceiptsTable,
    Receipt,
    $$ReceiptsTableFilterComposer,
    $$ReceiptsTableOrderingComposer,
    $$ReceiptsTableAnnotationComposer,
    $$ReceiptsTableCreateCompanionBuilder,
    $$ReceiptsTableUpdateCompanionBuilder,
    (Receipt, $$ReceiptsTableReferences),
    Receipt,
    PrefetchHooks Function({bool reminderLogRefs})>;
typedef $$ReminderLogTableCreateCompanionBuilder = ReminderLogCompanion
    Function({
  Value<int> id,
  required int receiptId,
  required String reminderType,
  required String scheduledDate,
  Value<bool> isSent,
  Value<bool> isDismissed,
});
typedef $$ReminderLogTableUpdateCompanionBuilder = ReminderLogCompanion
    Function({
  Value<int> id,
  Value<int> receiptId,
  Value<String> reminderType,
  Value<String> scheduledDate,
  Value<bool> isSent,
  Value<bool> isDismissed,
});

final class $$ReminderLogTableReferences
    extends BaseReferences<_$AppDatabase, $ReminderLogTable, ReminderLogData> {
  $$ReminderLogTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ReceiptsTable _receiptIdTable(_$AppDatabase db) =>
      db.receipts.createAlias(
          $_aliasNameGenerator(db.reminderLog.receiptId, db.receipts.id));

  $$ReceiptsTableProcessedTableManager? get receiptId {
    if ($_item.receiptId == null) return null;
    final manager = $$ReceiptsTableTableManager($_db, $_db.receipts)
        .filter((f) => f.id($_item.receiptId!));
    final item = $_typedResult.readTableOrNull(_receiptIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ReminderLogTableFilterComposer
    extends Composer<_$AppDatabase, $ReminderLogTable> {
  $$ReminderLogTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reminderType => $composableBuilder(
      column: $table.reminderType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scheduledDate => $composableBuilder(
      column: $table.scheduledDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSent => $composableBuilder(
      column: $table.isSent, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDismissed => $composableBuilder(
      column: $table.isDismissed, builder: (column) => ColumnFilters(column));

  $$ReceiptsTableFilterComposer get receiptId {
    final $$ReceiptsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.receiptId,
        referencedTable: $db.receipts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReceiptsTableFilterComposer(
              $db: $db,
              $table: $db.receipts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ReminderLogTableOrderingComposer
    extends Composer<_$AppDatabase, $ReminderLogTable> {
  $$ReminderLogTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reminderType => $composableBuilder(
      column: $table.reminderType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scheduledDate => $composableBuilder(
      column: $table.scheduledDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSent => $composableBuilder(
      column: $table.isSent, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDismissed => $composableBuilder(
      column: $table.isDismissed, builder: (column) => ColumnOrderings(column));

  $$ReceiptsTableOrderingComposer get receiptId {
    final $$ReceiptsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.receiptId,
        referencedTable: $db.receipts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReceiptsTableOrderingComposer(
              $db: $db,
              $table: $db.receipts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ReminderLogTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReminderLogTable> {
  $$ReminderLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get reminderType => $composableBuilder(
      column: $table.reminderType, builder: (column) => column);

  GeneratedColumn<String> get scheduledDate => $composableBuilder(
      column: $table.scheduledDate, builder: (column) => column);

  GeneratedColumn<bool> get isSent =>
      $composableBuilder(column: $table.isSent, builder: (column) => column);

  GeneratedColumn<bool> get isDismissed => $composableBuilder(
      column: $table.isDismissed, builder: (column) => column);

  $$ReceiptsTableAnnotationComposer get receiptId {
    final $$ReceiptsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.receiptId,
        referencedTable: $db.receipts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReceiptsTableAnnotationComposer(
              $db: $db,
              $table: $db.receipts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ReminderLogTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ReminderLogTable,
    ReminderLogData,
    $$ReminderLogTableFilterComposer,
    $$ReminderLogTableOrderingComposer,
    $$ReminderLogTableAnnotationComposer,
    $$ReminderLogTableCreateCompanionBuilder,
    $$ReminderLogTableUpdateCompanionBuilder,
    (ReminderLogData, $$ReminderLogTableReferences),
    ReminderLogData,
    PrefetchHooks Function({bool receiptId})> {
  $$ReminderLogTableTableManager(_$AppDatabase db, $ReminderLogTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReminderLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReminderLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReminderLogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> receiptId = const Value.absent(),
            Value<String> reminderType = const Value.absent(),
            Value<String> scheduledDate = const Value.absent(),
            Value<bool> isSent = const Value.absent(),
            Value<bool> isDismissed = const Value.absent(),
          }) =>
              ReminderLogCompanion(
            id: id,
            receiptId: receiptId,
            reminderType: reminderType,
            scheduledDate: scheduledDate,
            isSent: isSent,
            isDismissed: isDismissed,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int receiptId,
            required String reminderType,
            required String scheduledDate,
            Value<bool> isSent = const Value.absent(),
            Value<bool> isDismissed = const Value.absent(),
          }) =>
              ReminderLogCompanion.insert(
            id: id,
            receiptId: receiptId,
            reminderType: reminderType,
            scheduledDate: scheduledDate,
            isSent: isSent,
            isDismissed: isDismissed,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ReminderLogTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({receiptId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (receiptId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.receiptId,
                    referencedTable:
                        $$ReminderLogTableReferences._receiptIdTable(db),
                    referencedColumn:
                        $$ReminderLogTableReferences._receiptIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ReminderLogTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ReminderLogTable,
    ReminderLogData,
    $$ReminderLogTableFilterComposer,
    $$ReminderLogTableOrderingComposer,
    $$ReminderLogTableAnnotationComposer,
    $$ReminderLogTableCreateCompanionBuilder,
    $$ReminderLogTableUpdateCompanionBuilder,
    (ReminderLogData, $$ReminderLogTableReferences),
    ReminderLogData,
    PrefetchHooks Function({bool receiptId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ReceiptsTableTableManager get receipts =>
      $$ReceiptsTableTableManager(_db, _db.receipts);
  $$ReminderLogTableTableManager get reminderLog =>
      $$ReminderLogTableTableManager(_db, _db.reminderLog);
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PillsTable extends Pills with TableInfo<$PillsTable, Pill> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PillsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 255,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _initialQtyMeta = const VerificationMeta(
    'initialQty',
  );
  @override
  late final GeneratedColumn<int> initialQty = GeneratedColumn<int>(
    'initial_qty',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _initialUnitMeta = const VerificationMeta(
    'initialUnit',
  );
  @override
  late final GeneratedColumn<String> initialUnit = GeneratedColumn<String>(
    'initial_unit',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _initialNumMeta = const VerificationMeta(
    'initialNum',
  );
  @override
  late final GeneratedColumn<int> initialNum = GeneratedColumn<int>(
    'initial_num',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _initialDenMeta = const VerificationMeta(
    'initialDen',
  );
  @override
  late final GeneratedColumn<int> initialDen = GeneratedColumn<int>(
    'initial_den',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _qtyMeta = const VerificationMeta('qty');
  @override
  late final GeneratedColumn<int> qty = GeneratedColumn<int>(
    'qty',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _numeratorMeta = const VerificationMeta(
    'numerator',
  );
  @override
  late final GeneratedColumn<int> numerator = GeneratedColumn<int>(
    'numerator',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _denominatorMeta = const VerificationMeta(
    'denominator',
  );
  @override
  late final GeneratedColumn<int> denominator = GeneratedColumn<int>(
    'denominator',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _preferredUnitMeta = const VerificationMeta(
    'preferredUnit',
  );
  @override
  late final GeneratedColumn<String> preferredUnit = GeneratedColumn<String>(
    'preferred_unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _themeValueMeta = const VerificationMeta(
    'themeValue',
  );
  @override
  late final GeneratedColumn<int> themeValue = GeneratedColumn<int>(
    'theme_value',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    imagePath,
    initialQty,
    initialUnit,
    initialNum,
    initialDen,
    qty,
    numerator,
    denominator,
    preferredUnit,
    themeValue,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pills';
  @override
  VerificationContext validateIntegrity(
    Insertable<Pill> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    }
    if (data.containsKey('initial_qty')) {
      context.handle(
        _initialQtyMeta,
        initialQty.isAcceptableOrUnknown(data['initial_qty']!, _initialQtyMeta),
      );
    } else if (isInserting) {
      context.missing(_initialQtyMeta);
    }
    if (data.containsKey('initial_unit')) {
      context.handle(
        _initialUnitMeta,
        initialUnit.isAcceptableOrUnknown(
          data['initial_unit']!,
          _initialUnitMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_initialUnitMeta);
    }
    if (data.containsKey('initial_num')) {
      context.handle(
        _initialNumMeta,
        initialNum.isAcceptableOrUnknown(data['initial_num']!, _initialNumMeta),
      );
    }
    if (data.containsKey('initial_den')) {
      context.handle(
        _initialDenMeta,
        initialDen.isAcceptableOrUnknown(data['initial_den']!, _initialDenMeta),
      );
    }
    if (data.containsKey('qty')) {
      context.handle(
        _qtyMeta,
        qty.isAcceptableOrUnknown(data['qty']!, _qtyMeta),
      );
    } else if (isInserting) {
      context.missing(_qtyMeta);
    }
    if (data.containsKey('numerator')) {
      context.handle(
        _numeratorMeta,
        numerator.isAcceptableOrUnknown(data['numerator']!, _numeratorMeta),
      );
    }
    if (data.containsKey('denominator')) {
      context.handle(
        _denominatorMeta,
        denominator.isAcceptableOrUnknown(
          data['denominator']!,
          _denominatorMeta,
        ),
      );
    }
    if (data.containsKey('preferred_unit')) {
      context.handle(
        _preferredUnitMeta,
        preferredUnit.isAcceptableOrUnknown(
          data['preferred_unit']!,
          _preferredUnitMeta,
        ),
      );
    }
    if (data.containsKey('theme_value')) {
      context.handle(
        _themeValueMeta,
        themeValue.isAcceptableOrUnknown(data['theme_value']!, _themeValueMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Pill map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Pill(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
      initialQty:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}initial_qty'],
          )!,
      initialUnit:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}initial_unit'],
          )!,
      initialNum: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}initial_num'],
      ),
      initialDen: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}initial_den'],
      ),
      qty:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}qty'],
          )!,
      numerator: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}numerator'],
      ),
      denominator: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}denominator'],
      ),
      preferredUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preferred_unit'],
      ),
      themeValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}theme_value'],
      ),
    );
  }

  @override
  $PillsTable createAlias(String alias) {
    return $PillsTable(attachedDatabase, alias);
  }
}

class Pill extends DataClass implements Insertable<Pill> {
  final int id;
  final String name;
  final String? imagePath;
  final int initialQty;
  final String initialUnit;
  final int? initialNum;
  final int? initialDen;
  final int qty;
  final int? numerator;
  final int? denominator;
  final String? preferredUnit;
  final int? themeValue;
  const Pill({
    required this.id,
    required this.name,
    this.imagePath,
    required this.initialQty,
    required this.initialUnit,
    this.initialNum,
    this.initialDen,
    required this.qty,
    this.numerator,
    this.denominator,
    this.preferredUnit,
    this.themeValue,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    map['initial_qty'] = Variable<int>(initialQty);
    map['initial_unit'] = Variable<String>(initialUnit);
    if (!nullToAbsent || initialNum != null) {
      map['initial_num'] = Variable<int>(initialNum);
    }
    if (!nullToAbsent || initialDen != null) {
      map['initial_den'] = Variable<int>(initialDen);
    }
    map['qty'] = Variable<int>(qty);
    if (!nullToAbsent || numerator != null) {
      map['numerator'] = Variable<int>(numerator);
    }
    if (!nullToAbsent || denominator != null) {
      map['denominator'] = Variable<int>(denominator);
    }
    if (!nullToAbsent || preferredUnit != null) {
      map['preferred_unit'] = Variable<String>(preferredUnit);
    }
    if (!nullToAbsent || themeValue != null) {
      map['theme_value'] = Variable<int>(themeValue);
    }
    return map;
  }

  PillsCompanion toCompanion(bool nullToAbsent) {
    return PillsCompanion(
      id: Value(id),
      name: Value(name),
      imagePath:
          imagePath == null && nullToAbsent
              ? const Value.absent()
              : Value(imagePath),
      initialQty: Value(initialQty),
      initialUnit: Value(initialUnit),
      initialNum:
          initialNum == null && nullToAbsent
              ? const Value.absent()
              : Value(initialNum),
      initialDen:
          initialDen == null && nullToAbsent
              ? const Value.absent()
              : Value(initialDen),
      qty: Value(qty),
      numerator:
          numerator == null && nullToAbsent
              ? const Value.absent()
              : Value(numerator),
      denominator:
          denominator == null && nullToAbsent
              ? const Value.absent()
              : Value(denominator),
      preferredUnit:
          preferredUnit == null && nullToAbsent
              ? const Value.absent()
              : Value(preferredUnit),
      themeValue:
          themeValue == null && nullToAbsent
              ? const Value.absent()
              : Value(themeValue),
    );
  }

  factory Pill.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Pill(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      initialQty: serializer.fromJson<int>(json['initialQty']),
      initialUnit: serializer.fromJson<String>(json['initialUnit']),
      initialNum: serializer.fromJson<int?>(json['initialNum']),
      initialDen: serializer.fromJson<int?>(json['initialDen']),
      qty: serializer.fromJson<int>(json['qty']),
      numerator: serializer.fromJson<int?>(json['numerator']),
      denominator: serializer.fromJson<int?>(json['denominator']),
      preferredUnit: serializer.fromJson<String?>(json['preferredUnit']),
      themeValue: serializer.fromJson<int?>(json['themeValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'imagePath': serializer.toJson<String?>(imagePath),
      'initialQty': serializer.toJson<int>(initialQty),
      'initialUnit': serializer.toJson<String>(initialUnit),
      'initialNum': serializer.toJson<int?>(initialNum),
      'initialDen': serializer.toJson<int?>(initialDen),
      'qty': serializer.toJson<int>(qty),
      'numerator': serializer.toJson<int?>(numerator),
      'denominator': serializer.toJson<int?>(denominator),
      'preferredUnit': serializer.toJson<String?>(preferredUnit),
      'themeValue': serializer.toJson<int?>(themeValue),
    };
  }

  Pill copyWith({
    int? id,
    String? name,
    Value<String?> imagePath = const Value.absent(),
    int? initialQty,
    String? initialUnit,
    Value<int?> initialNum = const Value.absent(),
    Value<int?> initialDen = const Value.absent(),
    int? qty,
    Value<int?> numerator = const Value.absent(),
    Value<int?> denominator = const Value.absent(),
    Value<String?> preferredUnit = const Value.absent(),
    Value<int?> themeValue = const Value.absent(),
  }) => Pill(
    id: id ?? this.id,
    name: name ?? this.name,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
    initialQty: initialQty ?? this.initialQty,
    initialUnit: initialUnit ?? this.initialUnit,
    initialNum: initialNum.present ? initialNum.value : this.initialNum,
    initialDen: initialDen.present ? initialDen.value : this.initialDen,
    qty: qty ?? this.qty,
    numerator: numerator.present ? numerator.value : this.numerator,
    denominator: denominator.present ? denominator.value : this.denominator,
    preferredUnit:
        preferredUnit.present ? preferredUnit.value : this.preferredUnit,
    themeValue: themeValue.present ? themeValue.value : this.themeValue,
  );
  Pill copyWithCompanion(PillsCompanion data) {
    return Pill(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      initialQty:
          data.initialQty.present ? data.initialQty.value : this.initialQty,
      initialUnit:
          data.initialUnit.present ? data.initialUnit.value : this.initialUnit,
      initialNum:
          data.initialNum.present ? data.initialNum.value : this.initialNum,
      initialDen:
          data.initialDen.present ? data.initialDen.value : this.initialDen,
      qty: data.qty.present ? data.qty.value : this.qty,
      numerator: data.numerator.present ? data.numerator.value : this.numerator,
      denominator:
          data.denominator.present ? data.denominator.value : this.denominator,
      preferredUnit:
          data.preferredUnit.present
              ? data.preferredUnit.value
              : this.preferredUnit,
      themeValue:
          data.themeValue.present ? data.themeValue.value : this.themeValue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Pill(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('imagePath: $imagePath, ')
          ..write('initialQty: $initialQty, ')
          ..write('initialUnit: $initialUnit, ')
          ..write('initialNum: $initialNum, ')
          ..write('initialDen: $initialDen, ')
          ..write('qty: $qty, ')
          ..write('numerator: $numerator, ')
          ..write('denominator: $denominator, ')
          ..write('preferredUnit: $preferredUnit, ')
          ..write('themeValue: $themeValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    imagePath,
    initialQty,
    initialUnit,
    initialNum,
    initialDen,
    qty,
    numerator,
    denominator,
    preferredUnit,
    themeValue,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Pill &&
          other.id == this.id &&
          other.name == this.name &&
          other.imagePath == this.imagePath &&
          other.initialQty == this.initialQty &&
          other.initialUnit == this.initialUnit &&
          other.initialNum == this.initialNum &&
          other.initialDen == this.initialDen &&
          other.qty == this.qty &&
          other.numerator == this.numerator &&
          other.denominator == this.denominator &&
          other.preferredUnit == this.preferredUnit &&
          other.themeValue == this.themeValue);
}

class PillsCompanion extends UpdateCompanion<Pill> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> imagePath;
  final Value<int> initialQty;
  final Value<String> initialUnit;
  final Value<int?> initialNum;
  final Value<int?> initialDen;
  final Value<int> qty;
  final Value<int?> numerator;
  final Value<int?> denominator;
  final Value<String?> preferredUnit;
  final Value<int?> themeValue;
  const PillsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.initialQty = const Value.absent(),
    this.initialUnit = const Value.absent(),
    this.initialNum = const Value.absent(),
    this.initialDen = const Value.absent(),
    this.qty = const Value.absent(),
    this.numerator = const Value.absent(),
    this.denominator = const Value.absent(),
    this.preferredUnit = const Value.absent(),
    this.themeValue = const Value.absent(),
  });
  PillsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.imagePath = const Value.absent(),
    required int initialQty,
    required String initialUnit,
    this.initialNum = const Value.absent(),
    this.initialDen = const Value.absent(),
    required int qty,
    this.numerator = const Value.absent(),
    this.denominator = const Value.absent(),
    this.preferredUnit = const Value.absent(),
    this.themeValue = const Value.absent(),
  }) : name = Value(name),
       initialQty = Value(initialQty),
       initialUnit = Value(initialUnit),
       qty = Value(qty);
  static Insertable<Pill> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? imagePath,
    Expression<int>? initialQty,
    Expression<String>? initialUnit,
    Expression<int>? initialNum,
    Expression<int>? initialDen,
    Expression<int>? qty,
    Expression<int>? numerator,
    Expression<int>? denominator,
    Expression<String>? preferredUnit,
    Expression<int>? themeValue,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (imagePath != null) 'image_path': imagePath,
      if (initialQty != null) 'initial_qty': initialQty,
      if (initialUnit != null) 'initial_unit': initialUnit,
      if (initialNum != null) 'initial_num': initialNum,
      if (initialDen != null) 'initial_den': initialDen,
      if (qty != null) 'qty': qty,
      if (numerator != null) 'numerator': numerator,
      if (denominator != null) 'denominator': denominator,
      if (preferredUnit != null) 'preferred_unit': preferredUnit,
      if (themeValue != null) 'theme_value': themeValue,
    });
  }

  PillsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? imagePath,
    Value<int>? initialQty,
    Value<String>? initialUnit,
    Value<int?>? initialNum,
    Value<int?>? initialDen,
    Value<int>? qty,
    Value<int?>? numerator,
    Value<int?>? denominator,
    Value<String?>? preferredUnit,
    Value<int?>? themeValue,
  }) {
    return PillsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      initialQty: initialQty ?? this.initialQty,
      initialUnit: initialUnit ?? this.initialUnit,
      initialNum: initialNum ?? this.initialNum,
      initialDen: initialDen ?? this.initialDen,
      qty: qty ?? this.qty,
      numerator: numerator ?? this.numerator,
      denominator: denominator ?? this.denominator,
      preferredUnit: preferredUnit ?? this.preferredUnit,
      themeValue: themeValue ?? this.themeValue,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (initialQty.present) {
      map['initial_qty'] = Variable<int>(initialQty.value);
    }
    if (initialUnit.present) {
      map['initial_unit'] = Variable<String>(initialUnit.value);
    }
    if (initialNum.present) {
      map['initial_num'] = Variable<int>(initialNum.value);
    }
    if (initialDen.present) {
      map['initial_den'] = Variable<int>(initialDen.value);
    }
    if (qty.present) {
      map['qty'] = Variable<int>(qty.value);
    }
    if (numerator.present) {
      map['numerator'] = Variable<int>(numerator.value);
    }
    if (denominator.present) {
      map['denominator'] = Variable<int>(denominator.value);
    }
    if (preferredUnit.present) {
      map['preferred_unit'] = Variable<String>(preferredUnit.value);
    }
    if (themeValue.present) {
      map['theme_value'] = Variable<int>(themeValue.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PillsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('imagePath: $imagePath, ')
          ..write('initialQty: $initialQty, ')
          ..write('initialUnit: $initialUnit, ')
          ..write('initialNum: $initialNum, ')
          ..write('initialDen: $initialDen, ')
          ..write('qty: $qty, ')
          ..write('numerator: $numerator, ')
          ..write('denominator: $denominator, ')
          ..write('preferredUnit: $preferredUnit, ')
          ..write('themeValue: $themeValue')
          ..write(')'))
        .toString();
  }
}

class $SpecsTable extends Specs with TableInfo<$SpecsTable, Spec> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SpecsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _pillIdMeta = const VerificationMeta('pillId');
  @override
  late final GeneratedColumn<int> pillId = GeneratedColumn<int>(
    'pill_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES pills (id)',
    ),
  );
  static const VerificationMeta _qtyMeta = const VerificationMeta('qty');
  @override
  late final GeneratedColumn<int> qty = GeneratedColumn<int>(
    'qty',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, pillId, qty, unit, orderIndex];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'specs';
  @override
  VerificationContext validateIntegrity(
    Insertable<Spec> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pill_id')) {
      context.handle(
        _pillIdMeta,
        pillId.isAcceptableOrUnknown(data['pill_id']!, _pillIdMeta),
      );
    } else if (isInserting) {
      context.missing(_pillIdMeta);
    }
    if (data.containsKey('qty')) {
      context.handle(
        _qtyMeta,
        qty.isAcceptableOrUnknown(data['qty']!, _qtyMeta),
      );
    } else if (isInserting) {
      context.missing(_qtyMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Spec map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Spec(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      pillId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}pill_id'],
          )!,
      qty:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}qty'],
          )!,
      unit:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}unit'],
          )!,
      orderIndex:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}order_index'],
          )!,
    );
  }

  @override
  $SpecsTable createAlias(String alias) {
    return $SpecsTable(attachedDatabase, alias);
  }
}

class Spec extends DataClass implements Insertable<Spec> {
  final int id;
  final int pillId;
  final int qty;
  final String unit;
  final int orderIndex;
  const Spec({
    required this.id,
    required this.pillId,
    required this.qty,
    required this.unit,
    required this.orderIndex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['pill_id'] = Variable<int>(pillId);
    map['qty'] = Variable<int>(qty);
    map['unit'] = Variable<String>(unit);
    map['order_index'] = Variable<int>(orderIndex);
    return map;
  }

  SpecsCompanion toCompanion(bool nullToAbsent) {
    return SpecsCompanion(
      id: Value(id),
      pillId: Value(pillId),
      qty: Value(qty),
      unit: Value(unit),
      orderIndex: Value(orderIndex),
    );
  }

  factory Spec.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Spec(
      id: serializer.fromJson<int>(json['id']),
      pillId: serializer.fromJson<int>(json['pillId']),
      qty: serializer.fromJson<int>(json['qty']),
      unit: serializer.fromJson<String>(json['unit']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'pillId': serializer.toJson<int>(pillId),
      'qty': serializer.toJson<int>(qty),
      'unit': serializer.toJson<String>(unit),
      'orderIndex': serializer.toJson<int>(orderIndex),
    };
  }

  Spec copyWith({
    int? id,
    int? pillId,
    int? qty,
    String? unit,
    int? orderIndex,
  }) => Spec(
    id: id ?? this.id,
    pillId: pillId ?? this.pillId,
    qty: qty ?? this.qty,
    unit: unit ?? this.unit,
    orderIndex: orderIndex ?? this.orderIndex,
  );
  Spec copyWithCompanion(SpecsCompanion data) {
    return Spec(
      id: data.id.present ? data.id.value : this.id,
      pillId: data.pillId.present ? data.pillId.value : this.pillId,
      qty: data.qty.present ? data.qty.value : this.qty,
      unit: data.unit.present ? data.unit.value : this.unit,
      orderIndex:
          data.orderIndex.present ? data.orderIndex.value : this.orderIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Spec(')
          ..write('id: $id, ')
          ..write('pillId: $pillId, ')
          ..write('qty: $qty, ')
          ..write('unit: $unit, ')
          ..write('orderIndex: $orderIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, pillId, qty, unit, orderIndex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Spec &&
          other.id == this.id &&
          other.pillId == this.pillId &&
          other.qty == this.qty &&
          other.unit == this.unit &&
          other.orderIndex == this.orderIndex);
}

class SpecsCompanion extends UpdateCompanion<Spec> {
  final Value<int> id;
  final Value<int> pillId;
  final Value<int> qty;
  final Value<String> unit;
  final Value<int> orderIndex;
  const SpecsCompanion({
    this.id = const Value.absent(),
    this.pillId = const Value.absent(),
    this.qty = const Value.absent(),
    this.unit = const Value.absent(),
    this.orderIndex = const Value.absent(),
  });
  SpecsCompanion.insert({
    this.id = const Value.absent(),
    required int pillId,
    required int qty,
    required String unit,
    required int orderIndex,
  }) : pillId = Value(pillId),
       qty = Value(qty),
       unit = Value(unit),
       orderIndex = Value(orderIndex);
  static Insertable<Spec> custom({
    Expression<int>? id,
    Expression<int>? pillId,
    Expression<int>? qty,
    Expression<String>? unit,
    Expression<int>? orderIndex,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pillId != null) 'pill_id': pillId,
      if (qty != null) 'qty': qty,
      if (unit != null) 'unit': unit,
      if (orderIndex != null) 'order_index': orderIndex,
    });
  }

  SpecsCompanion copyWith({
    Value<int>? id,
    Value<int>? pillId,
    Value<int>? qty,
    Value<String>? unit,
    Value<int>? orderIndex,
  }) {
    return SpecsCompanion(
      id: id ?? this.id,
      pillId: pillId ?? this.pillId,
      qty: qty ?? this.qty,
      unit: unit ?? this.unit,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (pillId.present) {
      map['pill_id'] = Variable<int>(pillId.value);
    }
    if (qty.present) {
      map['qty'] = Variable<int>(qty.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SpecsCompanion(')
          ..write('id: $id, ')
          ..write('pillId: $pillId, ')
          ..write('qty: $qty, ')
          ..write('unit: $unit, ')
          ..write('orderIndex: $orderIndex')
          ..write(')'))
        .toString();
  }
}

class $PlansTable extends Plans with TableInfo<$PlansTable, Plan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _pillIdMeta = const VerificationMeta('pillId');
  @override
  late final GeneratedColumn<int> pillId = GeneratedColumn<int>(
    'pill_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES pills (id)',
    ),
  );
  static const VerificationMeta _isEnabledMeta = const VerificationMeta(
    'isEnabled',
  );
  @override
  late final GeneratedColumn<bool> isEnabled = GeneratedColumn<bool>(
    'is_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_enabled" IN (0, 1))',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 255,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qtyMeta = const VerificationMeta('qty');
  @override
  late final GeneratedColumn<int> qty = GeneratedColumn<int>(
    'qty',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _numeratorMeta = const VerificationMeta(
    'numerator',
  );
  @override
  late final GeneratedColumn<int> numerator = GeneratedColumn<int>(
    'numerator',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _denominatorMeta = const VerificationMeta(
    'denominator',
  );
  @override
  late final GeneratedColumn<int> denominator = GeneratedColumn<int>(
    'denominator',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<String> startDate = GeneratedColumn<String>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<String> endDate = GeneratedColumn<String>(
    'end_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repeatValuesMeta = const VerificationMeta(
    'repeatValues',
  );
  @override
  late final GeneratedColumn<String> repeatValues = GeneratedColumn<String>(
    'repeat_values',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repeatUnitMeta = const VerificationMeta(
    'repeatUnit',
  );
  @override
  late final GeneratedColumn<String> repeatUnit = GeneratedColumn<String>(
    'repeat_unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<String> startTime = GeneratedColumn<String>(
    'start_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isExactTimeMeta = const VerificationMeta(
    'isExactTime',
  );
  @override
  late final GeneratedColumn<bool> isExactTime = GeneratedColumn<bool>(
    'is_exact_time',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_exact_time" IN (0, 1))',
    ),
  );
  static const VerificationMeta _durationMeta = const VerificationMeta(
    'duration',
  );
  @override
  late final GeneratedColumn<int> duration = GeneratedColumn<int>(
    'duration',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationUnitMeta = const VerificationMeta(
    'durationUnit',
  );
  @override
  late final GeneratedColumn<String> durationUnit = GeneratedColumn<String>(
    'duration_unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reminderValueMeta = const VerificationMeta(
    'reminderValue',
  );
  @override
  late final GeneratedColumn<int> reminderValue = GeneratedColumn<int>(
    'reminder_value',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reminderUnitMeta = const VerificationMeta(
    'reminderUnit',
  );
  @override
  late final GeneratedColumn<String> reminderUnit = GeneratedColumn<String>(
    'reminder_unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reminderMethodMeta = const VerificationMeta(
    'reminderMethod',
  );
  @override
  late final GeneratedColumn<String> reminderMethod = GeneratedColumn<String>(
    'reminder_method',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    pillId,
    isEnabled,
    name,
    qty,
    unit,
    numerator,
    denominator,
    startDate,
    endDate,
    repeatValues,
    repeatUnit,
    startTime,
    isExactTime,
    duration,
    durationUnit,
    reminderValue,
    reminderUnit,
    reminderMethod,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plans';
  @override
  VerificationContext validateIntegrity(
    Insertable<Plan> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pill_id')) {
      context.handle(
        _pillIdMeta,
        pillId.isAcceptableOrUnknown(data['pill_id']!, _pillIdMeta),
      );
    } else if (isInserting) {
      context.missing(_pillIdMeta);
    }
    if (data.containsKey('is_enabled')) {
      context.handle(
        _isEnabledMeta,
        isEnabled.isAcceptableOrUnknown(data['is_enabled']!, _isEnabledMeta),
      );
    } else if (isInserting) {
      context.missing(_isEnabledMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('qty')) {
      context.handle(
        _qtyMeta,
        qty.isAcceptableOrUnknown(data['qty']!, _qtyMeta),
      );
    } else if (isInserting) {
      context.missing(_qtyMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('numerator')) {
      context.handle(
        _numeratorMeta,
        numerator.isAcceptableOrUnknown(data['numerator']!, _numeratorMeta),
      );
    }
    if (data.containsKey('denominator')) {
      context.handle(
        _denominatorMeta,
        denominator.isAcceptableOrUnknown(
          data['denominator']!,
          _denominatorMeta,
        ),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('repeat_values')) {
      context.handle(
        _repeatValuesMeta,
        repeatValues.isAcceptableOrUnknown(
          data['repeat_values']!,
          _repeatValuesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_repeatValuesMeta);
    }
    if (data.containsKey('repeat_unit')) {
      context.handle(
        _repeatUnitMeta,
        repeatUnit.isAcceptableOrUnknown(data['repeat_unit']!, _repeatUnitMeta),
      );
    } else if (isInserting) {
      context.missing(_repeatUnitMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('is_exact_time')) {
      context.handle(
        _isExactTimeMeta,
        isExactTime.isAcceptableOrUnknown(
          data['is_exact_time']!,
          _isExactTimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_isExactTimeMeta);
    }
    if (data.containsKey('duration')) {
      context.handle(
        _durationMeta,
        duration.isAcceptableOrUnknown(data['duration']!, _durationMeta),
      );
    }
    if (data.containsKey('duration_unit')) {
      context.handle(
        _durationUnitMeta,
        durationUnit.isAcceptableOrUnknown(
          data['duration_unit']!,
          _durationUnitMeta,
        ),
      );
    }
    if (data.containsKey('reminder_value')) {
      context.handle(
        _reminderValueMeta,
        reminderValue.isAcceptableOrUnknown(
          data['reminder_value']!,
          _reminderValueMeta,
        ),
      );
    }
    if (data.containsKey('reminder_unit')) {
      context.handle(
        _reminderUnitMeta,
        reminderUnit.isAcceptableOrUnknown(
          data['reminder_unit']!,
          _reminderUnitMeta,
        ),
      );
    }
    if (data.containsKey('reminder_method')) {
      context.handle(
        _reminderMethodMeta,
        reminderMethod.isAcceptableOrUnknown(
          data['reminder_method']!,
          _reminderMethodMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Plan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Plan(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      pillId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}pill_id'],
          )!,
      isEnabled:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_enabled'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      qty:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}qty'],
          )!,
      unit:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}unit'],
          )!,
      numerator: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}numerator'],
      ),
      denominator: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}denominator'],
      ),
      startDate:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}start_date'],
          )!,
      endDate:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}end_date'],
          )!,
      repeatValues:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}repeat_values'],
          )!,
      repeatUnit:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}repeat_unit'],
          )!,
      startTime:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}start_time'],
          )!,
      isExactTime:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_exact_time'],
          )!,
      duration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration'],
      ),
      durationUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}duration_unit'],
      ),
      reminderValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_value'],
      ),
      reminderUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reminder_unit'],
      ),
      reminderMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reminder_method'],
      ),
    );
  }

  @override
  $PlansTable createAlias(String alias) {
    return $PlansTable(attachedDatabase, alias);
  }
}

class Plan extends DataClass implements Insertable<Plan> {
  final int id;
  final int pillId;
  final bool isEnabled;
  final String name;
  final int qty;
  final String unit;
  final int? numerator;
  final int? denominator;
  final String startDate;
  final String endDate;
  final String repeatValues;
  final String repeatUnit;
  final String startTime;
  final bool isExactTime;
  final int? duration;
  final String? durationUnit;
  final int? reminderValue;
  final String? reminderUnit;
  final String? reminderMethod;
  const Plan({
    required this.id,
    required this.pillId,
    required this.isEnabled,
    required this.name,
    required this.qty,
    required this.unit,
    this.numerator,
    this.denominator,
    required this.startDate,
    required this.endDate,
    required this.repeatValues,
    required this.repeatUnit,
    required this.startTime,
    required this.isExactTime,
    this.duration,
    this.durationUnit,
    this.reminderValue,
    this.reminderUnit,
    this.reminderMethod,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['pill_id'] = Variable<int>(pillId);
    map['is_enabled'] = Variable<bool>(isEnabled);
    map['name'] = Variable<String>(name);
    map['qty'] = Variable<int>(qty);
    map['unit'] = Variable<String>(unit);
    if (!nullToAbsent || numerator != null) {
      map['numerator'] = Variable<int>(numerator);
    }
    if (!nullToAbsent || denominator != null) {
      map['denominator'] = Variable<int>(denominator);
    }
    map['start_date'] = Variable<String>(startDate);
    map['end_date'] = Variable<String>(endDate);
    map['repeat_values'] = Variable<String>(repeatValues);
    map['repeat_unit'] = Variable<String>(repeatUnit);
    map['start_time'] = Variable<String>(startTime);
    map['is_exact_time'] = Variable<bool>(isExactTime);
    if (!nullToAbsent || duration != null) {
      map['duration'] = Variable<int>(duration);
    }
    if (!nullToAbsent || durationUnit != null) {
      map['duration_unit'] = Variable<String>(durationUnit);
    }
    if (!nullToAbsent || reminderValue != null) {
      map['reminder_value'] = Variable<int>(reminderValue);
    }
    if (!nullToAbsent || reminderUnit != null) {
      map['reminder_unit'] = Variable<String>(reminderUnit);
    }
    if (!nullToAbsent || reminderMethod != null) {
      map['reminder_method'] = Variable<String>(reminderMethod);
    }
    return map;
  }

  PlansCompanion toCompanion(bool nullToAbsent) {
    return PlansCompanion(
      id: Value(id),
      pillId: Value(pillId),
      isEnabled: Value(isEnabled),
      name: Value(name),
      qty: Value(qty),
      unit: Value(unit),
      numerator:
          numerator == null && nullToAbsent
              ? const Value.absent()
              : Value(numerator),
      denominator:
          denominator == null && nullToAbsent
              ? const Value.absent()
              : Value(denominator),
      startDate: Value(startDate),
      endDate: Value(endDate),
      repeatValues: Value(repeatValues),
      repeatUnit: Value(repeatUnit),
      startTime: Value(startTime),
      isExactTime: Value(isExactTime),
      duration:
          duration == null && nullToAbsent
              ? const Value.absent()
              : Value(duration),
      durationUnit:
          durationUnit == null && nullToAbsent
              ? const Value.absent()
              : Value(durationUnit),
      reminderValue:
          reminderValue == null && nullToAbsent
              ? const Value.absent()
              : Value(reminderValue),
      reminderUnit:
          reminderUnit == null && nullToAbsent
              ? const Value.absent()
              : Value(reminderUnit),
      reminderMethod:
          reminderMethod == null && nullToAbsent
              ? const Value.absent()
              : Value(reminderMethod),
    );
  }

  factory Plan.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Plan(
      id: serializer.fromJson<int>(json['id']),
      pillId: serializer.fromJson<int>(json['pillId']),
      isEnabled: serializer.fromJson<bool>(json['isEnabled']),
      name: serializer.fromJson<String>(json['name']),
      qty: serializer.fromJson<int>(json['qty']),
      unit: serializer.fromJson<String>(json['unit']),
      numerator: serializer.fromJson<int?>(json['numerator']),
      denominator: serializer.fromJson<int?>(json['denominator']),
      startDate: serializer.fromJson<String>(json['startDate']),
      endDate: serializer.fromJson<String>(json['endDate']),
      repeatValues: serializer.fromJson<String>(json['repeatValues']),
      repeatUnit: serializer.fromJson<String>(json['repeatUnit']),
      startTime: serializer.fromJson<String>(json['startTime']),
      isExactTime: serializer.fromJson<bool>(json['isExactTime']),
      duration: serializer.fromJson<int?>(json['duration']),
      durationUnit: serializer.fromJson<String?>(json['durationUnit']),
      reminderValue: serializer.fromJson<int?>(json['reminderValue']),
      reminderUnit: serializer.fromJson<String?>(json['reminderUnit']),
      reminderMethod: serializer.fromJson<String?>(json['reminderMethod']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'pillId': serializer.toJson<int>(pillId),
      'isEnabled': serializer.toJson<bool>(isEnabled),
      'name': serializer.toJson<String>(name),
      'qty': serializer.toJson<int>(qty),
      'unit': serializer.toJson<String>(unit),
      'numerator': serializer.toJson<int?>(numerator),
      'denominator': serializer.toJson<int?>(denominator),
      'startDate': serializer.toJson<String>(startDate),
      'endDate': serializer.toJson<String>(endDate),
      'repeatValues': serializer.toJson<String>(repeatValues),
      'repeatUnit': serializer.toJson<String>(repeatUnit),
      'startTime': serializer.toJson<String>(startTime),
      'isExactTime': serializer.toJson<bool>(isExactTime),
      'duration': serializer.toJson<int?>(duration),
      'durationUnit': serializer.toJson<String?>(durationUnit),
      'reminderValue': serializer.toJson<int?>(reminderValue),
      'reminderUnit': serializer.toJson<String?>(reminderUnit),
      'reminderMethod': serializer.toJson<String?>(reminderMethod),
    };
  }

  Plan copyWith({
    int? id,
    int? pillId,
    bool? isEnabled,
    String? name,
    int? qty,
    String? unit,
    Value<int?> numerator = const Value.absent(),
    Value<int?> denominator = const Value.absent(),
    String? startDate,
    String? endDate,
    String? repeatValues,
    String? repeatUnit,
    String? startTime,
    bool? isExactTime,
    Value<int?> duration = const Value.absent(),
    Value<String?> durationUnit = const Value.absent(),
    Value<int?> reminderValue = const Value.absent(),
    Value<String?> reminderUnit = const Value.absent(),
    Value<String?> reminderMethod = const Value.absent(),
  }) => Plan(
    id: id ?? this.id,
    pillId: pillId ?? this.pillId,
    isEnabled: isEnabled ?? this.isEnabled,
    name: name ?? this.name,
    qty: qty ?? this.qty,
    unit: unit ?? this.unit,
    numerator: numerator.present ? numerator.value : this.numerator,
    denominator: denominator.present ? denominator.value : this.denominator,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    repeatValues: repeatValues ?? this.repeatValues,
    repeatUnit: repeatUnit ?? this.repeatUnit,
    startTime: startTime ?? this.startTime,
    isExactTime: isExactTime ?? this.isExactTime,
    duration: duration.present ? duration.value : this.duration,
    durationUnit: durationUnit.present ? durationUnit.value : this.durationUnit,
    reminderValue:
        reminderValue.present ? reminderValue.value : this.reminderValue,
    reminderUnit: reminderUnit.present ? reminderUnit.value : this.reminderUnit,
    reminderMethod:
        reminderMethod.present ? reminderMethod.value : this.reminderMethod,
  );
  Plan copyWithCompanion(PlansCompanion data) {
    return Plan(
      id: data.id.present ? data.id.value : this.id,
      pillId: data.pillId.present ? data.pillId.value : this.pillId,
      isEnabled: data.isEnabled.present ? data.isEnabled.value : this.isEnabled,
      name: data.name.present ? data.name.value : this.name,
      qty: data.qty.present ? data.qty.value : this.qty,
      unit: data.unit.present ? data.unit.value : this.unit,
      numerator: data.numerator.present ? data.numerator.value : this.numerator,
      denominator:
          data.denominator.present ? data.denominator.value : this.denominator,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      repeatValues:
          data.repeatValues.present
              ? data.repeatValues.value
              : this.repeatValues,
      repeatUnit:
          data.repeatUnit.present ? data.repeatUnit.value : this.repeatUnit,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      isExactTime:
          data.isExactTime.present ? data.isExactTime.value : this.isExactTime,
      duration: data.duration.present ? data.duration.value : this.duration,
      durationUnit:
          data.durationUnit.present
              ? data.durationUnit.value
              : this.durationUnit,
      reminderValue:
          data.reminderValue.present
              ? data.reminderValue.value
              : this.reminderValue,
      reminderUnit:
          data.reminderUnit.present
              ? data.reminderUnit.value
              : this.reminderUnit,
      reminderMethod:
          data.reminderMethod.present
              ? data.reminderMethod.value
              : this.reminderMethod,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Plan(')
          ..write('id: $id, ')
          ..write('pillId: $pillId, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('name: $name, ')
          ..write('qty: $qty, ')
          ..write('unit: $unit, ')
          ..write('numerator: $numerator, ')
          ..write('denominator: $denominator, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('repeatValues: $repeatValues, ')
          ..write('repeatUnit: $repeatUnit, ')
          ..write('startTime: $startTime, ')
          ..write('isExactTime: $isExactTime, ')
          ..write('duration: $duration, ')
          ..write('durationUnit: $durationUnit, ')
          ..write('reminderValue: $reminderValue, ')
          ..write('reminderUnit: $reminderUnit, ')
          ..write('reminderMethod: $reminderMethod')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    pillId,
    isEnabled,
    name,
    qty,
    unit,
    numerator,
    denominator,
    startDate,
    endDate,
    repeatValues,
    repeatUnit,
    startTime,
    isExactTime,
    duration,
    durationUnit,
    reminderValue,
    reminderUnit,
    reminderMethod,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Plan &&
          other.id == this.id &&
          other.pillId == this.pillId &&
          other.isEnabled == this.isEnabled &&
          other.name == this.name &&
          other.qty == this.qty &&
          other.unit == this.unit &&
          other.numerator == this.numerator &&
          other.denominator == this.denominator &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.repeatValues == this.repeatValues &&
          other.repeatUnit == this.repeatUnit &&
          other.startTime == this.startTime &&
          other.isExactTime == this.isExactTime &&
          other.duration == this.duration &&
          other.durationUnit == this.durationUnit &&
          other.reminderValue == this.reminderValue &&
          other.reminderUnit == this.reminderUnit &&
          other.reminderMethod == this.reminderMethod);
}

class PlansCompanion extends UpdateCompanion<Plan> {
  final Value<int> id;
  final Value<int> pillId;
  final Value<bool> isEnabled;
  final Value<String> name;
  final Value<int> qty;
  final Value<String> unit;
  final Value<int?> numerator;
  final Value<int?> denominator;
  final Value<String> startDate;
  final Value<String> endDate;
  final Value<String> repeatValues;
  final Value<String> repeatUnit;
  final Value<String> startTime;
  final Value<bool> isExactTime;
  final Value<int?> duration;
  final Value<String?> durationUnit;
  final Value<int?> reminderValue;
  final Value<String?> reminderUnit;
  final Value<String?> reminderMethod;
  const PlansCompanion({
    this.id = const Value.absent(),
    this.pillId = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.name = const Value.absent(),
    this.qty = const Value.absent(),
    this.unit = const Value.absent(),
    this.numerator = const Value.absent(),
    this.denominator = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.repeatValues = const Value.absent(),
    this.repeatUnit = const Value.absent(),
    this.startTime = const Value.absent(),
    this.isExactTime = const Value.absent(),
    this.duration = const Value.absent(),
    this.durationUnit = const Value.absent(),
    this.reminderValue = const Value.absent(),
    this.reminderUnit = const Value.absent(),
    this.reminderMethod = const Value.absent(),
  });
  PlansCompanion.insert({
    this.id = const Value.absent(),
    required int pillId,
    required bool isEnabled,
    required String name,
    required int qty,
    required String unit,
    this.numerator = const Value.absent(),
    this.denominator = const Value.absent(),
    required String startDate,
    required String endDate,
    required String repeatValues,
    required String repeatUnit,
    required String startTime,
    required bool isExactTime,
    this.duration = const Value.absent(),
    this.durationUnit = const Value.absent(),
    this.reminderValue = const Value.absent(),
    this.reminderUnit = const Value.absent(),
    this.reminderMethod = const Value.absent(),
  }) : pillId = Value(pillId),
       isEnabled = Value(isEnabled),
       name = Value(name),
       qty = Value(qty),
       unit = Value(unit),
       startDate = Value(startDate),
       endDate = Value(endDate),
       repeatValues = Value(repeatValues),
       repeatUnit = Value(repeatUnit),
       startTime = Value(startTime),
       isExactTime = Value(isExactTime);
  static Insertable<Plan> custom({
    Expression<int>? id,
    Expression<int>? pillId,
    Expression<bool>? isEnabled,
    Expression<String>? name,
    Expression<int>? qty,
    Expression<String>? unit,
    Expression<int>? numerator,
    Expression<int>? denominator,
    Expression<String>? startDate,
    Expression<String>? endDate,
    Expression<String>? repeatValues,
    Expression<String>? repeatUnit,
    Expression<String>? startTime,
    Expression<bool>? isExactTime,
    Expression<int>? duration,
    Expression<String>? durationUnit,
    Expression<int>? reminderValue,
    Expression<String>? reminderUnit,
    Expression<String>? reminderMethod,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pillId != null) 'pill_id': pillId,
      if (isEnabled != null) 'is_enabled': isEnabled,
      if (name != null) 'name': name,
      if (qty != null) 'qty': qty,
      if (unit != null) 'unit': unit,
      if (numerator != null) 'numerator': numerator,
      if (denominator != null) 'denominator': denominator,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (repeatValues != null) 'repeat_values': repeatValues,
      if (repeatUnit != null) 'repeat_unit': repeatUnit,
      if (startTime != null) 'start_time': startTime,
      if (isExactTime != null) 'is_exact_time': isExactTime,
      if (duration != null) 'duration': duration,
      if (durationUnit != null) 'duration_unit': durationUnit,
      if (reminderValue != null) 'reminder_value': reminderValue,
      if (reminderUnit != null) 'reminder_unit': reminderUnit,
      if (reminderMethod != null) 'reminder_method': reminderMethod,
    });
  }

  PlansCompanion copyWith({
    Value<int>? id,
    Value<int>? pillId,
    Value<bool>? isEnabled,
    Value<String>? name,
    Value<int>? qty,
    Value<String>? unit,
    Value<int?>? numerator,
    Value<int?>? denominator,
    Value<String>? startDate,
    Value<String>? endDate,
    Value<String>? repeatValues,
    Value<String>? repeatUnit,
    Value<String>? startTime,
    Value<bool>? isExactTime,
    Value<int?>? duration,
    Value<String?>? durationUnit,
    Value<int?>? reminderValue,
    Value<String?>? reminderUnit,
    Value<String?>? reminderMethod,
  }) {
    return PlansCompanion(
      id: id ?? this.id,
      pillId: pillId ?? this.pillId,
      isEnabled: isEnabled ?? this.isEnabled,
      name: name ?? this.name,
      qty: qty ?? this.qty,
      unit: unit ?? this.unit,
      numerator: numerator ?? this.numerator,
      denominator: denominator ?? this.denominator,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      repeatValues: repeatValues ?? this.repeatValues,
      repeatUnit: repeatUnit ?? this.repeatUnit,
      startTime: startTime ?? this.startTime,
      isExactTime: isExactTime ?? this.isExactTime,
      duration: duration ?? this.duration,
      durationUnit: durationUnit ?? this.durationUnit,
      reminderValue: reminderValue ?? this.reminderValue,
      reminderUnit: reminderUnit ?? this.reminderUnit,
      reminderMethod: reminderMethod ?? this.reminderMethod,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (pillId.present) {
      map['pill_id'] = Variable<int>(pillId.value);
    }
    if (isEnabled.present) {
      map['is_enabled'] = Variable<bool>(isEnabled.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (qty.present) {
      map['qty'] = Variable<int>(qty.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (numerator.present) {
      map['numerator'] = Variable<int>(numerator.value);
    }
    if (denominator.present) {
      map['denominator'] = Variable<int>(denominator.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<String>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<String>(endDate.value);
    }
    if (repeatValues.present) {
      map['repeat_values'] = Variable<String>(repeatValues.value);
    }
    if (repeatUnit.present) {
      map['repeat_unit'] = Variable<String>(repeatUnit.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<String>(startTime.value);
    }
    if (isExactTime.present) {
      map['is_exact_time'] = Variable<bool>(isExactTime.value);
    }
    if (duration.present) {
      map['duration'] = Variable<int>(duration.value);
    }
    if (durationUnit.present) {
      map['duration_unit'] = Variable<String>(durationUnit.value);
    }
    if (reminderValue.present) {
      map['reminder_value'] = Variable<int>(reminderValue.value);
    }
    if (reminderUnit.present) {
      map['reminder_unit'] = Variable<String>(reminderUnit.value);
    }
    if (reminderMethod.present) {
      map['reminder_method'] = Variable<String>(reminderMethod.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlansCompanion(')
          ..write('id: $id, ')
          ..write('pillId: $pillId, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('name: $name, ')
          ..write('qty: $qty, ')
          ..write('unit: $unit, ')
          ..write('numerator: $numerator, ')
          ..write('denominator: $denominator, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('repeatValues: $repeatValues, ')
          ..write('repeatUnit: $repeatUnit, ')
          ..write('startTime: $startTime, ')
          ..write('isExactTime: $isExactTime, ')
          ..write('duration: $duration, ')
          ..write('durationUnit: $durationUnit, ')
          ..write('reminderValue: $reminderValue, ')
          ..write('reminderUnit: $reminderUnit, ')
          ..write('reminderMethod: $reminderMethod')
          ..write(')'))
        .toString();
  }
}

class $CyclesTable extends Cycles with TableInfo<$CyclesTable, Cycle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CyclesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _planIdMeta = const VerificationMeta('planId');
  @override
  late final GeneratedColumn<int> planId = GeneratedColumn<int>(
    'plan_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES plans (id)',
    ),
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<int> value = GeneratedColumn<int>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isStopMeta = const VerificationMeta('isStop');
  @override
  late final GeneratedColumn<bool> isStop = GeneratedColumn<bool>(
    'is_stop',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_stop" IN (0, 1))',
    ),
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    planId,
    value,
    unit,
    isStop,
    orderIndex,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cycles';
  @override
  VerificationContext validateIntegrity(
    Insertable<Cycle> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('plan_id')) {
      context.handle(
        _planIdMeta,
        planId.isAcceptableOrUnknown(data['plan_id']!, _planIdMeta),
      );
    } else if (isInserting) {
      context.missing(_planIdMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('is_stop')) {
      context.handle(
        _isStopMeta,
        isStop.isAcceptableOrUnknown(data['is_stop']!, _isStopMeta),
      );
    } else if (isInserting) {
      context.missing(_isStopMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Cycle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Cycle(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      planId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}plan_id'],
          )!,
      value:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}value'],
          )!,
      unit:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}unit'],
          )!,
      isStop:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_stop'],
          )!,
      orderIndex:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}order_index'],
          )!,
    );
  }

  @override
  $CyclesTable createAlias(String alias) {
    return $CyclesTable(attachedDatabase, alias);
  }
}

class Cycle extends DataClass implements Insertable<Cycle> {
  final int id;
  final int planId;
  final int value;
  final String unit;
  final bool isStop;
  final int orderIndex;
  const Cycle({
    required this.id,
    required this.planId,
    required this.value,
    required this.unit,
    required this.isStop,
    required this.orderIndex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['plan_id'] = Variable<int>(planId);
    map['value'] = Variable<int>(value);
    map['unit'] = Variable<String>(unit);
    map['is_stop'] = Variable<bool>(isStop);
    map['order_index'] = Variable<int>(orderIndex);
    return map;
  }

  CyclesCompanion toCompanion(bool nullToAbsent) {
    return CyclesCompanion(
      id: Value(id),
      planId: Value(planId),
      value: Value(value),
      unit: Value(unit),
      isStop: Value(isStop),
      orderIndex: Value(orderIndex),
    );
  }

  factory Cycle.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Cycle(
      id: serializer.fromJson<int>(json['id']),
      planId: serializer.fromJson<int>(json['planId']),
      value: serializer.fromJson<int>(json['value']),
      unit: serializer.fromJson<String>(json['unit']),
      isStop: serializer.fromJson<bool>(json['isStop']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'planId': serializer.toJson<int>(planId),
      'value': serializer.toJson<int>(value),
      'unit': serializer.toJson<String>(unit),
      'isStop': serializer.toJson<bool>(isStop),
      'orderIndex': serializer.toJson<int>(orderIndex),
    };
  }

  Cycle copyWith({
    int? id,
    int? planId,
    int? value,
    String? unit,
    bool? isStop,
    int? orderIndex,
  }) => Cycle(
    id: id ?? this.id,
    planId: planId ?? this.planId,
    value: value ?? this.value,
    unit: unit ?? this.unit,
    isStop: isStop ?? this.isStop,
    orderIndex: orderIndex ?? this.orderIndex,
  );
  Cycle copyWithCompanion(CyclesCompanion data) {
    return Cycle(
      id: data.id.present ? data.id.value : this.id,
      planId: data.planId.present ? data.planId.value : this.planId,
      value: data.value.present ? data.value.value : this.value,
      unit: data.unit.present ? data.unit.value : this.unit,
      isStop: data.isStop.present ? data.isStop.value : this.isStop,
      orderIndex:
          data.orderIndex.present ? data.orderIndex.value : this.orderIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Cycle(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('value: $value, ')
          ..write('unit: $unit, ')
          ..write('isStop: $isStop, ')
          ..write('orderIndex: $orderIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, planId, value, unit, isStop, orderIndex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Cycle &&
          other.id == this.id &&
          other.planId == this.planId &&
          other.value == this.value &&
          other.unit == this.unit &&
          other.isStop == this.isStop &&
          other.orderIndex == this.orderIndex);
}

class CyclesCompanion extends UpdateCompanion<Cycle> {
  final Value<int> id;
  final Value<int> planId;
  final Value<int> value;
  final Value<String> unit;
  final Value<bool> isStop;
  final Value<int> orderIndex;
  const CyclesCompanion({
    this.id = const Value.absent(),
    this.planId = const Value.absent(),
    this.value = const Value.absent(),
    this.unit = const Value.absent(),
    this.isStop = const Value.absent(),
    this.orderIndex = const Value.absent(),
  });
  CyclesCompanion.insert({
    this.id = const Value.absent(),
    required int planId,
    required int value,
    required String unit,
    required bool isStop,
    required int orderIndex,
  }) : planId = Value(planId),
       value = Value(value),
       unit = Value(unit),
       isStop = Value(isStop),
       orderIndex = Value(orderIndex);
  static Insertable<Cycle> custom({
    Expression<int>? id,
    Expression<int>? planId,
    Expression<int>? value,
    Expression<String>? unit,
    Expression<bool>? isStop,
    Expression<int>? orderIndex,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (planId != null) 'plan_id': planId,
      if (value != null) 'value': value,
      if (unit != null) 'unit': unit,
      if (isStop != null) 'is_stop': isStop,
      if (orderIndex != null) 'order_index': orderIndex,
    });
  }

  CyclesCompanion copyWith({
    Value<int>? id,
    Value<int>? planId,
    Value<int>? value,
    Value<String>? unit,
    Value<bool>? isStop,
    Value<int>? orderIndex,
  }) {
    return CyclesCompanion(
      id: id ?? this.id,
      planId: planId ?? this.planId,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      isStop: isStop ?? this.isStop,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (planId.present) {
      map['plan_id'] = Variable<int>(planId.value);
    }
    if (value.present) {
      map['value'] = Variable<int>(value.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (isStop.present) {
      map['is_stop'] = Variable<bool>(isStop.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CyclesCompanion(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('value: $value, ')
          ..write('unit: $unit, ')
          ..write('isStop: $isStop, ')
          ..write('orderIndex: $orderIndex')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _pillIdMeta = const VerificationMeta('pillId');
  @override
  late final GeneratedColumn<int> pillId = GeneratedColumn<int>(
    'pill_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES pills (id)',
    ),
  );
  static const VerificationMeta _planIdMeta = const VerificationMeta('planId');
  @override
  late final GeneratedColumn<int> planId = GeneratedColumn<int>(
    'plan_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES plans (id)',
    ),
  );
  static const VerificationMeta _calcQtyMeta = const VerificationMeta(
    'calcQty',
  );
  @override
  late final GeneratedColumn<String> calcQty = GeneratedColumn<String>(
    'calc_qty',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(""),
  );
  static const VerificationMeta _isNegativeMeta = const VerificationMeta(
    'isNegative',
  );
  @override
  late final GeneratedColumn<bool> isNegative = GeneratedColumn<bool>(
    'is_negative',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_negative" IN (0, 1))',
    ),
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remarkMeta = const VerificationMeta('remark');
  @override
  late final GeneratedColumn<String> remark = GeneratedColumn<String>(
    'remark',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCustomMeta = const VerificationMeta(
    'isCustom',
  );
  @override
  late final GeneratedColumn<bool> isCustom = GeneratedColumn<bool>(
    'is_custom',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_custom" IN (0, 1))',
    ),
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
    'start_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
    'end_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    pillId,
    planId,
    calcQty,
    isNegative,
    timestamp,
    remark,
    isCustom,
    startTime,
    endTime,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Transaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pill_id')) {
      context.handle(
        _pillIdMeta,
        pillId.isAcceptableOrUnknown(data['pill_id']!, _pillIdMeta),
      );
    } else if (isInserting) {
      context.missing(_pillIdMeta);
    }
    if (data.containsKey('plan_id')) {
      context.handle(
        _planIdMeta,
        planId.isAcceptableOrUnknown(data['plan_id']!, _planIdMeta),
      );
    }
    if (data.containsKey('calc_qty')) {
      context.handle(
        _calcQtyMeta,
        calcQty.isAcceptableOrUnknown(data['calc_qty']!, _calcQtyMeta),
      );
    }
    if (data.containsKey('is_negative')) {
      context.handle(
        _isNegativeMeta,
        isNegative.isAcceptableOrUnknown(data['is_negative']!, _isNegativeMeta),
      );
    } else if (isInserting) {
      context.missing(_isNegativeMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('remark')) {
      context.handle(
        _remarkMeta,
        remark.isAcceptableOrUnknown(data['remark']!, _remarkMeta),
      );
    }
    if (data.containsKey('is_custom')) {
      context.handle(
        _isCustomMeta,
        isCustom.isAcceptableOrUnknown(data['is_custom']!, _isCustomMeta),
      );
    } else if (isInserting) {
      context.missing(_isCustomMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      pillId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}pill_id'],
          )!,
      planId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}plan_id'],
      ),
      calcQty:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}calc_qty'],
          )!,
      isNegative:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_negative'],
          )!,
      timestamp:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}timestamp'],
          )!,
      remark: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remark'],
      ),
      isCustom:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_custom'],
          )!,
      startTime:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}start_time'],
          )!,
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_time'],
      ),
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final int id;
  final int pillId;
  final int? planId;
  final String calcQty;
  final bool isNegative;
  final DateTime timestamp;
  final String? remark;
  final bool isCustom;
  final DateTime startTime;
  final DateTime? endTime;
  const Transaction({
    required this.id,
    required this.pillId,
    this.planId,
    required this.calcQty,
    required this.isNegative,
    required this.timestamp,
    this.remark,
    required this.isCustom,
    required this.startTime,
    this.endTime,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['pill_id'] = Variable<int>(pillId);
    if (!nullToAbsent || planId != null) {
      map['plan_id'] = Variable<int>(planId);
    }
    map['calc_qty'] = Variable<String>(calcQty);
    map['is_negative'] = Variable<bool>(isNegative);
    map['timestamp'] = Variable<DateTime>(timestamp);
    if (!nullToAbsent || remark != null) {
      map['remark'] = Variable<String>(remark);
    }
    map['is_custom'] = Variable<bool>(isCustom);
    map['start_time'] = Variable<DateTime>(startTime);
    if (!nullToAbsent || endTime != null) {
      map['end_time'] = Variable<DateTime>(endTime);
    }
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      pillId: Value(pillId),
      planId:
          planId == null && nullToAbsent ? const Value.absent() : Value(planId),
      calcQty: Value(calcQty),
      isNegative: Value(isNegative),
      timestamp: Value(timestamp),
      remark:
          remark == null && nullToAbsent ? const Value.absent() : Value(remark),
      isCustom: Value(isCustom),
      startTime: Value(startTime),
      endTime:
          endTime == null && nullToAbsent
              ? const Value.absent()
              : Value(endTime),
    );
  }

  factory Transaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<int>(json['id']),
      pillId: serializer.fromJson<int>(json['pillId']),
      planId: serializer.fromJson<int?>(json['planId']),
      calcQty: serializer.fromJson<String>(json['calcQty']),
      isNegative: serializer.fromJson<bool>(json['isNegative']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      remark: serializer.fromJson<String?>(json['remark']),
      isCustom: serializer.fromJson<bool>(json['isCustom']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime?>(json['endTime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'pillId': serializer.toJson<int>(pillId),
      'planId': serializer.toJson<int?>(planId),
      'calcQty': serializer.toJson<String>(calcQty),
      'isNegative': serializer.toJson<bool>(isNegative),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'remark': serializer.toJson<String?>(remark),
      'isCustom': serializer.toJson<bool>(isCustom),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime?>(endTime),
    };
  }

  Transaction copyWith({
    int? id,
    int? pillId,
    Value<int?> planId = const Value.absent(),
    String? calcQty,
    bool? isNegative,
    DateTime? timestamp,
    Value<String?> remark = const Value.absent(),
    bool? isCustom,
    DateTime? startTime,
    Value<DateTime?> endTime = const Value.absent(),
  }) => Transaction(
    id: id ?? this.id,
    pillId: pillId ?? this.pillId,
    planId: planId.present ? planId.value : this.planId,
    calcQty: calcQty ?? this.calcQty,
    isNegative: isNegative ?? this.isNegative,
    timestamp: timestamp ?? this.timestamp,
    remark: remark.present ? remark.value : this.remark,
    isCustom: isCustom ?? this.isCustom,
    startTime: startTime ?? this.startTime,
    endTime: endTime.present ? endTime.value : this.endTime,
  );
  Transaction copyWithCompanion(TransactionsCompanion data) {
    return Transaction(
      id: data.id.present ? data.id.value : this.id,
      pillId: data.pillId.present ? data.pillId.value : this.pillId,
      planId: data.planId.present ? data.planId.value : this.planId,
      calcQty: data.calcQty.present ? data.calcQty.value : this.calcQty,
      isNegative:
          data.isNegative.present ? data.isNegative.value : this.isNegative,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      remark: data.remark.present ? data.remark.value : this.remark,
      isCustom: data.isCustom.present ? data.isCustom.value : this.isCustom,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('id: $id, ')
          ..write('pillId: $pillId, ')
          ..write('planId: $planId, ')
          ..write('calcQty: $calcQty, ')
          ..write('isNegative: $isNegative, ')
          ..write('timestamp: $timestamp, ')
          ..write('remark: $remark, ')
          ..write('isCustom: $isCustom, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    pillId,
    planId,
    calcQty,
    isNegative,
    timestamp,
    remark,
    isCustom,
    startTime,
    endTime,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.pillId == this.pillId &&
          other.planId == this.planId &&
          other.calcQty == this.calcQty &&
          other.isNegative == this.isNegative &&
          other.timestamp == this.timestamp &&
          other.remark == this.remark &&
          other.isCustom == this.isCustom &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<int> id;
  final Value<int> pillId;
  final Value<int?> planId;
  final Value<String> calcQty;
  final Value<bool> isNegative;
  final Value<DateTime> timestamp;
  final Value<String?> remark;
  final Value<bool> isCustom;
  final Value<DateTime> startTime;
  final Value<DateTime?> endTime;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.pillId = const Value.absent(),
    this.planId = const Value.absent(),
    this.calcQty = const Value.absent(),
    this.isNegative = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.remark = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.id = const Value.absent(),
    required int pillId,
    this.planId = const Value.absent(),
    this.calcQty = const Value.absent(),
    required bool isNegative,
    required DateTime timestamp,
    this.remark = const Value.absent(),
    required bool isCustom,
    required DateTime startTime,
    this.endTime = const Value.absent(),
  }) : pillId = Value(pillId),
       isNegative = Value(isNegative),
       timestamp = Value(timestamp),
       isCustom = Value(isCustom),
       startTime = Value(startTime);
  static Insertable<Transaction> custom({
    Expression<int>? id,
    Expression<int>? pillId,
    Expression<int>? planId,
    Expression<String>? calcQty,
    Expression<bool>? isNegative,
    Expression<DateTime>? timestamp,
    Expression<String>? remark,
    Expression<bool>? isCustom,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pillId != null) 'pill_id': pillId,
      if (planId != null) 'plan_id': planId,
      if (calcQty != null) 'calc_qty': calcQty,
      if (isNegative != null) 'is_negative': isNegative,
      if (timestamp != null) 'timestamp': timestamp,
      if (remark != null) 'remark': remark,
      if (isCustom != null) 'is_custom': isCustom,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
    });
  }

  TransactionsCompanion copyWith({
    Value<int>? id,
    Value<int>? pillId,
    Value<int?>? planId,
    Value<String>? calcQty,
    Value<bool>? isNegative,
    Value<DateTime>? timestamp,
    Value<String?>? remark,
    Value<bool>? isCustom,
    Value<DateTime>? startTime,
    Value<DateTime?>? endTime,
  }) {
    return TransactionsCompanion(
      id: id ?? this.id,
      pillId: pillId ?? this.pillId,
      planId: planId ?? this.planId,
      calcQty: calcQty ?? this.calcQty,
      isNegative: isNegative ?? this.isNegative,
      timestamp: timestamp ?? this.timestamp,
      remark: remark ?? this.remark,
      isCustom: isCustom ?? this.isCustom,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (pillId.present) {
      map['pill_id'] = Variable<int>(pillId.value);
    }
    if (planId.present) {
      map['plan_id'] = Variable<int>(planId.value);
    }
    if (calcQty.present) {
      map['calc_qty'] = Variable<String>(calcQty.value);
    }
    if (isNegative.present) {
      map['is_negative'] = Variable<bool>(isNegative.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (remark.present) {
      map['remark'] = Variable<String>(remark.value);
    }
    if (isCustom.present) {
      map['is_custom'] = Variable<bool>(isCustom.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('pillId: $pillId, ')
          ..write('planId: $planId, ')
          ..write('calcQty: $calcQty, ')
          ..write('isNegative: $isNegative, ')
          ..write('timestamp: $timestamp, ')
          ..write('remark: $remark, ')
          ..write('isCustom: $isCustom, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime')
          ..write(')'))
        .toString();
  }
}

class $QuantitiesTable extends Quantities
    with TableInfo<$QuantitiesTable, Quantity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuantitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _transactionIdMeta = const VerificationMeta(
    'transactionId',
  );
  @override
  late final GeneratedColumn<int> transactionId = GeneratedColumn<int>(
    'transaction_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES transactions (id)',
    ),
  );
  static const VerificationMeta _qtyMeta = const VerificationMeta('qty');
  @override
  late final GeneratedColumn<int> qty = GeneratedColumn<int>(
    'qty',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _numeratorMeta = const VerificationMeta(
    'numerator',
  );
  @override
  late final GeneratedColumn<int> numerator = GeneratedColumn<int>(
    'numerator',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _denominatorMeta = const VerificationMeta(
    'denominator',
  );
  @override
  late final GeneratedColumn<int> denominator = GeneratedColumn<int>(
    'denominator',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    transactionId,
    qty,
    unit,
    numerator,
    denominator,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quantities';
  @override
  VerificationContext validateIntegrity(
    Insertable<Quantity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
        _transactionIdMeta,
        transactionId.isAcceptableOrUnknown(
          data['transaction_id']!,
          _transactionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionIdMeta);
    }
    if (data.containsKey('qty')) {
      context.handle(
        _qtyMeta,
        qty.isAcceptableOrUnknown(data['qty']!, _qtyMeta),
      );
    } else if (isInserting) {
      context.missing(_qtyMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('numerator')) {
      context.handle(
        _numeratorMeta,
        numerator.isAcceptableOrUnknown(data['numerator']!, _numeratorMeta),
      );
    }
    if (data.containsKey('denominator')) {
      context.handle(
        _denominatorMeta,
        denominator.isAcceptableOrUnknown(
          data['denominator']!,
          _denominatorMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Quantity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Quantity(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      transactionId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}transaction_id'],
          )!,
      qty:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}qty'],
          )!,
      unit:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}unit'],
          )!,
      numerator: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}numerator'],
      ),
      denominator: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}denominator'],
      ),
    );
  }

  @override
  $QuantitiesTable createAlias(String alias) {
    return $QuantitiesTable(attachedDatabase, alias);
  }
}

class Quantity extends DataClass implements Insertable<Quantity> {
  final int id;
  final int transactionId;
  final int qty;
  final String unit;
  final int? numerator;
  final int? denominator;
  const Quantity({
    required this.id,
    required this.transactionId,
    required this.qty,
    required this.unit,
    this.numerator,
    this.denominator,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['transaction_id'] = Variable<int>(transactionId);
    map['qty'] = Variable<int>(qty);
    map['unit'] = Variable<String>(unit);
    if (!nullToAbsent || numerator != null) {
      map['numerator'] = Variable<int>(numerator);
    }
    if (!nullToAbsent || denominator != null) {
      map['denominator'] = Variable<int>(denominator);
    }
    return map;
  }

  QuantitiesCompanion toCompanion(bool nullToAbsent) {
    return QuantitiesCompanion(
      id: Value(id),
      transactionId: Value(transactionId),
      qty: Value(qty),
      unit: Value(unit),
      numerator:
          numerator == null && nullToAbsent
              ? const Value.absent()
              : Value(numerator),
      denominator:
          denominator == null && nullToAbsent
              ? const Value.absent()
              : Value(denominator),
    );
  }

  factory Quantity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Quantity(
      id: serializer.fromJson<int>(json['id']),
      transactionId: serializer.fromJson<int>(json['transactionId']),
      qty: serializer.fromJson<int>(json['qty']),
      unit: serializer.fromJson<String>(json['unit']),
      numerator: serializer.fromJson<int?>(json['numerator']),
      denominator: serializer.fromJson<int?>(json['denominator']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'transactionId': serializer.toJson<int>(transactionId),
      'qty': serializer.toJson<int>(qty),
      'unit': serializer.toJson<String>(unit),
      'numerator': serializer.toJson<int?>(numerator),
      'denominator': serializer.toJson<int?>(denominator),
    };
  }

  Quantity copyWith({
    int? id,
    int? transactionId,
    int? qty,
    String? unit,
    Value<int?> numerator = const Value.absent(),
    Value<int?> denominator = const Value.absent(),
  }) => Quantity(
    id: id ?? this.id,
    transactionId: transactionId ?? this.transactionId,
    qty: qty ?? this.qty,
    unit: unit ?? this.unit,
    numerator: numerator.present ? numerator.value : this.numerator,
    denominator: denominator.present ? denominator.value : this.denominator,
  );
  Quantity copyWithCompanion(QuantitiesCompanion data) {
    return Quantity(
      id: data.id.present ? data.id.value : this.id,
      transactionId:
          data.transactionId.present
              ? data.transactionId.value
              : this.transactionId,
      qty: data.qty.present ? data.qty.value : this.qty,
      unit: data.unit.present ? data.unit.value : this.unit,
      numerator: data.numerator.present ? data.numerator.value : this.numerator,
      denominator:
          data.denominator.present ? data.denominator.value : this.denominator,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Quantity(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('qty: $qty, ')
          ..write('unit: $unit, ')
          ..write('numerator: $numerator, ')
          ..write('denominator: $denominator')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, transactionId, qty, unit, numerator, denominator);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Quantity &&
          other.id == this.id &&
          other.transactionId == this.transactionId &&
          other.qty == this.qty &&
          other.unit == this.unit &&
          other.numerator == this.numerator &&
          other.denominator == this.denominator);
}

class QuantitiesCompanion extends UpdateCompanion<Quantity> {
  final Value<int> id;
  final Value<int> transactionId;
  final Value<int> qty;
  final Value<String> unit;
  final Value<int?> numerator;
  final Value<int?> denominator;
  const QuantitiesCompanion({
    this.id = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.qty = const Value.absent(),
    this.unit = const Value.absent(),
    this.numerator = const Value.absent(),
    this.denominator = const Value.absent(),
  });
  QuantitiesCompanion.insert({
    this.id = const Value.absent(),
    required int transactionId,
    required int qty,
    required String unit,
    this.numerator = const Value.absent(),
    this.denominator = const Value.absent(),
  }) : transactionId = Value(transactionId),
       qty = Value(qty),
       unit = Value(unit);
  static Insertable<Quantity> custom({
    Expression<int>? id,
    Expression<int>? transactionId,
    Expression<int>? qty,
    Expression<String>? unit,
    Expression<int>? numerator,
    Expression<int>? denominator,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transactionId != null) 'transaction_id': transactionId,
      if (qty != null) 'qty': qty,
      if (unit != null) 'unit': unit,
      if (numerator != null) 'numerator': numerator,
      if (denominator != null) 'denominator': denominator,
    });
  }

  QuantitiesCompanion copyWith({
    Value<int>? id,
    Value<int>? transactionId,
    Value<int>? qty,
    Value<String>? unit,
    Value<int?>? numerator,
    Value<int?>? denominator,
  }) {
    return QuantitiesCompanion(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      qty: qty ?? this.qty,
      unit: unit ?? this.unit,
      numerator: numerator ?? this.numerator,
      denominator: denominator ?? this.denominator,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<int>(transactionId.value);
    }
    if (qty.present) {
      map['qty'] = Variable<int>(qty.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (numerator.present) {
      map['numerator'] = Variable<int>(numerator.value);
    }
    if (denominator.present) {
      map['denominator'] = Variable<int>(denominator.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuantitiesCompanion(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('qty: $qty, ')
          ..write('unit: $unit, ')
          ..write('numerator: $numerator, ')
          ..write('denominator: $denominator')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PillsTable pills = $PillsTable(this);
  late final $SpecsTable specs = $SpecsTable(this);
  late final $PlansTable plans = $PlansTable(this);
  late final $CyclesTable cycles = $CyclesTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $QuantitiesTable quantities = $QuantitiesTable(this);
  late final PillDao pillDao = PillDao(this as AppDatabase);
  late final PlanDao planDao = PlanDao(this as AppDatabase);
  late final TransactionDao transactionDao = TransactionDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    pills,
    specs,
    plans,
    cycles,
    transactions,
    quantities,
  ];
}

typedef $$PillsTableCreateCompanionBuilder =
    PillsCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> imagePath,
      required int initialQty,
      required String initialUnit,
      Value<int?> initialNum,
      Value<int?> initialDen,
      required int qty,
      Value<int?> numerator,
      Value<int?> denominator,
      Value<String?> preferredUnit,
      Value<int?> themeValue,
    });
typedef $$PillsTableUpdateCompanionBuilder =
    PillsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> imagePath,
      Value<int> initialQty,
      Value<String> initialUnit,
      Value<int?> initialNum,
      Value<int?> initialDen,
      Value<int> qty,
      Value<int?> numerator,
      Value<int?> denominator,
      Value<String?> preferredUnit,
      Value<int?> themeValue,
    });

final class $$PillsTableReferences
    extends BaseReferences<_$AppDatabase, $PillsTable, Pill> {
  $$PillsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SpecsTable, List<Spec>> _specsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.specs,
    aliasName: $_aliasNameGenerator(db.pills.id, db.specs.pillId),
  );

  $$SpecsTableProcessedTableManager get specsRefs {
    final manager = $$SpecsTableTableManager(
      $_db,
      $_db.specs,
    ).filter((f) => f.pillId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_specsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PlansTable, List<Plan>> _plansRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.plans,
    aliasName: $_aliasNameGenerator(db.pills.id, db.plans.pillId),
  );

  $$PlansTableProcessedTableManager get plansRefs {
    final manager = $$PlansTableTableManager(
      $_db,
      $_db.plans,
    ).filter((f) => f.pillId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_plansRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
  _transactionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactions,
    aliasName: $_aliasNameGenerator(db.pills.id, db.transactions.pillId),
  );

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.pillId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PillsTableFilterComposer extends Composer<_$AppDatabase, $PillsTable> {
  $$PillsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get initialQty => $composableBuilder(
    column: $table.initialQty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get initialUnit => $composableBuilder(
    column: $table.initialUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get initialNum => $composableBuilder(
    column: $table.initialNum,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get initialDen => $composableBuilder(
    column: $table.initialDen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get numerator => $composableBuilder(
    column: $table.numerator,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get denominator => $composableBuilder(
    column: $table.denominator,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preferredUnit => $composableBuilder(
    column: $table.preferredUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get themeValue => $composableBuilder(
    column: $table.themeValue,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> specsRefs(
    Expression<bool> Function($$SpecsTableFilterComposer f) f,
  ) {
    final $$SpecsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.specs,
      getReferencedColumn: (t) => t.pillId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SpecsTableFilterComposer(
            $db: $db,
            $table: $db.specs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> plansRefs(
    Expression<bool> Function($$PlansTableFilterComposer f) f,
  ) {
    final $$PlansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.plans,
      getReferencedColumn: (t) => t.pillId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlansTableFilterComposer(
            $db: $db,
            $table: $db.plans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> transactionsRefs(
    Expression<bool> Function($$TransactionsTableFilterComposer f) f,
  ) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.pillId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PillsTableOrderingComposer
    extends Composer<_$AppDatabase, $PillsTable> {
  $$PillsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get initialQty => $composableBuilder(
    column: $table.initialQty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get initialUnit => $composableBuilder(
    column: $table.initialUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get initialNum => $composableBuilder(
    column: $table.initialNum,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get initialDen => $composableBuilder(
    column: $table.initialDen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get numerator => $composableBuilder(
    column: $table.numerator,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get denominator => $composableBuilder(
    column: $table.denominator,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preferredUnit => $composableBuilder(
    column: $table.preferredUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get themeValue => $composableBuilder(
    column: $table.themeValue,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PillsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PillsTable> {
  $$PillsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<int> get initialQty => $composableBuilder(
    column: $table.initialQty,
    builder: (column) => column,
  );

  GeneratedColumn<String> get initialUnit => $composableBuilder(
    column: $table.initialUnit,
    builder: (column) => column,
  );

  GeneratedColumn<int> get initialNum => $composableBuilder(
    column: $table.initialNum,
    builder: (column) => column,
  );

  GeneratedColumn<int> get initialDen => $composableBuilder(
    column: $table.initialDen,
    builder: (column) => column,
  );

  GeneratedColumn<int> get qty =>
      $composableBuilder(column: $table.qty, builder: (column) => column);

  GeneratedColumn<int> get numerator =>
      $composableBuilder(column: $table.numerator, builder: (column) => column);

  GeneratedColumn<int> get denominator => $composableBuilder(
    column: $table.denominator,
    builder: (column) => column,
  );

  GeneratedColumn<String> get preferredUnit => $composableBuilder(
    column: $table.preferredUnit,
    builder: (column) => column,
  );

  GeneratedColumn<int> get themeValue => $composableBuilder(
    column: $table.themeValue,
    builder: (column) => column,
  );

  Expression<T> specsRefs<T extends Object>(
    Expression<T> Function($$SpecsTableAnnotationComposer a) f,
  ) {
    final $$SpecsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.specs,
      getReferencedColumn: (t) => t.pillId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SpecsTableAnnotationComposer(
            $db: $db,
            $table: $db.specs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> plansRefs<T extends Object>(
    Expression<T> Function($$PlansTableAnnotationComposer a) f,
  ) {
    final $$PlansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.plans,
      getReferencedColumn: (t) => t.pillId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlansTableAnnotationComposer(
            $db: $db,
            $table: $db.plans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> transactionsRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.pillId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PillsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PillsTable,
          Pill,
          $$PillsTableFilterComposer,
          $$PillsTableOrderingComposer,
          $$PillsTableAnnotationComposer,
          $$PillsTableCreateCompanionBuilder,
          $$PillsTableUpdateCompanionBuilder,
          (Pill, $$PillsTableReferences),
          Pill,
          PrefetchHooks Function({
            bool specsRefs,
            bool plansRefs,
            bool transactionsRefs,
          })
        > {
  $$PillsTableTableManager(_$AppDatabase db, $PillsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$PillsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$PillsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$PillsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<int> initialQty = const Value.absent(),
                Value<String> initialUnit = const Value.absent(),
                Value<int?> initialNum = const Value.absent(),
                Value<int?> initialDen = const Value.absent(),
                Value<int> qty = const Value.absent(),
                Value<int?> numerator = const Value.absent(),
                Value<int?> denominator = const Value.absent(),
                Value<String?> preferredUnit = const Value.absent(),
                Value<int?> themeValue = const Value.absent(),
              }) => PillsCompanion(
                id: id,
                name: name,
                imagePath: imagePath,
                initialQty: initialQty,
                initialUnit: initialUnit,
                initialNum: initialNum,
                initialDen: initialDen,
                qty: qty,
                numerator: numerator,
                denominator: denominator,
                preferredUnit: preferredUnit,
                themeValue: themeValue,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> imagePath = const Value.absent(),
                required int initialQty,
                required String initialUnit,
                Value<int?> initialNum = const Value.absent(),
                Value<int?> initialDen = const Value.absent(),
                required int qty,
                Value<int?> numerator = const Value.absent(),
                Value<int?> denominator = const Value.absent(),
                Value<String?> preferredUnit = const Value.absent(),
                Value<int?> themeValue = const Value.absent(),
              }) => PillsCompanion.insert(
                id: id,
                name: name,
                imagePath: imagePath,
                initialQty: initialQty,
                initialUnit: initialUnit,
                initialNum: initialNum,
                initialDen: initialDen,
                qty: qty,
                numerator: numerator,
                denominator: denominator,
                preferredUnit: preferredUnit,
                themeValue: themeValue,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$PillsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({
            specsRefs = false,
            plansRefs = false,
            transactionsRefs = false,
          }) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (specsRefs) db.specs,
                if (plansRefs) db.plans,
                if (transactionsRefs) db.transactions,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (specsRefs)
                    await $_getPrefetchedData<Pill, $PillsTable, Spec>(
                      currentTable: table,
                      referencedTable: $$PillsTableReferences._specsRefsTable(
                        db,
                      ),
                      managerFromTypedResult:
                          (p0) =>
                              $$PillsTableReferences(db, table, p0).specsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) =>
                              referencedItems.where((e) => e.pillId == item.id),
                      typedResults: items,
                    ),
                  if (plansRefs)
                    await $_getPrefetchedData<Pill, $PillsTable, Plan>(
                      currentTable: table,
                      referencedTable: $$PillsTableReferences._plansRefsTable(
                        db,
                      ),
                      managerFromTypedResult:
                          (p0) =>
                              $$PillsTableReferences(db, table, p0).plansRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) =>
                              referencedItems.where((e) => e.pillId == item.id),
                      typedResults: items,
                    ),
                  if (transactionsRefs)
                    await $_getPrefetchedData<Pill, $PillsTable, Transaction>(
                      currentTable: table,
                      referencedTable: $$PillsTableReferences
                          ._transactionsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$PillsTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) =>
                              referencedItems.where((e) => e.pillId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PillsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PillsTable,
      Pill,
      $$PillsTableFilterComposer,
      $$PillsTableOrderingComposer,
      $$PillsTableAnnotationComposer,
      $$PillsTableCreateCompanionBuilder,
      $$PillsTableUpdateCompanionBuilder,
      (Pill, $$PillsTableReferences),
      Pill,
      PrefetchHooks Function({
        bool specsRefs,
        bool plansRefs,
        bool transactionsRefs,
      })
    >;
typedef $$SpecsTableCreateCompanionBuilder =
    SpecsCompanion Function({
      Value<int> id,
      required int pillId,
      required int qty,
      required String unit,
      required int orderIndex,
    });
typedef $$SpecsTableUpdateCompanionBuilder =
    SpecsCompanion Function({
      Value<int> id,
      Value<int> pillId,
      Value<int> qty,
      Value<String> unit,
      Value<int> orderIndex,
    });

final class $$SpecsTableReferences
    extends BaseReferences<_$AppDatabase, $SpecsTable, Spec> {
  $$SpecsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PillsTable _pillIdTable(_$AppDatabase db) =>
      db.pills.createAlias($_aliasNameGenerator(db.specs.pillId, db.pills.id));

  $$PillsTableProcessedTableManager get pillId {
    final $_column = $_itemColumn<int>('pill_id')!;

    final manager = $$PillsTableTableManager(
      $_db,
      $_db.pills,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_pillIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SpecsTableFilterComposer extends Composer<_$AppDatabase, $SpecsTable> {
  $$SpecsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  $$PillsTableFilterComposer get pillId {
    final $$PillsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pillId,
      referencedTable: $db.pills,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PillsTableFilterComposer(
            $db: $db,
            $table: $db.pills,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SpecsTableOrderingComposer
    extends Composer<_$AppDatabase, $SpecsTable> {
  $$SpecsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  $$PillsTableOrderingComposer get pillId {
    final $$PillsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pillId,
      referencedTable: $db.pills,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PillsTableOrderingComposer(
            $db: $db,
            $table: $db.pills,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SpecsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SpecsTable> {
  $$SpecsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get qty =>
      $composableBuilder(column: $table.qty, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  $$PillsTableAnnotationComposer get pillId {
    final $$PillsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pillId,
      referencedTable: $db.pills,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PillsTableAnnotationComposer(
            $db: $db,
            $table: $db.pills,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SpecsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SpecsTable,
          Spec,
          $$SpecsTableFilterComposer,
          $$SpecsTableOrderingComposer,
          $$SpecsTableAnnotationComposer,
          $$SpecsTableCreateCompanionBuilder,
          $$SpecsTableUpdateCompanionBuilder,
          (Spec, $$SpecsTableReferences),
          Spec,
          PrefetchHooks Function({bool pillId})
        > {
  $$SpecsTableTableManager(_$AppDatabase db, $SpecsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$SpecsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$SpecsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$SpecsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> pillId = const Value.absent(),
                Value<int> qty = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
              }) => SpecsCompanion(
                id: id,
                pillId: pillId,
                qty: qty,
                unit: unit,
                orderIndex: orderIndex,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int pillId,
                required int qty,
                required String unit,
                required int orderIndex,
              }) => SpecsCompanion.insert(
                id: id,
                pillId: pillId,
                qty: qty,
                unit: unit,
                orderIndex: orderIndex,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$SpecsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({pillId = false}) {
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
                  dynamic
                >
              >(state) {
                if (pillId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.pillId,
                            referencedTable: $$SpecsTableReferences
                                ._pillIdTable(db),
                            referencedColumn:
                                $$SpecsTableReferences._pillIdTable(db).id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SpecsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SpecsTable,
      Spec,
      $$SpecsTableFilterComposer,
      $$SpecsTableOrderingComposer,
      $$SpecsTableAnnotationComposer,
      $$SpecsTableCreateCompanionBuilder,
      $$SpecsTableUpdateCompanionBuilder,
      (Spec, $$SpecsTableReferences),
      Spec,
      PrefetchHooks Function({bool pillId})
    >;
typedef $$PlansTableCreateCompanionBuilder =
    PlansCompanion Function({
      Value<int> id,
      required int pillId,
      required bool isEnabled,
      required String name,
      required int qty,
      required String unit,
      Value<int?> numerator,
      Value<int?> denominator,
      required String startDate,
      required String endDate,
      required String repeatValues,
      required String repeatUnit,
      required String startTime,
      required bool isExactTime,
      Value<int?> duration,
      Value<String?> durationUnit,
      Value<int?> reminderValue,
      Value<String?> reminderUnit,
      Value<String?> reminderMethod,
    });
typedef $$PlansTableUpdateCompanionBuilder =
    PlansCompanion Function({
      Value<int> id,
      Value<int> pillId,
      Value<bool> isEnabled,
      Value<String> name,
      Value<int> qty,
      Value<String> unit,
      Value<int?> numerator,
      Value<int?> denominator,
      Value<String> startDate,
      Value<String> endDate,
      Value<String> repeatValues,
      Value<String> repeatUnit,
      Value<String> startTime,
      Value<bool> isExactTime,
      Value<int?> duration,
      Value<String?> durationUnit,
      Value<int?> reminderValue,
      Value<String?> reminderUnit,
      Value<String?> reminderMethod,
    });

final class $$PlansTableReferences
    extends BaseReferences<_$AppDatabase, $PlansTable, Plan> {
  $$PlansTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PillsTable _pillIdTable(_$AppDatabase db) =>
      db.pills.createAlias($_aliasNameGenerator(db.plans.pillId, db.pills.id));

  $$PillsTableProcessedTableManager get pillId {
    final $_column = $_itemColumn<int>('pill_id')!;

    final manager = $$PillsTableTableManager(
      $_db,
      $_db.pills,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_pillIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$CyclesTable, List<Cycle>> _cyclesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.cycles,
    aliasName: $_aliasNameGenerator(db.plans.id, db.cycles.planId),
  );

  $$CyclesTableProcessedTableManager get cyclesRefs {
    final manager = $$CyclesTableTableManager(
      $_db,
      $_db.cycles,
    ).filter((f) => f.planId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_cyclesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
  _transactionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactions,
    aliasName: $_aliasNameGenerator(db.plans.id, db.transactions.planId),
  );

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.planId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PlansTableFilterComposer extends Composer<_$AppDatabase, $PlansTable> {
  $$PlansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get numerator => $composableBuilder(
    column: $table.numerator,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get denominator => $composableBuilder(
    column: $table.denominator,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repeatValues => $composableBuilder(
    column: $table.repeatValues,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repeatUnit => $composableBuilder(
    column: $table.repeatUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isExactTime => $composableBuilder(
    column: $table.isExactTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get durationUnit => $composableBuilder(
    column: $table.durationUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reminderValue => $composableBuilder(
    column: $table.reminderValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reminderUnit => $composableBuilder(
    column: $table.reminderUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reminderMethod => $composableBuilder(
    column: $table.reminderMethod,
    builder: (column) => ColumnFilters(column),
  );

  $$PillsTableFilterComposer get pillId {
    final $$PillsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pillId,
      referencedTable: $db.pills,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PillsTableFilterComposer(
            $db: $db,
            $table: $db.pills,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> cyclesRefs(
    Expression<bool> Function($$CyclesTableFilterComposer f) f,
  ) {
    final $$CyclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cycles,
      getReferencedColumn: (t) => t.planId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CyclesTableFilterComposer(
            $db: $db,
            $table: $db.cycles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> transactionsRefs(
    Expression<bool> Function($$TransactionsTableFilterComposer f) f,
  ) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.planId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlansTableOrderingComposer
    extends Composer<_$AppDatabase, $PlansTable> {
  $$PlansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get numerator => $composableBuilder(
    column: $table.numerator,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get denominator => $composableBuilder(
    column: $table.denominator,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repeatValues => $composableBuilder(
    column: $table.repeatValues,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repeatUnit => $composableBuilder(
    column: $table.repeatUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isExactTime => $composableBuilder(
    column: $table.isExactTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get durationUnit => $composableBuilder(
    column: $table.durationUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reminderValue => $composableBuilder(
    column: $table.reminderValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reminderUnit => $composableBuilder(
    column: $table.reminderUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reminderMethod => $composableBuilder(
    column: $table.reminderMethod,
    builder: (column) => ColumnOrderings(column),
  );

  $$PillsTableOrderingComposer get pillId {
    final $$PillsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pillId,
      referencedTable: $db.pills,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PillsTableOrderingComposer(
            $db: $db,
            $table: $db.pills,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlansTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlansTable> {
  $$PlansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get isEnabled =>
      $composableBuilder(column: $table.isEnabled, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get qty =>
      $composableBuilder(column: $table.qty, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<int> get numerator =>
      $composableBuilder(column: $table.numerator, builder: (column) => column);

  GeneratedColumn<int> get denominator => $composableBuilder(
    column: $table.denominator,
    builder: (column) => column,
  );

  GeneratedColumn<String> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<String> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<String> get repeatValues => $composableBuilder(
    column: $table.repeatValues,
    builder: (column) => column,
  );

  GeneratedColumn<String> get repeatUnit => $composableBuilder(
    column: $table.repeatUnit,
    builder: (column) => column,
  );

  GeneratedColumn<String> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<bool> get isExactTime => $composableBuilder(
    column: $table.isExactTime,
    builder: (column) => column,
  );

  GeneratedColumn<int> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);

  GeneratedColumn<String> get durationUnit => $composableBuilder(
    column: $table.durationUnit,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reminderValue => $composableBuilder(
    column: $table.reminderValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reminderUnit => $composableBuilder(
    column: $table.reminderUnit,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reminderMethod => $composableBuilder(
    column: $table.reminderMethod,
    builder: (column) => column,
  );

  $$PillsTableAnnotationComposer get pillId {
    final $$PillsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pillId,
      referencedTable: $db.pills,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PillsTableAnnotationComposer(
            $db: $db,
            $table: $db.pills,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> cyclesRefs<T extends Object>(
    Expression<T> Function($$CyclesTableAnnotationComposer a) f,
  ) {
    final $$CyclesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cycles,
      getReferencedColumn: (t) => t.planId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CyclesTableAnnotationComposer(
            $db: $db,
            $table: $db.cycles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> transactionsRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.planId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlansTable,
          Plan,
          $$PlansTableFilterComposer,
          $$PlansTableOrderingComposer,
          $$PlansTableAnnotationComposer,
          $$PlansTableCreateCompanionBuilder,
          $$PlansTableUpdateCompanionBuilder,
          (Plan, $$PlansTableReferences),
          Plan,
          PrefetchHooks Function({
            bool pillId,
            bool cyclesRefs,
            bool transactionsRefs,
          })
        > {
  $$PlansTableTableManager(_$AppDatabase db, $PlansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$PlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$PlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$PlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> pillId = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> qty = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<int?> numerator = const Value.absent(),
                Value<int?> denominator = const Value.absent(),
                Value<String> startDate = const Value.absent(),
                Value<String> endDate = const Value.absent(),
                Value<String> repeatValues = const Value.absent(),
                Value<String> repeatUnit = const Value.absent(),
                Value<String> startTime = const Value.absent(),
                Value<bool> isExactTime = const Value.absent(),
                Value<int?> duration = const Value.absent(),
                Value<String?> durationUnit = const Value.absent(),
                Value<int?> reminderValue = const Value.absent(),
                Value<String?> reminderUnit = const Value.absent(),
                Value<String?> reminderMethod = const Value.absent(),
              }) => PlansCompanion(
                id: id,
                pillId: pillId,
                isEnabled: isEnabled,
                name: name,
                qty: qty,
                unit: unit,
                numerator: numerator,
                denominator: denominator,
                startDate: startDate,
                endDate: endDate,
                repeatValues: repeatValues,
                repeatUnit: repeatUnit,
                startTime: startTime,
                isExactTime: isExactTime,
                duration: duration,
                durationUnit: durationUnit,
                reminderValue: reminderValue,
                reminderUnit: reminderUnit,
                reminderMethod: reminderMethod,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int pillId,
                required bool isEnabled,
                required String name,
                required int qty,
                required String unit,
                Value<int?> numerator = const Value.absent(),
                Value<int?> denominator = const Value.absent(),
                required String startDate,
                required String endDate,
                required String repeatValues,
                required String repeatUnit,
                required String startTime,
                required bool isExactTime,
                Value<int?> duration = const Value.absent(),
                Value<String?> durationUnit = const Value.absent(),
                Value<int?> reminderValue = const Value.absent(),
                Value<String?> reminderUnit = const Value.absent(),
                Value<String?> reminderMethod = const Value.absent(),
              }) => PlansCompanion.insert(
                id: id,
                pillId: pillId,
                isEnabled: isEnabled,
                name: name,
                qty: qty,
                unit: unit,
                numerator: numerator,
                denominator: denominator,
                startDate: startDate,
                endDate: endDate,
                repeatValues: repeatValues,
                repeatUnit: repeatUnit,
                startTime: startTime,
                isExactTime: isExactTime,
                duration: duration,
                durationUnit: durationUnit,
                reminderValue: reminderValue,
                reminderUnit: reminderUnit,
                reminderMethod: reminderMethod,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$PlansTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({
            pillId = false,
            cyclesRefs = false,
            transactionsRefs = false,
          }) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (cyclesRefs) db.cycles,
                if (transactionsRefs) db.transactions,
              ],
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
                  dynamic
                >
              >(state) {
                if (pillId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.pillId,
                            referencedTable: $$PlansTableReferences
                                ._pillIdTable(db),
                            referencedColumn:
                                $$PlansTableReferences._pillIdTable(db).id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (cyclesRefs)
                    await $_getPrefetchedData<Plan, $PlansTable, Cycle>(
                      currentTable: table,
                      referencedTable: $$PlansTableReferences._cyclesRefsTable(
                        db,
                      ),
                      managerFromTypedResult:
                          (p0) =>
                              $$PlansTableReferences(db, table, p0).cyclesRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) =>
                              referencedItems.where((e) => e.planId == item.id),
                      typedResults: items,
                    ),
                  if (transactionsRefs)
                    await $_getPrefetchedData<Plan, $PlansTable, Transaction>(
                      currentTable: table,
                      referencedTable: $$PlansTableReferences
                          ._transactionsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$PlansTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) =>
                              referencedItems.where((e) => e.planId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PlansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlansTable,
      Plan,
      $$PlansTableFilterComposer,
      $$PlansTableOrderingComposer,
      $$PlansTableAnnotationComposer,
      $$PlansTableCreateCompanionBuilder,
      $$PlansTableUpdateCompanionBuilder,
      (Plan, $$PlansTableReferences),
      Plan,
      PrefetchHooks Function({
        bool pillId,
        bool cyclesRefs,
        bool transactionsRefs,
      })
    >;
typedef $$CyclesTableCreateCompanionBuilder =
    CyclesCompanion Function({
      Value<int> id,
      required int planId,
      required int value,
      required String unit,
      required bool isStop,
      required int orderIndex,
    });
typedef $$CyclesTableUpdateCompanionBuilder =
    CyclesCompanion Function({
      Value<int> id,
      Value<int> planId,
      Value<int> value,
      Value<String> unit,
      Value<bool> isStop,
      Value<int> orderIndex,
    });

final class $$CyclesTableReferences
    extends BaseReferences<_$AppDatabase, $CyclesTable, Cycle> {
  $$CyclesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PlansTable _planIdTable(_$AppDatabase db) =>
      db.plans.createAlias($_aliasNameGenerator(db.cycles.planId, db.plans.id));

  $$PlansTableProcessedTableManager get planId {
    final $_column = $_itemColumn<int>('plan_id')!;

    final manager = $$PlansTableTableManager(
      $_db,
      $_db.plans,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_planIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CyclesTableFilterComposer
    extends Composer<_$AppDatabase, $CyclesTable> {
  $$CyclesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isStop => $composableBuilder(
    column: $table.isStop,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  $$PlansTableFilterComposer get planId {
    final $$PlansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.plans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlansTableFilterComposer(
            $db: $db,
            $table: $db.plans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CyclesTableOrderingComposer
    extends Composer<_$AppDatabase, $CyclesTable> {
  $$CyclesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isStop => $composableBuilder(
    column: $table.isStop,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  $$PlansTableOrderingComposer get planId {
    final $$PlansTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.plans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlansTableOrderingComposer(
            $db: $db,
            $table: $db.plans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CyclesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CyclesTable> {
  $$CyclesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<bool> get isStop =>
      $composableBuilder(column: $table.isStop, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  $$PlansTableAnnotationComposer get planId {
    final $$PlansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.plans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlansTableAnnotationComposer(
            $db: $db,
            $table: $db.plans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CyclesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CyclesTable,
          Cycle,
          $$CyclesTableFilterComposer,
          $$CyclesTableOrderingComposer,
          $$CyclesTableAnnotationComposer,
          $$CyclesTableCreateCompanionBuilder,
          $$CyclesTableUpdateCompanionBuilder,
          (Cycle, $$CyclesTableReferences),
          Cycle,
          PrefetchHooks Function({bool planId})
        > {
  $$CyclesTableTableManager(_$AppDatabase db, $CyclesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$CyclesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$CyclesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$CyclesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> planId = const Value.absent(),
                Value<int> value = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<bool> isStop = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
              }) => CyclesCompanion(
                id: id,
                planId: planId,
                value: value,
                unit: unit,
                isStop: isStop,
                orderIndex: orderIndex,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int planId,
                required int value,
                required String unit,
                required bool isStop,
                required int orderIndex,
              }) => CyclesCompanion.insert(
                id: id,
                planId: planId,
                value: value,
                unit: unit,
                isStop: isStop,
                orderIndex: orderIndex,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$CyclesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({planId = false}) {
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
                  dynamic
                >
              >(state) {
                if (planId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.planId,
                            referencedTable: $$CyclesTableReferences
                                ._planIdTable(db),
                            referencedColumn:
                                $$CyclesTableReferences._planIdTable(db).id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CyclesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CyclesTable,
      Cycle,
      $$CyclesTableFilterComposer,
      $$CyclesTableOrderingComposer,
      $$CyclesTableAnnotationComposer,
      $$CyclesTableCreateCompanionBuilder,
      $$CyclesTableUpdateCompanionBuilder,
      (Cycle, $$CyclesTableReferences),
      Cycle,
      PrefetchHooks Function({bool planId})
    >;
typedef $$TransactionsTableCreateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> id,
      required int pillId,
      Value<int?> planId,
      Value<String> calcQty,
      required bool isNegative,
      required DateTime timestamp,
      Value<String?> remark,
      required bool isCustom,
      required DateTime startTime,
      Value<DateTime?> endTime,
    });
typedef $$TransactionsTableUpdateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> id,
      Value<int> pillId,
      Value<int?> planId,
      Value<String> calcQty,
      Value<bool> isNegative,
      Value<DateTime> timestamp,
      Value<String?> remark,
      Value<bool> isCustom,
      Value<DateTime> startTime,
      Value<DateTime?> endTime,
    });

final class $$TransactionsTableReferences
    extends BaseReferences<_$AppDatabase, $TransactionsTable, Transaction> {
  $$TransactionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PillsTable _pillIdTable(_$AppDatabase db) => db.pills.createAlias(
    $_aliasNameGenerator(db.transactions.pillId, db.pills.id),
  );

  $$PillsTableProcessedTableManager get pillId {
    final $_column = $_itemColumn<int>('pill_id')!;

    final manager = $$PillsTableTableManager(
      $_db,
      $_db.pills,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_pillIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PlansTable _planIdTable(_$AppDatabase db) => db.plans.createAlias(
    $_aliasNameGenerator(db.transactions.planId, db.plans.id),
  );

  $$PlansTableProcessedTableManager? get planId {
    final $_column = $_itemColumn<int>('plan_id');
    if ($_column == null) return null;
    final manager = $$PlansTableTableManager(
      $_db,
      $_db.plans,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_planIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$QuantitiesTable, List<Quantity>>
  _quantitiesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.quantities,
    aliasName: $_aliasNameGenerator(
      db.transactions.id,
      db.quantities.transactionId,
    ),
  );

  $$QuantitiesTableProcessedTableManager get quantitiesRefs {
    final manager = $$QuantitiesTableTableManager(
      $_db,
      $_db.quantities,
    ).filter((f) => f.transactionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_quantitiesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get calcQty => $composableBuilder(
    column: $table.calcQty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isNegative => $composableBuilder(
    column: $table.isNegative,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remark => $composableBuilder(
    column: $table.remark,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  $$PillsTableFilterComposer get pillId {
    final $$PillsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pillId,
      referencedTable: $db.pills,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PillsTableFilterComposer(
            $db: $db,
            $table: $db.pills,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlansTableFilterComposer get planId {
    final $$PlansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.plans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlansTableFilterComposer(
            $db: $db,
            $table: $db.plans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> quantitiesRefs(
    Expression<bool> Function($$QuantitiesTableFilterComposer f) f,
  ) {
    final $$QuantitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quantities,
      getReferencedColumn: (t) => t.transactionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuantitiesTableFilterComposer(
            $db: $db,
            $table: $db.quantities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get calcQty => $composableBuilder(
    column: $table.calcQty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isNegative => $composableBuilder(
    column: $table.isNegative,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remark => $composableBuilder(
    column: $table.remark,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  $$PillsTableOrderingComposer get pillId {
    final $$PillsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pillId,
      referencedTable: $db.pills,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PillsTableOrderingComposer(
            $db: $db,
            $table: $db.pills,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlansTableOrderingComposer get planId {
    final $$PlansTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.plans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlansTableOrderingComposer(
            $db: $db,
            $table: $db.plans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get calcQty =>
      $composableBuilder(column: $table.calcQty, builder: (column) => column);

  GeneratedColumn<bool> get isNegative => $composableBuilder(
    column: $table.isNegative,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get remark =>
      $composableBuilder(column: $table.remark, builder: (column) => column);

  GeneratedColumn<bool> get isCustom =>
      $composableBuilder(column: $table.isCustom, builder: (column) => column);

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  $$PillsTableAnnotationComposer get pillId {
    final $$PillsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pillId,
      referencedTable: $db.pills,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PillsTableAnnotationComposer(
            $db: $db,
            $table: $db.pills,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlansTableAnnotationComposer get planId {
    final $$PlansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.plans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlansTableAnnotationComposer(
            $db: $db,
            $table: $db.plans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> quantitiesRefs<T extends Object>(
    Expression<T> Function($$QuantitiesTableAnnotationComposer a) f,
  ) {
    final $$QuantitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quantities,
      getReferencedColumn: (t) => t.transactionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuantitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.quantities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionsTable,
          Transaction,
          $$TransactionsTableFilterComposer,
          $$TransactionsTableOrderingComposer,
          $$TransactionsTableAnnotationComposer,
          $$TransactionsTableCreateCompanionBuilder,
          $$TransactionsTableUpdateCompanionBuilder,
          (Transaction, $$TransactionsTableReferences),
          Transaction,
          PrefetchHooks Function({
            bool pillId,
            bool planId,
            bool quantitiesRefs,
          })
        > {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> pillId = const Value.absent(),
                Value<int?> planId = const Value.absent(),
                Value<String> calcQty = const Value.absent(),
                Value<bool> isNegative = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<String?> remark = const Value.absent(),
                Value<bool> isCustom = const Value.absent(),
                Value<DateTime> startTime = const Value.absent(),
                Value<DateTime?> endTime = const Value.absent(),
              }) => TransactionsCompanion(
                id: id,
                pillId: pillId,
                planId: planId,
                calcQty: calcQty,
                isNegative: isNegative,
                timestamp: timestamp,
                remark: remark,
                isCustom: isCustom,
                startTime: startTime,
                endTime: endTime,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int pillId,
                Value<int?> planId = const Value.absent(),
                Value<String> calcQty = const Value.absent(),
                required bool isNegative,
                required DateTime timestamp,
                Value<String?> remark = const Value.absent(),
                required bool isCustom,
                required DateTime startTime,
                Value<DateTime?> endTime = const Value.absent(),
              }) => TransactionsCompanion.insert(
                id: id,
                pillId: pillId,
                planId: planId,
                calcQty: calcQty,
                isNegative: isNegative,
                timestamp: timestamp,
                remark: remark,
                isCustom: isCustom,
                startTime: startTime,
                endTime: endTime,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$TransactionsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({
            pillId = false,
            planId = false,
            quantitiesRefs = false,
          }) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (quantitiesRefs) db.quantities],
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
                  dynamic
                >
              >(state) {
                if (pillId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.pillId,
                            referencedTable: $$TransactionsTableReferences
                                ._pillIdTable(db),
                            referencedColumn:
                                $$TransactionsTableReferences
                                    ._pillIdTable(db)
                                    .id,
                          )
                          as T;
                }
                if (planId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.planId,
                            referencedTable: $$TransactionsTableReferences
                                ._planIdTable(db),
                            referencedColumn:
                                $$TransactionsTableReferences
                                    ._planIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (quantitiesRefs)
                    await $_getPrefetchedData<
                      Transaction,
                      $TransactionsTable,
                      Quantity
                    >(
                      currentTable: table,
                      referencedTable: $$TransactionsTableReferences
                          ._quantitiesRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$TransactionsTableReferences(
                                db,
                                table,
                                p0,
                              ).quantitiesRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.transactionId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionsTable,
      Transaction,
      $$TransactionsTableFilterComposer,
      $$TransactionsTableOrderingComposer,
      $$TransactionsTableAnnotationComposer,
      $$TransactionsTableCreateCompanionBuilder,
      $$TransactionsTableUpdateCompanionBuilder,
      (Transaction, $$TransactionsTableReferences),
      Transaction,
      PrefetchHooks Function({bool pillId, bool planId, bool quantitiesRefs})
    >;
typedef $$QuantitiesTableCreateCompanionBuilder =
    QuantitiesCompanion Function({
      Value<int> id,
      required int transactionId,
      required int qty,
      required String unit,
      Value<int?> numerator,
      Value<int?> denominator,
    });
typedef $$QuantitiesTableUpdateCompanionBuilder =
    QuantitiesCompanion Function({
      Value<int> id,
      Value<int> transactionId,
      Value<int> qty,
      Value<String> unit,
      Value<int?> numerator,
      Value<int?> denominator,
    });

final class $$QuantitiesTableReferences
    extends BaseReferences<_$AppDatabase, $QuantitiesTable, Quantity> {
  $$QuantitiesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TransactionsTable _transactionIdTable(_$AppDatabase db) =>
      db.transactions.createAlias(
        $_aliasNameGenerator(db.quantities.transactionId, db.transactions.id),
      );

  $$TransactionsTableProcessedTableManager get transactionId {
    final $_column = $_itemColumn<int>('transaction_id')!;

    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_transactionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$QuantitiesTableFilterComposer
    extends Composer<_$AppDatabase, $QuantitiesTable> {
  $$QuantitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get numerator => $composableBuilder(
    column: $table.numerator,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get denominator => $composableBuilder(
    column: $table.denominator,
    builder: (column) => ColumnFilters(column),
  );

  $$TransactionsTableFilterComposer get transactionId {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuantitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $QuantitiesTable> {
  $$QuantitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get numerator => $composableBuilder(
    column: $table.numerator,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get denominator => $composableBuilder(
    column: $table.denominator,
    builder: (column) => ColumnOrderings(column),
  );

  $$TransactionsTableOrderingComposer get transactionId {
    final $$TransactionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableOrderingComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuantitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuantitiesTable> {
  $$QuantitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get qty =>
      $composableBuilder(column: $table.qty, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<int> get numerator =>
      $composableBuilder(column: $table.numerator, builder: (column) => column);

  GeneratedColumn<int> get denominator => $composableBuilder(
    column: $table.denominator,
    builder: (column) => column,
  );

  $$TransactionsTableAnnotationComposer get transactionId {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuantitiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuantitiesTable,
          Quantity,
          $$QuantitiesTableFilterComposer,
          $$QuantitiesTableOrderingComposer,
          $$QuantitiesTableAnnotationComposer,
          $$QuantitiesTableCreateCompanionBuilder,
          $$QuantitiesTableUpdateCompanionBuilder,
          (Quantity, $$QuantitiesTableReferences),
          Quantity,
          PrefetchHooks Function({bool transactionId})
        > {
  $$QuantitiesTableTableManager(_$AppDatabase db, $QuantitiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$QuantitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$QuantitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$QuantitiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> transactionId = const Value.absent(),
                Value<int> qty = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<int?> numerator = const Value.absent(),
                Value<int?> denominator = const Value.absent(),
              }) => QuantitiesCompanion(
                id: id,
                transactionId: transactionId,
                qty: qty,
                unit: unit,
                numerator: numerator,
                denominator: denominator,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int transactionId,
                required int qty,
                required String unit,
                Value<int?> numerator = const Value.absent(),
                Value<int?> denominator = const Value.absent(),
              }) => QuantitiesCompanion.insert(
                id: id,
                transactionId: transactionId,
                qty: qty,
                unit: unit,
                numerator: numerator,
                denominator: denominator,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$QuantitiesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({transactionId = false}) {
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
                  dynamic
                >
              >(state) {
                if (transactionId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.transactionId,
                            referencedTable: $$QuantitiesTableReferences
                                ._transactionIdTable(db),
                            referencedColumn:
                                $$QuantitiesTableReferences
                                    ._transactionIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$QuantitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuantitiesTable,
      Quantity,
      $$QuantitiesTableFilterComposer,
      $$QuantitiesTableOrderingComposer,
      $$QuantitiesTableAnnotationComposer,
      $$QuantitiesTableCreateCompanionBuilder,
      $$QuantitiesTableUpdateCompanionBuilder,
      (Quantity, $$QuantitiesTableReferences),
      Quantity,
      PrefetchHooks Function({bool transactionId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PillsTableTableManager get pills =>
      $$PillsTableTableManager(_db, _db.pills);
  $$SpecsTableTableManager get specs =>
      $$SpecsTableTableManager(_db, _db.specs);
  $$PlansTableTableManager get plans =>
      $$PlansTableTableManager(_db, _db.plans);
  $$CyclesTableTableManager get cycles =>
      $$CyclesTableTableManager(_db, _db.cycles);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$QuantitiesTableTableManager get quantities =>
      $$QuantitiesTableTableManager(_db, _db.quantities);
}

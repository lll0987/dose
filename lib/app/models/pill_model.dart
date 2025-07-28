import 'package:drift/drift.dart';

import '../database/app_database.dart';
import 'quantity_model.dart';

class PillModel {
  int? id;

  String name;

  String? imagePath; // 图片路径（本地或网络）

  // int initialQty; // 初始数量
  // String initialUnit; // 初始数量单位（粒/瓶/片等）
  // int? initialNum; // 初始数量分子
  // int? initialDen; // 初始数量分母

  QuantityModel initialQuantity; // 初始数量

  // int qty; // 剩余数量
  // int? numerator; // 剩余数量分子
  // int? denominator; // 剩余数量分母

  QuantityModel quantity; // 当前数量

  String? preferredUnit; // 首选单位

  int? themeValue; // 主题色值（存储为ARGB）

  List<SpecModel> packSpecs; // 包装规格列表

  PillModel({
    this.id,
    required this.name,
    this.imagePath,
    required this.initialQuantity,
    required this.quantity,
    this.preferredUnit,
    this.themeValue,
    required this.packSpecs,
  });

  String get defaultUnit => packSpecs.last.unit;

  String get unit =>
      preferredUnit == null || preferredUnit!.isEmpty
          ? defaultUnit
          : preferredUnit!;

  bool get isAnotherUnit =>
      preferredUnit != null &&
      preferredUnit!.isNotEmpty &&
      preferredUnit != packSpecs.last.unit;

  String getQtyText({bool showFraction = false}) {
    int pre = quantity.qty;
    int? last;
    if (isAnotherUnit) {
      final index = packSpecs.indexWhere((spec) => spec.unit == preferredUnit);
      final multi = getTotalQtyMultiple(index);
      pre = quantity.qty ~/ multi;
      last = quantity.qty % multi;
    }

    final isPre = pre != 0;
    final isLast = last != null && last != 0;
    final isFraction = quantity.fraction.isNotEmpty;

    final sign = quantity.isNegative ? '-' : '';
    if (showFraction) {
      // **分数形式**
      final List<String> arr = [];
      if (isPre || (!isAnotherUnit && !isFraction)) {
        arr.add('$pre');
      }
      if (isAnotherUnit && isPre) {
        arr.add(unit);
      }
      if (isLast) {
        arr.add('$last');
      }
      if (isFraction) {
        arr.add(
          '${quantity.fraction.numerator!}/${quantity.fraction.denominator!}',
        );
      }
      if (isLast || isFraction || !isAnotherUnit) {
        arr.add(defaultUnit);
      }
      return sign + arr.join(' ');
    } else {
      // **小数形式**
      if (isAnotherUnit && isPre) {
        final str = quantity.copyWith(qty: last!).toFixed();
        return '$sign$pre$unit$str$defaultUnit';
      }
      final str = quantity.copyWith(qty: isAnotherUnit ? last! : pre).toFixed();
      return '$sign$str$unit';
    }
  }

  int getTotalQtyMultiple(int index) {
    return packSpecs.sublist(index + 1).fold(1, (sum, spec) => sum * spec.qty);
  }

  Pill? toPill() {
    if (id == null) return null;
    return Pill(
      id: id!,
      name: name,
      imagePath: imagePath,
      initialQty: initialQuantity.qty,
      initialUnit: initialQuantity.unit!,
      initialNum: initialQuantity.fraction.numerator,
      initialDen: initialQuantity.fraction.denominator,
      qty: quantity.qty,
      numerator: quantity.fraction.numerator,
      denominator: quantity.fraction.denominator,
      isNegative: quantity.isNegative,
      preferredUnit: preferredUnit,
      themeValue: themeValue,
    );
  }

  PillsCompanion toCompanion() {
    return PillsCompanion(
      name: Value(name),
      imagePath: Value(imagePath),
      initialQty: Value(initialQuantity.qty),
      initialUnit: Value(initialQuantity.unit!),
      initialNum: Value(initialQuantity.fraction.numerator),
      initialDen: Value(initialQuantity.fraction.denominator),
      qty: Value(quantity.qty),
      numerator: Value(quantity.fraction.numerator),
      denominator: Value(quantity.fraction.denominator),
      isNegative: Value(quantity.isNegative),
      preferredUnit: Value(preferredUnit),
      themeValue: Value(themeValue),
    );
  }

  static PillModel fromPill(Pill pill, List<SpecModel> packSpecs) {
    return PillModel(
      id: pill.id,
      name: pill.name,
      imagePath: pill.imagePath,
      initialQuantity: QuantityModel(
        qty: pill.initialQty,
        unit: pill.initialUnit,
        fraction: FractionModel(pill.initialNum, pill.initialDen),
      ),
      quantity: QuantityModel(
        qty: pill.qty,
        fraction: FractionModel(pill.numerator, pill.denominator),
        isNegative: pill.isNegative ?? false,
      ),
      preferredUnit: pill.preferredUnit,
      themeValue: pill.themeValue,
      packSpecs: packSpecs,
    );
  }

  PillModel copyWith({
    int? id,
    String? name,
    String? imagePath,
    QuantityModel? initialQuantity,
    QuantityModel? quantity,
    String? preferredUnit,
    int? themeValue,
    List<SpecModel>? packSpecs,
  }) {
    return PillModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      initialQuantity: initialQuantity ?? this.initialQuantity,
      quantity: quantity ?? this.quantity,
      preferredUnit: preferredUnit ?? this.preferredUnit,
      themeValue: themeValue ?? this.themeValue,
      packSpecs: packSpecs ?? this.packSpecs,
    );
  }
}

class SpecModel {
  int qty;
  String unit;

  SpecModel({required this.qty, required this.unit});
}

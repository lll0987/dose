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

  String getUnit() {
    return preferredUnit == null || preferredUnit!.isEmpty
        ? packSpecs.last.unit
        : preferredUnit!;
  }

  (int, int?) _getPreQty(int quantity) {
    if (preferredUnit == null ||
        preferredUnit!.isEmpty ||
        preferredUnit == packSpecs.last.unit) {
      return (quantity, null);
    }
    final index = packSpecs.indexWhere((spec) => spec.unit == preferredUnit);
    final multi = getTotalQtyMultiple(index);
    return (quantity ~/ multi, quantity % multi);
  }

  String getQtyText() {
    final (qty, q) = _getPreQty(quantity.qty);
    final unit = getUnit();
    final defaultUnit = packSpecs.last.unit;
    String text = '$qty$unit';
    if (q != null) text += '$q$defaultUnit';
    if (quantity.fraction.isNotEmpty) {
      text +=
          ' + ${quantity.fraction.numerator!}/${quantity.fraction.denominator!}$defaultUnit';
    }
    return text;
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
      ),
      preferredUnit: pill.preferredUnit,
      themeValue: pill.themeValue,
      packSpecs: packSpecs,
    );
  }
}

class SpecModel {
  int qty;
  String unit;

  SpecModel({required this.qty, required this.unit});
}

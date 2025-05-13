import 'package:drift/drift.dart';
import 'package:flutter/material.dart';

import '../database/app_database.dart';

class PillModel {
  int? id;

  String name;

  String? imagePath; // 图片路径（本地或网络）

  int initialQty; // 初始数量

  String initialUnit; // 初始数量单位（粒/瓶/片等）

  int? initialNum; // 初始数量分子

  int? initialDen; // 初始数量分母

  int qty; // 剩余数量

  int? numerator; // 剩余数量分子

  int? denominator; // 剩余数量分母

  String? preferredUnit; // 首选单位

  int? themeValue; // 主题色值（存储为ARGB）

  List<SpecModel> packSpecs; // 包装规格列表

  PillModel({
    this.id,
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
    required this.packSpecs,
  });

  // 主题色 Getter（支持联动 App 主题）
  Color getThemeColor() {
    return themeValue != null ? Color(themeValue!) : Colors.lightGreen;
  }

  String getUnit() {
    return preferredUnit == null || preferredUnit!.isEmpty
        ? packSpecs.last.unit
        : preferredUnit!;
  }

  int getPreQty(int quantity) {
    if (preferredUnit == null || preferredUnit!.isEmpty) return quantity;
    if (preferredUnit == packSpecs.last.unit) return quantity;
    final index = packSpecs.indexWhere((spec) => spec.unit == preferredUnit);
    return packSpecs
        .sublist(index + 1)
        .fold(quantity, (sum, spec) => (sum / spec.qty).round());
  }

  String getQtyText() {
    int q = getPreQty(qty);
    String u = getUnit();
    return numerator == null || denominator == null
        ? '$q$u'
        : '$q$u + ${numerator!}/${denominator!}${packSpecs.last.unit}';
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
      initialQty: initialQty,
      initialUnit: initialUnit,
      initialNum: initialNum,
      initialDen: initialDen,
      qty: qty,
      numerator: numerator,
      denominator: denominator,
      preferredUnit: preferredUnit,
      themeValue: themeValue,
    );
  }

  PillsCompanion toCompanion() {
    return PillsCompanion(
      name: Value(name),
      imagePath: Value(imagePath),
      initialQty: Value(initialQty),
      initialUnit: Value(initialUnit),
      initialNum: Value(initialNum),
      initialDen: Value(initialDen),
      qty: Value(qty),
      numerator: Value(numerator),
      denominator: Value(denominator),
      preferredUnit: Value(preferredUnit),
      themeValue: Value(themeValue),
    );
  }

  static PillModel fromPill(Pill pill, List<SpecModel> packSpecs) {
    return PillModel(
      id: pill.id,
      name: pill.name,
      imagePath: pill.imagePath,
      initialQty: pill.initialQty,
      initialUnit: pill.initialUnit,
      initialNum: pill.initialNum,
      initialDen: pill.initialDen,
      qty: pill.qty,
      numerator: pill.numerator,
      denominator: pill.denominator,
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

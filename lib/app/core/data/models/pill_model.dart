import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

part 'pill_model.g.dart';

@HiveType(typeId: 3)
class PillModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? imagePath; // 图片路径（本地或网络）

  @HiveField(3)
  int initialQty; // 初始数量

  @HiveField(6)
  String initialUnit; // 初始数量单位（粒/瓶/片等）

  @HiveField(4)
  int? initialNum; // 初始数量分子

  @HiveField(9)
  int? initialDen; // 初始数量分母

  @HiveField(5)
  int qty; // 剩余数量

  @HiveField(10)
  int? numerator; // 剩余数量分子

  @HiveField(12)
  int? denominator; // 剩余数量分母

  @HiveField(11)
  String? preferredUnit; // 首选单位

  @HiveField(7)
  int? themeValue; // 主题色值（存储为ARGB）

  @HiveField(8)
  List<Spec> packSpecs; // 包装规格列表

  PillModel({
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
  }) : id = const Uuid().v4(); // 自动生成 UUID 作为 ID

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
}

@HiveType(typeId: 4)
class Spec extends HiveObject {
  @HiveField(0)
  int qty;

  @HiveField(1)
  String unit;

  Spec({required this.qty, required this.unit});
}

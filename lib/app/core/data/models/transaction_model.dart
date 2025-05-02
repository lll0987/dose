import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'transaction_model.g.dart'; // 自动生成的适配器文件

@HiveType(typeId: 5)
class TransactionModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  List<Quantity> quantities;

  @HiveField(2)
  bool isNegative; // 是否减少数量

  @HiveField(3)
  String pillId;

  @HiveField(4)
  String? planId;

  @HiveField(5)
  DateTime timestamp;

  @HiveField(6)
  String? remark;

  @HiveField(7)
  bool isCustom;

  @HiveField(8)
  DateTime startTime;

  @HiveField(9)
  DateTime? endTime;

  TransactionModel({
    required this.quantities,
    this.isNegative = true,
    required this.pillId,
    this.planId,
    required this.timestamp,
    this.remark,
    this.isCustom = false,
    required this.startTime,
    this.endTime,
  }) : id = const Uuid().v4();
}

@HiveType(typeId: 6)
class Quantity {
  @HiveField(0)
  int qty;

  @HiveField(1)
  String unit;

  @HiveField(2)
  int? numerator;

  @HiveField(3)
  int? denominator;

  Quantity({
    required this.qty,
    required this.unit,
    this.numerator,
    this.denominator,
  });
}
